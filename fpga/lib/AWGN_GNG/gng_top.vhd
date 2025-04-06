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
--#   Description : Xilinx Vitis HLS Fixed Gain Block for AXI Stream Interface
--#
--#   Version History:
--#   
--#       Date        Description
--#     -----------   -----------------------------------------------------------------------
--#      2024-02-04    Original Creation
--#
--###########################################################################################
--###########################################################################################


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.arith_pkg.all;


entity gng_top is
  generic (
    AXIL_ADDR_W   : integer := 8;
    AXIL_DATA_W   : integer := 32;
    AXIL_STRB_W   : integer := 4;
    I_INIT_Z1     : std_logic_vector(63 downto 0) :=  x"6094bc1bd3d8db9a";
    I_INIT_Z2     : std_logic_vector(63 downto 0) :=  x"d36035b0ca17e666";
    I_INIT_Z3     : std_logic_vector(63 downto 0) :=  x"e2d0b140ab8ac10b";
    Q_INIT_Z1     : std_logic_vector(63 downto 0) :=  x"bc6840786a43d19a";
    Q_INIT_Z2     : std_logic_vector(63 downto 0) :=  x"4756b3c2f33b8c9f";
    Q_INIT_Z3     : std_logic_vector(63 downto 0) :=  x"32b439953f41c5e7"
  );
  port (
    -- -----------------------------------------------------------------
    --    Clock and Reset
    -- -----------------------------------------------------------------
    clk           : in  std_logic;
    rstn          : in  std_logic;
    -- -----------------------------------------------------------------
    --    Data Path
    -- -----------------------------------------------------------------
    A_TDATA       : in  std_logic_vector(31 downto 0);
    A_TVALID      : in  std_logic;
    A_TLAST       : in  std_logic;
    A_TREADY      : out std_logic;
    --------------+-----------------------------------
    B_TDATA       : out std_logic_vector(31 downto 0);
    B_TVALID      : out std_logic;
    B_TLAST       : out std_logic;
    B_TREADY      : in  std_logic;
    -- -----------------------------------------------------------------
    --    AXI-Lite
    -- -----------------------------------------------------------------
    axil_awaddr   : in  std_logic_vector(AXIL_ADDR_W-1 downto 0);
    axil_awprot   : in  std_logic_vector(2 downto 0);
    axil_awvalid  : in  std_logic;
    axil_awready  : out std_logic;
    axil_wdata    : in  std_logic_vector(AXIL_DATA_W-1 downto 0);
    axil_wstrb    : in  std_logic_vector(AXIL_STRB_W-1 downto 0);
    axil_wvalid   : in  std_logic;
    axil_wready   : out std_logic;
    axil_bresp    : out std_logic_vector(1 downto 0);
    axil_bvalid   : out std_logic;
    axil_bready   : in  std_logic;
    axil_araddr   : in  std_logic_vector(AXIL_ADDR_W-1 downto 0);
    axil_arprot   : in  std_logic_vector(2 downto 0);
    axil_arvalid  : in  std_logic;
    axil_arready  : out std_logic;
    axil_rdata    : out std_logic_vector(AXIL_DATA_W-1 downto 0);
    axil_rresp    : out std_logic_vector(1 downto 0);
    axil_rvalid   : out std_logic;
    axil_rready   : in  std_logic
  );
end entity;


