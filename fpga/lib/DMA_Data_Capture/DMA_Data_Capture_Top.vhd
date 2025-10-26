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
--#      2025-07-22    Original Creation
--#
--###########################################################################################
--###########################################################################################


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.arith_pkg.all;


entity DMA_Data_Capture_Top is
  generic (
    AXIL_ADDR_W   : integer := 8;
    AXIL_DATA_W   : integer := 32;
    AXIL_STRB_W   : integer := 4
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
    A_TDATA       : in  std_logic_vector(31 downto 0) := (others => '0');
    A_TVALID      : in  std_logic := '1';
    A_TREADY      : out std_logic;
    --------------+-----------------------------------
    B_TDATA       : out std_logic_vector(31 downto 0);
    B_TVALID      : out std_logic;
    B_TLAST       : out std_logic;
    B_TREADY      : in  std_logic;
    B_TKEEP       : out std_logic_vector(3 downto 0); -- Needed for PYNQ DMA
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


architecture rtl of DMA_Data_Capture_Top is


  -- State Machine Signals
  type state_type is (IDLE, CAPTURE, TLAST);
  signal state : state_type;

  signal fifo_tdata         : std_logic_vector(31 downto 0);
  signal fifo_tvalid        : std_logic;
  signal fifo_tlast         : std_logic;
  signal fifo_trdy          : std_logic;
  signal fifo_cnt           : unsigned(31 downto 0);

  -- Register IF Signals
  signal cap_depth          : std_logic_vector(31 downto 0);
  signal cap_trig           : std_logic;
  signal fifo_flush         : std_logic;
  signal fifo_flush_n       : std_logic;
  signal debug_cnt_en       : std_logic;

  -- Internal Signals
  signal fifo_wr_ptr        : std_logic_vector(15 downto 0);
  signal fifo_rd_ptr        : std_logic_vector(15 downto 0);
  signal fifo_wr_ptr32      : std_logic_vector(31 downto 0);
  signal fifo_rd_ptr32      : std_logic_vector(31 downto 0);
  signal rst                : std_logic;

  attribute mark_debug : string;
  attribute mark_debug of fifo_tdata    : signal is "true";
  attribute mark_debug of fifo_tvalid   : signal is "true";
  attribute mark_debug of fifo_tlast    : signal is "true";
  attribute mark_debug of fifo_trdy     : signal is "true";
  attribute mark_debug of fifo_cnt      : signal is "true";

  attribute mark_debug of cap_trig      : signal is "true";
  attribute mark_debug of fifo_flush    : signal is "true";
  attribute mark_debug of debug_cnt_en  : signal is "true";

  attribute mark_debug of state         : signal is "true";
  attribute mark_debug of fifo_wr_ptr   : signal is "true";
  attribute mark_debug of fifo_rd_ptr   : signal is "true";

  --attribute mark_debug of B_TDATA       : signal is "true";
  --attribute mark_debug of B_TVALID      : signal is "true";
  --attribute mark_debug of B_TLAST       : signal is "true";
  --attribute mark_debug of B_TREADY      : signal is "true";
  --attribute mark_debug of B_TKEEP       : signal is "true";


  -- ----------------------------------------
  --  Components
  -- ----------------------------------------
  COMPONENT DMA_32b_Capture_FIFO
    PORT (
      s_axis_aresetn : IN STD_LOGIC;
      s_axis_aclk : IN STD_LOGIC;
      s_axis_tvalid : IN STD_LOGIC;
      s_axis_tready : OUT STD_LOGIC;
      s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axis_tlast : IN STD_LOGIC;
      m_axis_tvalid : OUT STD_LOGIC;
      m_axis_tready : IN STD_LOGIC;
      m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axis_tlast : OUT STD_LOGIC;
      axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
    );
  END COMPONENT;

begin

  B_TKEEP       <= (others => '1'); -- Needed for PYNQ DMA
  A_TREADY      <= fifo_trdy;
  fifo_flush_n  <= NOT(fifo_flush);
  rst           <= NOT(rstn);


  -- ------------------------------------------------------------------------------------------
  --    Host Interface
  -- ------------------------------------------------------------------------------------------
  U_DMA_DATA_CAPTURE_REG : entity work.dma_data_capture_reg
    generic map (
      ADDR_W        => AXIL_ADDR_W, 
      DATA_W        => AXIL_DATA_W,
      STRB_W        => AXIL_STRB_W 
    )
    port map (
      -- -------------------------------------+-------------------------------------------------
      --    Clock / Reset
      -- -------------------------------------+-------------------------------------------------
      clk                                     => clk,
      rst                                     => rst, 
      -- -------------------------------------+-------------------------------------------------
      --    Status Registers
      -- -------------------------------------+-------------------------------------------------
      csr_max_depth_len_in                    => std_logic_vector(to_unsigned(32768,32)),
      csr_fifo_wr_ptr_wr_ptr_in               => x"0000" & fifo_wr_ptr,
      csr_fifo_rd_ptr_rd_ptr_in               => x"0000" & fifo_rd_ptr, 
      -- -------------------------------------+-------------------------------------------------
      --    Control Registers
      -- -------------------------------------+-------------------------------------------------
      csr_capture_length_len_out              => cap_depth,
      csr_capture_stb_cap_stb_out             => cap_trig,
      csr_fifo_flush_flush_out                => fifo_flush,
      csr_enable_debug_cnt_en_debug_cnt_out   => debug_cnt_en,
      -- -------------------------------------+-------------------------------------------------
      --    AXI-Lite
      -- -------------------------------------+-------------------------------------------------
      axil_awaddr                             => axil_awaddr,   
      axil_awprot                             => axil_awprot,   
      axil_awvalid                            => axil_awvalid,  
      axil_awready                            => axil_awready,  
      axil_wdata                              => axil_wdata,    
      axil_wstrb                              => axil_wstrb,    
      axil_wvalid                             => axil_wvalid,   
      axil_wready                             => axil_wready,   
      axil_bresp                              => axil_bresp,    
      axil_bvalid                             => axil_bvalid,   
      axil_bready                             => axil_bready,   
      axil_araddr                             => axil_araddr,   
      axil_arprot                             => axil_arprot,   
      axil_arvalid                            => axil_arvalid,  
      axil_arready                            => axil_arready,  
      axil_rdata                              => axil_rdata,    
      axil_rresp                              => axil_rresp,    
      axil_rvalid                             => axil_rvalid,   
      axil_rready                             => axil_rready   
    );


  -- --------------------------------------------------------
  --    FIFO Write State Machine
  -- --------------------------------------------------------
  process (clk,rstn,fifo_flush) 
  begin
    if((rstn='0') OR (fifo_flush='1')) then
      fifo_tdata        <= (others => '0');
      fifo_tvalid       <= '0';
      fifo_tlast        <= '0';
      fifo_cnt          <= (others => '0');
      state             <= IDLE;
    else
      if(rising_edge(clk)) then
        case state is
          -- Idle
          when IDLE =>
            fifo_tdata        <= (others => '0');
            fifo_tvalid       <= '0';
            fifo_tlast        <= '0';
            fifo_cnt          <= unsigned(cap_depth);
            if(cap_trig='1') then
              state           <= CAPTURE;
            else
              state           <= IDLE;
            end if;

          -- Capture state: Write data input FIFO
          when CAPTURE =>
            fifo_tvalid       <= '0';
            fifo_tlast        <= '0';
            if(A_TVALID='1' AND (fifo_trdy='1')) then
              fifo_tvalid     <= '1';
              -- Debug Counter
              if(debug_cnt_en = '1') then
                fifo_tdata    <= std_logic_vector(fifo_cnt);
              else
                fifo_tdata    <= A_TDATA;
              end if;
              if(fifo_cnt-1 = 0) then
                state         <= TLAST;
                fifo_tlast    <= '1';
              else
                state         <= CAPTURE;
                fifo_cnt      <= fifo_cnt - 1;
              end if;
            end if;

          -- Clear TLAST signal in the FIFO
          -- Writing additional word to clear tlast
          when TLAST =>
              fifo_tvalid     <= '1';
              fifo_tdata      <= x"DEADBEEF";
              fifo_tlast      <= '0';
              state           <= IDLE;

          -- Others
          when others =>
            fifo_tdata        <= (others => '0');
            fifo_tvalid       <= '0';
            fifo_tlast        <= '0';
            fifo_cnt          <= unsigned(cap_depth);
            state             <= IDLE;
        end case;
      end if;
    end if;
  end process;


  -- --------------------------------------------------------
  --  FIFO Capture Buffer
  -- --------------------------------------------------------
  U_DMA_32B_CAPTURE_FIFO : DMA_32b_Capture_FIFO
    PORT MAP (
      s_axis_aresetn      => fifo_flush_n,
      s_axis_aclk         => clk,
      --------------------+-------------------------------
      s_axis_tdata        => fifo_tdata,
      s_axis_tvalid       => fifo_tvalid,
      s_axis_tready       => fifo_trdy,
      s_axis_tlast        => fifo_tlast,
      --------------------+-------------------------------
      m_axis_tdata        => B_TDATA,
      m_axis_tvalid       => B_TVALID, 
      m_axis_tready       => B_TREADY, 
      m_axis_tlast        => B_TLAST,
      --------------------+-------------------------------
      axis_wr_data_count  => fifo_wr_ptr32, 
      axis_rd_data_count  => fifo_rd_ptr32 
    );

  fifo_wr_ptr <= fifo_wr_ptr32(15 downto 0);
  fifo_rd_ptr <= fifo_rd_ptr32(15 downto 0);

end RTL;

