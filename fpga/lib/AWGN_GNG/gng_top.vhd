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
    -- Clock and Reset
    clk           : in  std_logic;
    rstn          : in  std_logic;
    -- Data Path
    A_TDATA       : in  std_logic_vector(31 downto 0);
    A_TVALID      : in  std_logic;
    A_TLAST       : in  std_logic;
    A_TREADY      : out std_logic;
    B_TDATA       : out std_logic_vector(31 downto 0);
    B_TVALID      : out std_logic;
    B_TLAST       : out std_logic;
    B_TREADY      : in  std_logic;

    -- AXI-Lite
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
  signal rst              : std_logic := '1';

  -- Register Signals
  signal awgn_gain        : std_logic_vector(F_AWGN.tBits-1 downto 0);
  signal awgn_enable      : std_logic;

  --  Data Path Signals
  signal I_gng            : std_logic_vector(F_AWGN.tBits-1 downto 0);
  signal Q_gng            : std_logic_vector(F_AWGN.tBits-1 downto 0);

  signal B_TVALID_int     : std_logic;
  signal B_TLAST_int      : std_logic;
  signal B_TDATA_int      : std_logic_vector(2*F_OUT.tBits-1 downto 0);

begin

  -- drive control signals
  rst       <= NOT(rstn);
  A_TREADY  <= B_TREADY;
  B_TLAST   <= B_TLAST_int  when awgn_enable = '1' else A_TLAST;
  B_TVALID  <= B_TVALID_int when awgn_enable = '1' else A_TVALID;
  B_TDATA   <= B_TDATA_int  when awgn_enable = '1' else A_TDATA;


  -- --------------------------------------------------------
  --  Host Interface
  -- --------------------------------------------------------
  U_AWGN_REG : entity work.awgn_reg 
    generic map (
      ADDR_W        => AXIL_ADDR_W, 
      DATA_W        => AXIL_DATA_W,
      STRB_W        => AXIL_STRB_W 
    )
    port map (
      clk           => clk,
      rst           => rst, 

      csr_f_in_f_in_total_in                  => std_logic_vector(to_unsigned(F_IN.tBits,16)),
      csr_f_in_f_in_fractional_in             => std_logic_vector(to_unsigned(F_IN.fBits,16)),
      csr_f_out_f_out_total_in                => std_logic_vector(to_unsigned(F_OUT.tBits,16)),
      csr_f_out_f_out_fractional_in           => std_logic_vector(to_unsigned(F_OUT.fBits,16)),
      csr_f_awgn_f_awgn_total_in              => std_logic_vector(to_unsigned(F_AWGN.tBits,16)),
      csr_f_awgn_f_awgn_fractional_in         => std_logic_vector(to_unsigned(F_AWGN.fBits,16)),
      csr_awgn_noise_gain_awgn_noise_gain_out => awgn_gain,
      csr_awgn_enable_awgn_enable_out         => awgn_enable,

      -- AXI-Lite
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
  -- Instantiate U_gng_I/Q (example values for INIT_Z)
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

  -- -------------------------------------------------
  --  Add Signals with AWGN Generator
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
      dly         => 1 
    )
    port map (
      ------------+-------------------------
      -- Clock and Reset
      clk         => clk,
      ce          => B_TREADY,
      rst         => rst,
      ------------+-------------------------
      -- Input Signals
      A           => A_TDATA(2*F_IN.tBits-1 downto F_IN.tBits),
      B           => I_gng,
      In_stb      => A_TVALID,
      ------------+-------------------------
      -- Output Signals
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
      dly         => 1 
    )
    port map (
      ------------+-------------------------
      -- Clock and Reset
      clk         => clk,
      ce          => B_TREADY,
      rst         => rst,
      ------------+-------------------------
      -- Input Signals
      A           => A_TDATA(F_IN.tBits-1 downto 0),
      B           => Q_gng,
      In_stb      => A_TVALID,
      ------------+-------------------------
      -- Output Signals
      C           => B_TDATA_int(F_OUT.tBits-1 downto 0),
      Out_stb     => open
    );

  -- Account for Add pipeline delay
  process(clk)
  begin
    if(rising_edge(clk)) then
      B_TLAST_int  <= A_TLAST;
    end if;
  end process;


end RTL;