architecture rtl of gng_top is

  -- Constant and Top level signals
  constant F_AWGN         : format := (16,11);  -- AWGN is fixed format
  constant F_IN           : format := (16,14);
  constant F_OUT          : format := (16,14);
  constant DLY            : natural := 1; -- Pipeline delay
  signal rst              : std_logic := '1';

  -- Register Signals
  signal awgn_gain        : std_logic_vector(F_AWGN.tBits-1 downto 0);
  signal awgn_enable      : std_logic;

  --  Data Path Signals
  signal I_gng            : std_logic_vector(F_AWGN.tBits-1 downto 0);
  signal Q_gng            : std_logic_vector(F_AWGN.tBits-1 downto 0);
  signal I_gng_d          : std_logic_vector(F_AWGN.tBits-1 downto 0);
  signal Q_gng_d          : std_logic_vector(F_AWGN.tBits-1 downto 0);

  signal B_TVALID_int     : std_logic;
  signal B_TLAST_int      : std_logic;
  signal B_TDATA_int      : std_logic_vector(2*F_OUT.tBits-1 downto 0);

  signal tlast_pipe       : std_logic_vector(0 to DLY-1); -- Must be 1 or greater

  signal ch_I_sat         : std_logic;
  signal ch_Q_sat         : std_logic;
  signal ch_I             : std_logic_vector(F_OUT.tBits-1 downto 0);
  signal ch_Q             : std_logic_vector(F_OUT.tBits-1 downto 0);

  -- Debug counters
  signal cnt_tvalid               : std_logic_vector(31 downto 0);
  signal cnt_tvalid_cap           : std_logic_vector(31 downto 0);
  signal cnt_tlast                : std_logic_vector(31 downto 0);
  signal cnt_tlast_cap            : std_logic_vector(31 downto 0);
  signal clr_cnt                  : std_logic;
  signal cap_cnt                  : std_logic;

  -- ILA Signals
  attribute mark_debug : string;
  attribute mark_debug of cnt_tvalid    : signal is "true";
  attribute mark_debug of cnt_tlast     : signal is "true";
  attribute mark_debug of B_TVALID      : signal is "true";
  attribute mark_debug of B_TREADY      : signal is "true";
  attribute mark_debug of B_TLAST       : signal is "true";
  attribute mark_debug of A_TVALID      : signal is "true";
  --attribute mark_debug of A_TREADY      : signal is "true"; A_TREADY = B_TREADY;
  attribute mark_debug of A_TLAST       : signal is "true";

