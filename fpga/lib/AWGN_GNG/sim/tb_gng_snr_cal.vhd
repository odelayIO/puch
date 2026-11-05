--#############################################################################################
--#############################################################################################
--#
--#   The MIT License (MIT)
--#
--#   Copyright (c) 2023 http://odelay.io
--#
--#   Permission is hereby granted, free of charge, to any person obtaining a copy
--#   of this software and associated documentation files (the "Software"), to deal
--#   in the Software without restriction, including without limitation the rights
--#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--#   copies of the Software, and to permit persons to whom the Software is
--#   furnished to do so, subject to the following conditions:
--#
--#   The above copyright notice and this permission notice shall be included in all
--#   copies or substantial portions of the Software.
--#
--#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--#   SOFTWARE.
--#
--#   Contact : <everett@odelay.io>
--#
--#   Description : AWGN gain -> SNR calibration testbench for gng_top
--#
--#     Drives a complex tone  x[n] = TONE_AMP * exp(j*2*pi*TONE_BIN*n/TONE_LEN)
--#     into gng_top, sweeps the awgn_noise_gain register over AXI-Lite, and
--#     measures the SNR at B_TDATA for every gain setting.
--#
--#     SNR measurement (reference subtraction):
--#       x[n]    = input tone sample that produced output sample y[n]
--#       P_sig   = (1/N) * sum(|x[n]|^2)
--#       P_noise = (1/N) * sum(|y[n] - x[n]|^2)
--#       SNR_dB  = 10*log10(P_sig / P_noise)
--#     x[n] is regenerated from a phase counter that advances on every output
--#     handshake, so the alignment is independent of the pipeline latency.
--#     Everything the block adds to the signal (AWGN, rounding, clipping)
--#     counts as noise.  As a sanity check the signal gain through the block,
--#     alpha = sum(y*conj(x)) / sum(|x|^2), is reported and must be ~1.
--#
--#     Gain sweep: gain(k+1) = max(gain(k) + GAIN_STEP,
--#                                 round(gain(k) * 10^(GAIN_STEP_DB/20)))
--#       GAIN_STEP_DB = 0.0  -> linear sweep in steps of GAIN_STEP codes
--#       GAIN_STEP_DB > 0.0  -> ~uniform SNR spacing, never less than GAIN_STEP
--#
--#     Output CSV (OUT_FILE), one row per gain setting:
--#       awgn_gain,snr_db
--#       awgn_gain = raw awgn_noise_gain register code (F_AWGN fixed point)
--#
--#     NOTE: SNR is relative to the tone power (TONE_AMP^2).  A signal with a
--#     different power shifts the whole curve by 10*log10(P_signal/TONE_AMP^2).
--#
--#     The default OUT_FILE is relative to the Vivado project xsim run dir
--#     (overlays/<name>/xpr/<name>.sim/sim_1/behav/xsim), same as tb_gng.vhd.
--#     Run with "run all"; the testbench ends itself with std.env.finish.
--#
--#   Version History:
--#
--#       Date        Description
--#     -----------   -----------------------------------------------------------------------
--#      2026-11-05    Original Creation
--#
--###########################################################################################
--###########################################################################################


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use STD.TEXTIO.ALL;

use work.awgn_pkg.all;    -- Corsair register offsets (CSR_*_ADDR)


entity tb_gng_snr_cal is
  generic (
    OUT_FILE        : string  := "../../../../../../../lib/AWGN_GNG/sim/gng_snr_cal.csv";
    -- Complex tone: f = TONE_BIN/TONE_LEN * Fs, amplitude in real units
    TONE_AMP        : real    := 1.0;
    TONE_BIN        : integer := 37;
    TONE_LEN        : integer := 1024;
    -- Gain sweep, in awgn_noise_gain register codes
    GAIN_START      : integer := 1;
    GAIN_STOP       : integer := 4096;
    GAIN_STEP       : integer := 1;
    GAIN_STEP_DB    : real    := 0.25;
    -- Measurement
    N_SAMPLES       : integer := 8192;    -- output samples per SNR measurement
    SETTLE_CYCLES   : integer := 32       -- clocks to flush pipeline after a gain change
  );
end entity;


