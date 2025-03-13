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
--#   Description : QPSK Demodulator
--#
--#   Version History:
--#   
--#       Date        Description
--#     -----------   -----------------------------------------------------------------------
--#      2025-02-22    Original Creation
--#
--###########################################################################################
--###########################################################################################



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.arith_pkg.all;


entity QPSK_Demod_Top is
  generic (
    ADDR_W          : INTEGER := 8;
    DATA_W          : INTEGER := 32;
    STRB_W          : INTEGER := 4
  );
  port (
    -- ------------------------------------------------------
    --    Clock & Reset Signals
    -- ------------------------------------------------------
    clk             : in  std_logic;
    rst             : in  std_logic;
    ce              : in  std_logic := '1';
    -- ------------------------------------------------------
    --    AXI Stream Input
    -- ------------------------------------------------------
    A_TDATA         : in  std_logic_vector(31 downto 0);
    A_TVALID        : in  std_logic;
    A_TREADY        : out std_logic;
    A_TKEEP         : in  std_logic_vector(3 downto 0);
    A_TSTRB         : in  std_logic_vector(3 downto 0);
    A_TLAST         : in  std_logic_vector(0 downto 0);
    -- ------------------------------------------------------
    --    AXI-Lite
    -- ------------------------------------------------------
    axil_awaddr     : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_awprot     : in  std_logic_vector(2 downto 0);
    axil_awvalid    : in  std_logic;
    axil_awready    : out std_logic;
    axil_wdata      : in  std_logic_vector(DATA_W-1 downto 0);
    axil_wstrb      : in  std_logic_vector(STRB_W-1 downto 0);
    axil_wvalid     : in  std_logic;
    axil_wready     : out std_logic;
    axil_bresp      : out std_logic_vector(1 downto 0);
    axil_bvalid     : out std_logic;
    axil_bready     : in  std_logic;
    axil_araddr     : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_arprot     : in  std_logic_vector(2 downto 0);
    axil_arvalid    : in  std_logic;
    axil_arready    : out std_logic;
    axil_rdata      : out std_logic_vector(DATA_W-1 downto 0);
    axil_rresp      : out std_logic_vector(1 downto 0);
    axil_rvalid     : out std_logic;
    axil_rready     : in  std_logic
  );
end entity;

architecture RTL of QPSK_Demod_Top is

  -- Constant and Top level signals
  constant F_IN             : format := (16,12);
  constant F_OUT            : format := (16,12);

  -- Control Signals
  signal ap_start           : std_logic;
  signal ap_done            : std_logic;
  signal ap_idle            : std_logic;

  signal demod_bits_stb     : std_logic;
  signal demod_bits         : std_logic_vector( 1 downto 0);
  signal demod_bits_stb_q   : std_logic;
  signal demod_bits_q       : std_logic_vector( 1 downto 0);

  signal BRAM_wr_addr       : std_logic_vector(15 downto 0);
  signal BRAM_wr_addr_clr   : std_logic;

  signal BRAM_rd_addr       : std_logic_vector(15 downto 0);
  signal BRAM_rd_data       : std_logic_vector(31 downto 0);

  signal shift_reg          : std_logic_vector(31 downto 0);
  signal sync_word          : std_logic_vector(31 downto 0);
  signal sync_lock          : std_logic := '0';
  signal sync_clr           : std_logic;


  COMPONENT QPSK_Demod_Out_BRAM
    PORT (
      clka : IN STD_LOGIC;
      ena : IN STD_LOGIC;
      wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      dina : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      douta : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      clkb : IN STD_LOGIC;
      enb : IN STD_LOGIC;
      web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
    );
  END COMPONENT;

  component QPSK_Demodulator
  port (
      ap_clk : IN STD_LOGIC;
      ap_rst : IN STD_LOGIC;
      ap_start : IN STD_LOGIC;
      ap_done : OUT STD_LOGIC;
      ap_idle : OUT STD_LOGIC;
      ap_ready : OUT STD_LOGIC;
      I_in : IN STD_LOGIC_VECTOR (15 downto 0);
      I_in_ap_vld : IN STD_LOGIC;
      Q_in : IN STD_LOGIC_VECTOR (15 downto 0);
      Q_in_ap_vld : IN STD_LOGIC;
      I_out : OUT STD_LOGIC_VECTOR (15 downto 0);
      I_out_ap_vld : OUT STD_LOGIC;
      Q_out : OUT STD_LOGIC_VECTOR (15 downto 0);
      Q_out_ap_vld : OUT STD_LOGIC;
      demod_bits : OUT STD_LOGIC_VECTOR (1 downto 0);
      demod_bits_ap_vld : OUT STD_LOGIC;
      ap_return : OUT STD_LOGIC_VECTOR (0 downto 0) );
  end component;

  attribute mark_debug : string;
  attribute mark_debug of demod_bits_stb    : signal is "true";
  attribute mark_debug of demod_bits_stb_q  : signal is "true";
  attribute mark_debug of demod_bits        : signal is "true";
  attribute mark_debug of demod_bits_q      : signal is "true";

  attribute mark_debug of BRAM_wr_addr      : signal is "true"; 
  attribute mark_debug of BRAM_wr_addr_clr  : signal is "true"; 
  attribute mark_debug of BRAM_rd_addr      : signal is "true"; 
  attribute mark_debug of BRAM_rd_data      : signal is "true"; 

  attribute mark_debug of shift_reg         : signal is "true";
  attribute mark_debug of sync_word         : signal is "true"; 
  attribute mark_debug of sync_lock         : signal is "true"; 
  attribute mark_debug of sync_clr          : signal is "true";  


