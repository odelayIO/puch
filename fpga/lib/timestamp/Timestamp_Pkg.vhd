--***********************************************************************************************************
--***********************************************************************************************************
--****
--****
--****                                    Time Stamp Package
--****
--****
--****
--****    Auto Generated on Feb. 11, 2025 12:59:18 AM
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
  constant TS_MONTH     : std_logic_vector(7 downto 0) := x"02";
  constant TS_DAY       : std_logic_vector(7 downto 0) := x"11";
  constant TS_HOUR      : std_logic_vector(7 downto 0) := x"00";
  constant TS_MIN       : std_logic_vector(7 downto 0) := x"59";
  constant TS_SEC       : std_logic_vector(7 downto 0) := x"18";
 
 
 
 
 
end;