architecture Behavioral of tb_gng_snr_cal is

  -- ----------------------------------------
  -- Constants
  -- ----------------------------------------
  constant ClkPeriod      : time    := 10.0 ns;
  constant AXIL_ADDR_W    : integer := 8;
  constant AXIL_DATA_W    : integer := 32;
  constant AXIL_STRB_W    : integer := 4;
  constant CH_W           : integer := 16;   -- I/Q width in 32-bit TDATA

  -- ----------------------------------------
  -- Signals
  -- ----------------------------------------
  signal clk              : std_logic := '0';
  signal rstn             : std_logic := '0';

  -- Format read back from DUT registers
  signal fin_fbits        : integer := 0;
  signal tone_en          : std_logic := '0';

  -- Tone phase index of the sample currently on B_TDATA
  signal out_ph           : natural := 0;

  -- AXI-Stream
  signal A_TDATA          : std_logic_vector(31 downto 0) := (others => '0');
  signal A_TVALID         : std_logic := '0';
  signal A_TLAST          : std_logic := '0';
  signal A_TREADY         : std_logic;
  signal B_TDATA          : std_logic_vector(31 downto 0);
  signal B_TVALID         : std_logic;
  signal B_TLAST          : std_logic;
  signal B_TREADY         : std_logic := '1';

  -- AXI-Lite
  signal axil_awaddr      : std_logic_vector(AXIL_ADDR_W-1 downto 0) := (others => '0');
  signal axil_awprot      : std_logic_vector(2 downto 0) := (others => '0');
  signal axil_awvalid     : std_logic := '0';
  signal axil_awready     : std_logic;
  signal axil_wdata       : std_logic_vector(AXIL_DATA_W-1 downto 0) := (others => '0');
  signal axil_wstrb       : std_logic_vector(AXIL_STRB_W-1 downto 0) := (others => '0');
  signal axil_wvalid      : std_logic := '0';
  signal axil_wready      : std_logic;
  signal axil_bresp       : std_logic_vector(1 downto 0);
  signal axil_bvalid      : std_logic;
  signal axil_bready      : std_logic := '0';
  signal axil_araddr      : std_logic_vector(AXIL_ADDR_W-1 downto 0) := (others => '0');
  signal axil_arprot      : std_logic_vector(2 downto 0) := (others => '0');
  signal axil_arvalid     : std_logic := '0';
  signal axil_arready     : std_logic;
  signal axil_rdata       : std_logic_vector(AXIL_DATA_W-1 downto 0);
  signal axil_rresp       : std_logic_vector(1 downto 0);
  signal axil_rvalid      : std_logic;
  signal axil_rready      : std_logic := '0';

  -- ----------------------------------------
  -- Real -> signed fixed point, round + saturate
  -- ----------------------------------------
  function to_fix(x : real; fbits, tbits : integer) return std_logic_vector is
    constant VMAX : integer := 2**(tbits-1) - 1;
    constant VMIN : integer := -(2**(tbits-1));
    variable v    : integer;
  begin
    v := integer(round(x * 2.0**fbits));
    if v > VMAX then
      v := VMAX;
    elsif v < VMIN then
      v := VMIN;
    end if;
    return std_logic_vector(to_signed(v, tbits));
  end function;

  -- ----------------------------------------
  -- Quantized complex tone sample, packed as I & Q
  -- ----------------------------------------
  function tone_iq(ph : natural; fbits : integer) return std_logic_vector is
    constant ang : real := MATH_2_PI * real(ph) / real(TONE_LEN);
  begin
    return to_fix(TONE_AMP * cos(ang), fbits, CH_W) &   -- I
           to_fix(TONE_AMP * sin(ang), fbits, CH_W);    -- Q
  end function;