begin



  -- -------------------------------------------------------------------
  --    QPSK Register Interface
  -- -------------------------------------------------------------------
  U_QPSK_REG : entity work.qpsk_reg 
    generic map (
      ADDR_W            =>  ADDR_W,
      DATA_W            =>  DATA_W,
      STRB_W            =>  STRB_W 
    )
    port map (
      -- ---------------------------------------------------
      --    Clock & Reset
      -- ---------------------------------------------------
      clk               => clk,
      rst               => rst,
      -- ---------------------------------------------------
      --    Control/Status Register Ports
      -- ---------------------------------------------------
      csr_f_in_f_in_total_in          => std_logic_vector(to_unsigned(F_IN.tBits,16)),
      csr_f_in_f_in_fractional_in     => std_logic_vector(to_unsigned(F_IN.fBits,16)), 
      csr_f_out_f_out_total_in        => std_logic_vector(to_unsigned(F_OUT.tBits,16)),
      csr_f_out_f_out_fractional_in   => std_logic_vector(to_unsigned(F_OUT.fBits,16)),
      ---------------------------------+-----------------------------------------------
      csr_ap_control_ap_start_out     => ap_start,
      csr_ap_control_ap_done_in       => ap_done,
      csr_ap_control_ap_idle_in       => ap_idle,
      ---------------------------------+-----------------------------------------------
      csr_wr_ram_addr_in              => BRAM_wr_addr,
      csr_wr_ram_addr_ctrl_clr_out    => BRAM_wr_addr_clr,
      ---------------------------------+-----------------------------------------------
      csr_rd_ram_addr_value_out       => BRAM_rd_addr,
      csr_rd_ram_data_value_in        => BRAM_rd_data,
      ---------------------------------+-----------------------------------------------
      csr_sync_word_sync_word_out     => sync_word, 
      csr_sync_lock_sync_lock_in      => sync_lock,
      csr_sync_reset_sync_clr_out     => sync_clr,
      -- ---------------------------------------------------
      --    AXI-Lite Bus
      -- ---------------------------------------------------
      axil_awaddr       =>  axil_awaddr,
      axil_awprot       =>  axil_awprot,     
      axil_awvalid      =>  axil_awvalid,     
      axil_awready      =>  axil_awready,    
      axil_wdata        =>  axil_wdata,       
      axil_wstrb        =>  axil_wstrb,       
      axil_wvalid       =>  axil_wvalid,      
      axil_wready       =>  axil_wready,      
      axil_bresp        =>  axil_bresp,       
      axil_bvalid       =>  axil_bvalid,       
      axil_bready       =>  axil_bready,      
      axil_araddr       =>  axil_araddr,      
      axil_arprot       =>  axil_arprot,      
      axil_arvalid      =>  axil_arvalid,     
      axil_arready      =>  axil_arready,     
      axil_rdata        =>  axil_rdata,       
      axil_rresp        =>  axil_rresp,       
      axil_rvalid       =>  axil_rvalid,      
      axil_rready       =>  axil_rready      
    );




  -- -------------------------------------------------------------------
  --    HLS QPSK Demodulator
  -- -------------------------------------------------------------------
  U_QPSK_DEMOD : QPSK_Demodulator
    port map (
      -- ---------------------------------------------------
      --    Clock & Reset
      -- ---------------------------------------------------
      ap_clk            =>  clk,
      ap_rst            =>  rst, 
      -- ---------------------------------------------------
      --    Control Signals
      -- ---------------------------------------------------
      ap_start          => ap_start,
      ap_done           => ap_done,
      ap_idle           => ap_idle,
      ap_ready          => A_TREADY, 
      ap_return         => open,
      -- ---------------------------------------------------
      --    QPSK Data Path Signals
      -- ---------------------------------------------------
      I_in              => A_TDATA(31 downto 16),
      I_in_ap_vld       => A_TVALID,
      Q_in              => A_TDATA(15 downto 0),
      Q_in_ap_vld       => A_TVALID,
      I_out             => open,
      I_out_ap_vld      => open,
      Q_out             => open,
      Q_out_ap_vld      => open,
      demod_bits        => demod_bits,
      demod_bits_ap_vld => demod_bits_stb
    );


  -- -------------------------------------------------------------------
  --    Register the Demodulator Bits
  -- -------------------------------------------------------------------
  process(clk)
  begin
    if(rising_edge(clk)) then
      demod_bits_stb_q    <= demod_bits_stb;
      if(demod_bits_stb = '1') then
        demod_bits_q      <= demod_bits;
      end if;
    end if;
  end process;



  -- -------------------------------------------------------------------
  --    HLS QPSK Demodulator
  -- -------------------------------------------------------------------
  U_QPSK_DEMOD_OUT_BRAM : QPSK_Demod_Out_BRAM
    PORT MAP (
      -- Write Port, Connected to QPSK Demod
      clka    => clk,
      ena     => sync_lock,
      wea(0)  => demod_bits_stb_q,
      addra   => BRAM_wr_addr,
      dina    => demod_bits_q,
      douta   => open,
      -- Read Port, Connected to Host IF
      clkb    => clk,
      enb     => '1',
      web     => (others => '0'),
      addrb   => BRAM_rd_addr(11 downto 0),
      dinb    => (others => '0'),
      doutb   => BRAM_rd_data
    );



  -- -----------------------------------------------------
  --    Write BRAM Address Logic
  -- -----------------------------------------------------
  process(clk,rst,BRAM_wr_addr_clr)
  begin
    if(rst='1' OR BRAM_wr_addr_clr='1') then
      BRAM_wr_addr   <= (others => '0');
    elsif(rising_edge(clk)) then
      if((demod_bits_stb_q = '1') AND (BRAM_wr_addr /= x"ffff") AND (sync_lock='1')) then
        BRAM_wr_addr  <= std_logic_vector(unsigned(BRAM_wr_addr) + 1);
      end if;
    end if;
  end process;



  -- -----------------------------------------------------
  --    Packet Sync - Search for Sync Word
  -- -----------------------------------------------------
  process(clk,rst,sync_clr)
  begin
    if(rst='1' OR sync_clr='1') then
      shift_reg     <= (others => '0');
      sync_lock     <= '0';
    elsif(rising_edge(clk)) then
      if(demod_bits_stb_q = '1') then
        shift_reg(31 downto 30) <= demod_bits_q;
        shift_reg(29 downto  0) <= shift_reg(31 downto 2);
      end if;

      if(shift_reg = sync_word) then
        sync_lock   <= '1';
      end if;
    end if;
  end process;


end architecture;
