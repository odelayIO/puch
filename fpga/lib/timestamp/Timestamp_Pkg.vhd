--***********************************************************************************************************
--***********************************************************************************************************
--****
--****
--****                                    Time Stamp Package
--****
--****
--****
--****    Auto Generated on Apr. 10, 2025 12:17:26 PM
--****
--***********************************************************************************************************
--***********************************************************************************************************
 
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
 
package Timestamp_Pkg is
 
 
 
 
  -- -------------------------------------------------------------------------------------------
  --  Time Stamp Constants
  -- -------------------------------------------------------------------------------------------
  constant TS_YEAR_1    : std_logic_vector(7 downto 0) := x"20";
  constant TS_YEAR_0    : std_logic_vector(7 downto 0) := x"25";
  constant TS_MONTH     : std_logic_vector(7 downto 0) := x"04";
  constant TS_DAY       : std_logic_vector(7 downto 0) := x"10";
  constant TS_HOUR      : std_logic_vector(7 downto 0) := x"12";
  constant TS_MIN       : std_logic_vector(7 downto 0) := x"17";
  constant TS_SEC       : std_logic_vector(7 downto 0) := x"26";
 
 
 
 
 
end;