begin

  -- ----------------------------------------
  -- Clock and Reset
  -- ----------------------------------------
  clk  <= not clk after ClkPeriod / 2;
  rstn <= '0', '1' after ClkPeriod * 20;


  -- ----------------------------------------
  -- Complex tone source (continuous stream)
  -- ----------------------------------------
  tone_gen : process(clk)
    variable ph   : natural := 0;
  begin
    if rising_edge(clk) then
      if rstn = '0' or tone_en = '0' then
        ph        := 0;
        A_TVALID  <= '0';
        A_TDATA   <= (others => '0');
      elsif A_TVALID = '0' or A_TREADY = '1' then
        A_TDATA   <= tone_iq(ph, fin_fbits);
        A_TVALID  <= '1';
        ph        := (ph + TONE_BIN) mod TONE_LEN;
      end if;
    end if;
  end process;


  -- ----------------------------------------
  -- Output phase tracker: the k-th output sample carries the k-th input
  -- sample, so advance the reference phase on every output handshake.
  -- ----------------------------------------
  out_track : process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' or tone_en = '0' then
        out_ph <= 0;
      elsif B_TVALID = '1' and B_TREADY = '1' then
        out_ph <= (out_ph + TONE_BIN) mod TONE_LEN;
      end if;
    end if;
  end process;


  -- ----------------------------------------
  -- Sequencer: configure, sweep, measure, log
  -- ----------------------------------------
  main : process

    file     fcsv       : text;
    variable fstat      : file_open_status;
    variable l          : line;

    variable rd         : std_logic_vector(31 downto 0);
    variable fin_f      : integer;
    variable fout_fbits : integer;
    variable fawgn_fbits: integer;
    variable in_scale   : real;
    variable out_scale  : real;

    variable gain       : integer;
    variable step_mult  : real;

    variable n          : integer;
    variable x          : std_logic_vector(31 downto 0);
    variable xi, xq     : real;
    variable yi, yq     : real;
    variable ei, eq     : real;
    variable acc_xx     : real;     -- sum |x|^2
    variable acc_ee     : real;     -- sum |y-x|^2
    variable acc_yx_re  : real;     -- sum y*conj(x)
    variable acc_yx_im  : real;
    variable alpha_re   : real;
    variable alpha_im   : real;
    variable snr_db     : real;
    variable snr_ideal  : real;
    variable g_real     : real;

    -- AXI-Lite single write (AW and W issued together)
    procedure axil_write(addr : std_logic_vector; data : std_logic_vector(31 downto 0)) is
      variable aw_done, w_done : boolean := false;
    begin
      wait until rising_edge(clk);
      axil_awaddr   <= addr;
      axil_awvalid  <= '1';
      axil_wdata    <= data;
      axil_wstrb    <= (others => '1');
      axil_wvalid   <= '1';
      axil_bready   <= '1';
      while not (aw_done and w_done) loop
        wait until rising_edge(clk);
        if not aw_done and axil_awready = '1' then
          aw_done := true;
          axil_awvalid <= '0';
        end if;
        if not w_done and axil_wready = '1' then
          w_done := true;
          axil_wvalid <= '0';
        end if;
      end loop;
      loop
        wait until rising_edge(clk);
        exit when axil_bvalid = '1';
      end loop;
      axil_bready   <= '0';
    end procedure;

    -- AXI-Lite single read
    procedure axil_read(addr : std_logic_vector; data : out std_logic_vector(31 downto 0)) is
      variable ar_done : boolean := false;
    begin
      wait until rising_edge(clk);
      axil_araddr   <= addr;
      axil_arvalid  <= '1';
      axil_rready   <= '1';
      loop
        wait until rising_edge(clk);
        if not ar_done and axil_arready = '1' then
          ar_done := true;
          axil_arvalid <= '0';
        end if;
        if axil_rvalid = '1' then
          data := axil_rdata;
          exit;
        end if;
      end loop;
      axil_rready   <= '0';
    end procedure;

  begin

    assert GAIN_START >= 0 and GAIN_STOP <= 2**(CH_W-1) - 1 and GAIN_START <= GAIN_STOP
      report "GAIN_START/GAIN_STOP must be within 0 .. 32767" severity failure;
    assert GAIN_STEP >= 1
      report "GAIN_STEP must be >= 1" severity failure;

    wait until rstn = '1';
    for i in 1 to 10 loop
      wait until rising_edge(clk);
    end loop;

    -- ------------------------------------------------
    -- Read fixed-point formats from the DUT
    -- ------------------------------------------------
    axil_read(CSR_F_IN_ADDR, rd);
    fin_f       := to_integer(unsigned(rd(31 downto 16)));
    fin_fbits   <= fin_f;
    axil_read(CSR_F_OUT_ADDR, rd);
    fout_fbits  := to_integer(unsigned(rd(31 downto 16)));
    axil_read(CSR_F_AWGN_ADDR, rd);
    fawgn_fbits := to_integer(unsigned(rd(31 downto 16)));
    in_scale    := 2.0**(-fin_f);
    out_scale   := 2.0**(-fout_fbits);

    report "tb_gng_snr_cal: fractional bits  F_in=" & integer'image(fin_f) &
           "  F_out=" & integer'image(fout_fbits) &
           "  F_awgn=" & integer'image(fawgn_fbits)
      severity note;

    -- ------------------------------------------------
    -- Enable AWGN and start the tone
    -- ------------------------------------------------
    axil_write(CSR_AWGN_NOISE_GAIN_ADDR, x"00000000");
    axil_write(CSR_AWGN_ENABLE_ADDR,     x"00000001");
    tone_en <= '1';

    file_open(fstat, fcsv, OUT_FILE, write_mode);
    assert fstat = open_ok
      report "tb_gng_snr_cal: cannot open OUT_FILE '" & OUT_FILE & "'" severity failure;
    write(l, string'("awgn_gain,snr_db"));
    writeline(fcsv, l);

    -- ------------------------------------------------
    -- Sweep
    -- ------------------------------------------------
    step_mult := 10.0**(GAIN_STEP_DB / 20.0);
    gain      := GAIN_START;

    while gain <= GAIN_STOP loop

      axil_write(CSR_AWGN_NOISE_GAIN_ADDR, std_logic_vector(to_unsigned(gain, 32)));
      axil_read(CSR_AWGN_NOISE_GAIN_ADDR, rd);
      assert to_integer(unsigned(rd(CH_W-1 downto 0))) = gain
        report "tb_gng_snr_cal: awgn_noise_gain readback mismatch" severity error;

      for i in 1 to SETTLE_CYCLES loop
        wait until rising_edge(clk);
      end loop;

      -- Accumulate N_SAMPLES output samples against the input reference
      acc_xx    := 0.0;
      acc_ee    := 0.0;
      acc_yx_re := 0.0;
      acc_yx_im := 0.0;
      n         := 0;
      while n < N_SAMPLES loop
        wait until rising_edge(clk);
        if B_TVALID = '1' and B_TREADY = '1' then
          x         := tone_iq(out_ph, fin_f);
          xi        := real(to_integer(signed(x(2*CH_W-1 downto CH_W)))) * in_scale;
          xq        := real(to_integer(signed(x(CH_W-1 downto 0)))) * in_scale;
          yi        := real(to_integer(signed(B_TDATA(2*CH_W-1 downto CH_W)))) * out_scale;
          yq        := real(to_integer(signed(B_TDATA(CH_W-1 downto 0)))) * out_scale;
          ei        := yi - xi;
          eq        := yq - xq;
          acc_xx    := acc_xx + xi*xi + xq*xq;
          acc_ee    := acc_ee + ei*ei + eq*eq;
          acc_yx_re := acc_yx_re + yi*xi + yq*xq;
          acc_yx_im := acc_yx_im + yq*xi - yi*xq;
          n         := n + 1;
        end if;
      end loop;

      -- Signal gain through the block; ~1+j0 when the reference is aligned
      alpha_re := acc_yx_re / acc_xx;
      alpha_im := acc_yx_im / acc_xx;
      assert sqrt((alpha_re - 1.0)**2 + alpha_im**2) < 0.15
        report "tb_gng_snr_cal: signal gain through DUT is not ~1 at gain " &
               integer'image(gain) & " (alpha=" & real'image(alpha_re) & " + j" &
               real'image(alpha_im) & "), reference may be misaligned"
        severity warning;

      if acc_ee > 0.0 then
        snr_db := 10.0 * log10(acc_xx / acc_ee);
      else
        snr_db := 999.0;
        report "tb_gng_snr_cal: no measurable noise at gain " & integer'image(gain)
          severity warning;
      end if;

      -- Ideal: unit-variance GNG on I and Q, complex noise power = 2*g^2
      g_real := real(gain) * 2.0**(-fawgn_fbits);
      if g_real > 0.0 then
        snr_ideal := 10.0 * log10(TONE_AMP**2 / (2.0 * g_real**2));
      else
        snr_ideal := 999.0;
      end if;

      write(l, gain);
      write(l, string'(","));
      write(l, snr_db, right, 0, 4);
      writeline(fcsv, l);

      report "gain=" & integer'image(gain) &
             "  g=" & real'image(g_real) &
             "  alpha=" & real'image(alpha_re) &
             "  SNR=" & real'image(snr_db) & " dB" &
             "  (ideal " & real'image(snr_ideal) & " dB)"
        severity note;

      gain := maximum(gain + GAIN_STEP, integer(round(real(gain) * step_mult)));
    end loop;

    file_close(fcsv);
    report "tb_gng_snr_cal: sweep complete, wrote " & OUT_FILE severity note;
    std.env.finish;
    wait;
  end process;


  -- ----------------------------------------
  -- DUT
  -- ----------------------------------------
  U_DUT : entity work.gng_top
    generic map (
      AXIL_ADDR_W   => AXIL_ADDR_W,
      AXIL_DATA_W   => AXIL_DATA_W,
      AXIL_STRB_W   => AXIL_STRB_W
    )
    port map (
      clk           => clk,
      rstn          => rstn,
      A_TDATA       => A_TDATA,
      A_TVALID      => A_TVALID,
      A_TLAST       => A_TLAST,
      A_TREADY      => A_TREADY,
      B_TDATA       => B_TDATA,
      B_TVALID      => B_TVALID,
      B_TLAST       => B_TLAST,
      B_TREADY      => B_TREADY,
      axil_awaddr   => axil_awaddr,
      axil_awprot   => axil_awprot,
      axil_awvalid  => axil_awvalid,
      axil_awready  => axil_awready,
      axil_wdata    => axil_wdata,
      axil_wstrb    => axil_wstrb,
      axil_wvalid   => axil_wvalid,
      axil_wready   => axil_wready,
      axil_bresp    => axil_bresp,
      axil_bvalid   => axil_bvalid,
      axil_bready   => axil_bready,
      axil_araddr   => axil_araddr,
      axil_arprot   => axil_arprot,
      axil_arvalid  => axil_arvalid,
      axil_arready  => axil_arready,
      axil_rdata    => axil_rdata,
      axil_rresp    => axil_rresp,
      axil_rvalid   => axil_rvalid,
      axil_rready   => axil_rready
    );

end Behavioral;
