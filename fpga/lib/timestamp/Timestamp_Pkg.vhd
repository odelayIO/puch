--***********************************************************************************************************
--***********************************************************************************************************
--****
--****
--****                                    Time Stamp Package
--****
--****
--****
--****    Auto Generated on Mar. 05, 2025 05:18:45 AM
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
  constant TS_MONTH     : std_logic_vector(7 downto 0) := x"03";
  constant TS_DAY       : std_logic_vector(7 downto 0) := x"05";
  constant TS_HOUR      : std_logic_vector(7 downto 0) := x"05";
  constant TS_MIN       : std_logic_vector(7 downto 0) := x"18";
  constant TS_SEC       : std_logic_vector(7 downto 0) := x"45";
 
 
 
 
 
end;
