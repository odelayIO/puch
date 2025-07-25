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
--#      2023-05-08    Original Creation
--#
--###########################################################################################
--###########################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.Timestamp_Pkg.all;

entity Timestamp is
  generic(
    ADDR_W : integer := 8;
    DATA_W : integer := 32;
    STRB_W : integer := 4
  );
  port(
    clk    : in std_logic;
    rst    : in std_logic;
  
    -- AXI-Lite
    axil_awaddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_awprot   : in  std_logic_vector(2 downto 0);
    axil_awvalid  : in  std_logic;
    axil_awready  : out std_logic;
    axil_wdata    : in  std_logic_vector(DATA_W-1 downto 0);
    axil_wstrb    : in  std_logic_vector(STRB_W-1 downto 0);
    axil_wvalid   : in  std_logic;
    axil_wready   : out std_logic;
    axil_bresp    : out std_logic_vector(1 downto 0);
    axil_bvalid   : out std_logic;
    axil_bready   : in  std_logic;
    axil_araddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_arprot   : in  std_logic_vector(2 downto 0);
    axil_arvalid  : in  std_logic;
    axil_arready  : out std_logic;
    axil_rdata    : out std_logic_vector(DATA_W-1 downto 0);
    axil_rresp    : out std_logic_vector(1 downto 0);
    axil_rvalid   : out std_logic;
    axil_rready   : in  std_logic
  );
end entity;


architecture RTL of Timestamp is
  

begin

  U_TIMESTAMP_REG : entity work.timestamp_reg 
    generic map(
      ADDR_W          => ADDR_W, 
      DATA_W          => DATA_W,
      STRB_W          => STRB_W 
    )
    port map(
      clk             => clk, 
      rst             => rst, 

      -- Time_Stamp_Year.ts_year
      csr_time_stamp_year_ts_year_in => TS_YEAR_1 & TS_YEAR_0,
  
      -- Time_Stamp_Month.ts_month
      csr_time_stamp_month_ts_month_in => TS_MONTH,
  
      -- Time_Stamp_Day.ts_day
      csr_time_stamp_day_ts_day_in => TS_DAY,
  
      -- Time_Stamp_Hour.ts_hour
      csr_time_stamp_hour_ts_hour_in => TS_HOUR,
  
      -- Time_Stamp_Minute.ts_min
      csr_time_stamp_minute_ts_min_in => TS_MIN,
  
      -- Time_Stamp_Seconds.ts_sec
      csr_time_stamp_seconds_ts_sec_in => TS_SEC,
  
      -- AXI-Lite
      axil_awaddr     =>  axil_awaddr,
      axil_awprot     =>  axil_awprot,   
      axil_awvalid    =>  axil_awvalid,  
      axil_awready    =>  axil_awready,  
      axil_wdata      =>  axil_wdata,    
      axil_wstrb      =>  axil_wstrb,    
      axil_wvalid     =>  axil_wvalid,   
      axil_wready     =>  axil_wready,   
      axil_bresp      =>  axil_bresp,    
      axil_bvalid     =>  axil_bvalid,   
      axil_bready     =>  axil_bready,   
      axil_araddr     =>  axil_araddr,   
      axil_arprot     =>  axil_arprot,   
      axil_arvalid    =>  axil_arvalid,  
      axil_arready    =>  axil_arready,  
      axil_rdata      =>  axil_rdata,    
      axil_rresp      =>  axil_rresp,    
      axil_rvalid     =>  axil_rvalid,   
      axil_rready     =>  axil_rready   
  );

  

end architecture;
