--***********************************************************************************************************
--***********************************************************************************************************
--****
--****
--****                                    Time Stamp Package
--****
--****
--****
--****    Auto Generated on Dec. 21, 2024 06:58:24 PM
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
  constant TS_YEAR_0    : std_logic_vector(7 downto 0) := x"24";
  constant TS_MONTH     : std_logic_vector(7 downto 0) := x"12";
  constant TS_DAY       : std_logic_vector(7 downto 0) := x"21";
  constant TS_HOUR      : std_logic_vector(7 downto 0) := x"18";
  constant TS_MIN       : std_logic_vector(7 downto 0) := x"58";
  constant TS_SEC       : std_logic_vector(7 downto 0) := x"24";
 
 
 
 
 
end;