begin

  -- --------------------------------------------------------
  --  Mux and flow control signals
  -- --------------------------------------------------------

  -- drive control signals
  rst       <= NOT(rstn);
  A_TREADY  <= B_TREADY;
  B_TLAST   <= B_TLAST_int  when awgn_enable = '1' else A_TLAST;
  B_TVALID  <= B_TVALID_int when awgn_enable = '1' else A_TVALID;
  B_TDATA   <= B_TDATA_int  when awgn_enable = '1' else A_TDATA;

  -- Need to create std_logic_vector to pass to function of exact size 
  ch_I      <= re(B_TDATA_int);
  ch_Q      <= im(B_TDATA_int);
  ch_I_sat  <= is_sat(ch_I);
  ch_Q_sat  <= is_sat(ch_Q);


  -- --------------------------------------------------------
  --    TLAST delay by DLY cc
  -- --------------------------------------------------------
  process(clk,B_TREADY,rst)
  begin
    if(rst = '1') then
      tlast_pipe        <= (others => '0');
    elsif(rising_edge(clk) AND B_TREADY='1') then
      if(A_TVALID = '1') then
        tlast_pipe(0)   <= A_TLAST;
      end if;
      for  i in 1 to DLY-1 loop
        tlast_pipe(i)   <= tlast_pipe(i-1);
      end loop;
    end if;
  end process;
  B_TLAST_int <= tlast_pipe(DLY-1);


  -- --------------------------------------------------------
  --    Host Interface
  -- --------------------------------------------------------
  U_AWGN_REG : entity work.awgn_reg 
    generic map (
      ADDR_W        => AXIL_ADDR_W, 
      DATA_W        => AXIL_DATA_W,
      STRB_W        => AXIL_STRB_W 
    )
    port map (
      -- -------------------------------------+-------------------------------------------------
      --    Clock / Reset
      -- -------------------------------------+-------------------------------------------------
      clk           => clk,
      rst           => rst, 
      -- -------------------------------------+-------------------------------------------------
      --    Status Registers
      -- -------------------------------------+-------------------------------------------------
      csr_f_in_f_in_total_in                  => std_logic_vector(to_unsigned(F_IN.tBits,16)),
      csr_f_in_f_in_fractional_in             => std_logic_vector(to_unsigned(F_IN.fBits,16)),
      csr_f_out_f_out_total_in                => std_logic_vector(to_unsigned(F_OUT.tBits,16)),
      csr_f_out_f_out_fractional_in           => std_logic_vector(to_unsigned(F_OUT.fBits,16)),
      csr_f_awgn_f_awgn_total_in              => std_logic_vector(to_unsigned(F_AWGN.tBits,16)),
      csr_f_awgn_f_awgn_fractional_in         => std_logic_vector(to_unsigned(F_AWGN.fBits,16)),
      -- -------------------------------------+-------------------------------------------------
      --    Control Registers
      -- -------------------------------------+-------------------------------------------------
      csr_awgn_noise_gain_awgn_noise_gain_out => awgn_gain,
      csr_awgn_enable_awgn_enable_out         => awgn_enable,
      csr_awgn_enable_sat_i_ch_in             => '1', 
      csr_awgn_enable_sat_i_ch_en             => ch_I_sat,
      csr_awgn_enable_sat_q_ch_in             => '1', 
      csr_awgn_enable_sat_q_ch_en             => ch_Q_sat,
      -- -------------------------------------+-------------------------------------------------
      --    Debug Counters
      -- -------------------------------------+-------------------------------------------------
      csr_tvalid_cnt_tvalid_cnt_in            => cnt_tvalid_cap, 
      csr_tlast_cnt_tlast_cnt_in              => cnt_tlast_cap,
      csr_cnt_ctrl_clear_cnt_out              => clr_cnt, 
      csr_cnt_ctrl_capture_cnt_out            => cap_cnt, 
      -- -------------------------------------+-------------------------------------------------
      --    AXI-Lite
      -- -------------------------------------+-------------------------------------------------
      axil_awaddr       => axil_awaddr,   
      axil_awprot       => axil_awprot,   
      axil_awvalid      => axil_awvalid,  
      axil_awready      => axil_awready,  
      axil_wdata        => axil_wdata,    
      axil_wstrb        => axil_wstrb,    
      axil_wvalid       => axil_wvalid,   
      axil_wready       => axil_wready,   
      axil_bresp        => axil_bresp,    
      axil_bvalid       => axil_bvalid,   
      axil_bready       => axil_bready,   
      axil_araddr       => axil_araddr,   
      axil_arprot       => axil_arprot,   
      axil_arvalid      => axil_arvalid,  
      axil_arready      => axil_arready,  
      axil_rdata        => axil_rdata,    
      axil_rresp        => axil_rresp,    
      axil_rvalid       => axil_rvalid,   
      axil_rready       => axil_rready   
    );

  -- --------------------------------------------------------
  -- Stage 0: Instantiate U_gng_I/Q and add gain 
  -- --------------------------------------------------------
  u_gng_I : entity work.gng
    generic map (
      INIT_Z1     => I_INIT_Z1,
      INIT_Z2     => I_INIT_Z2,
      INIT_Z3     => I_INIT_Z3
    )
    port map (
      clk         => clk,
      rstn        => rstn,
      ce          => B_TREADY,
      valid_out   => open,
      data_out    => I_gng
    );
  
  u_gng_Q : entity work.gng
    generic map (
      INIT_Z1     => Q_INIT_Z1,
      INIT_Z2     => Q_INIT_Z2,
      INIT_Z3     => Q_INIT_Z3
    )
    port map (
      clk         => clk,
      rstn        => rstn,
      ce          => B_TREADY,
      valid_out   => open,
      data_out    => Q_gng
    );

  -- Gain Control
  U_GAIN_AWGN_I : entity work.Mult
    generic map (
      a_f         => F_AWGN,
      b_f         => F_AWGN,
      c_f         => F_AWGN,
      sign        => True,
      satr        => True,
      rnd         => True,
      arst        => True,
      dly         => 1
    )
    port map (
      ------------+-------------------------
      -- Clock and Reset
      ------------+-------------------------
      clk         => clk,
      ce          => B_TREADY,
      rst         => rst,
      ------------+-------------------------
      -- Input Signals
      ------------+-------------------------
      A           => awgn_gain,
      B           => I_gng,
      In_stb      => '1',
      ------------+-------------------------
      -- Output Signals
      ------------+-------------------------
      C           => I_gng_d,
      Out_stb     => open
    );

  U_GAIN_AWGN_Q : entity work.Mult
    generic map (
      a_f         => F_AWGN,
      b_f         => F_AWGN,
      c_f         => F_AWGN,
      sign        => True,
      satr        => True,
      rnd         => True,
      arst        => True,
      dly         => 1
    )
    port map (
      ------------+-------------------------
      -- Clock and Reset
      ------------+-------------------------
      clk         => clk,
      ce          => B_TREADY,
      rst         => rst,
      ------------+-------------------------
      -- Input Signals
      ------------+-------------------------
      A           => awgn_gain,
      B           => Q_gng,
      In_stb      => '1',
      ------------+-------------------------
      -- Output Signals
      ------------+-------------------------
      C           => Q_gng_d,
      Out_stb     => open
    );


  -- -------------------------------------------------
  --  Stage 1: Add Signals with AWGN Generator
  -- -------------------------------------------------
  U_ADD_AWGN_I : entity work.Add
    generic map (
      a_f         => F_IN,
      b_f         => F_AWGN,
      c_f         => F_OUT,
      sign        => True,
      satr        => True,
      rnd         => True,
      arst        => True,
      dly         => DLY 
    )
    port map (
      ------------+-------------------------
      -- Clock and Reset
      ------------+-------------------------
      clk         => clk,
      ce          => B_TREADY,
      rst         => rst,
      ------------+-------------------------
      -- Input Signals
      ------------+-------------------------
      A           => A_TDATA(2*F_IN.tBits-1 downto F_IN.tBits),
      B           => I_gng_d,
      In_stb      => A_TVALID,
      ------------+-------------------------
      -- Output Signals
      ------------+-------------------------
      C           => B_TDATA_int(2*F_OUT.tBits-1 downto F_OUT.tBits),
      Out_stb     => B_TVALID_int
    );

  U_ADD_AWGN_Q : entity work.Add
    generic map (
      a_f         => F_IN,
      b_f         => F_AWGN,
      c_f         => F_OUT,
      sign        => True,
      satr        => True,
      rnd         => True,
      arst        => True,
      dly         => DLY
    )
    port map (
      ------------+-------------------------
      -- Clock and Reset
      ------------+-------------------------
      clk         => clk,
      ce          => B_TREADY,
      rst         => rst,
      ------------+-------------------------
      -- Input Signals
      ------------+-------------------------
      A           => A_TDATA(F_IN.tBits-1 downto 0),
      B           => Q_gng_d,
      In_stb      => A_TVALID,
      ------------+-------------------------
      -- Output Signals
      ------------+-------------------------
      C           => B_TDATA_int(F_OUT.tBits-1 downto 0),
      Out_stb     => open
    );




  -- ----------------------------------------------------------------
  --    Debug Counters
  -- ----------------------------------------------------------------
  process(clk)
  begin
    if((rst = '1') OR (clr_cnt='1')) then
      cnt_tvalid              <= (others => '0'); 
      cnt_tvalid_cap          <= (others => '0'); 
      cnt_tlast               <= (others => '0'); 
      cnt_tlast_cap           <= (others => '0'); 
    elsif(rising_edge(clk) AND B_TREADY='1') then
      if(A_TVALID = '1') then
        cnt_tvalid  <= std_logic_vector(unsigned(cnt_tvalid)+1);
      end if;
      if(A_TLAST = '1') then
        cnt_tlast   <= std_logic_vector(unsigned(cnt_tlast)+1);
      end if;

      if(cap_cnt = '1') then
        cnt_tvalid_cap    <= cnt_tvalid;
        cnt_tlast_cap     <= cnt_tlast;
      end if;

    end if;
  end process;




end RTL;

