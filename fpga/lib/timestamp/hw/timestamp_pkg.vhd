-- Created with Corsair vgit-latest

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package timestamp_pkg is



  constant CSR_BASE_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);

  -- Time_Stamp_Year - Time Stamp Year (Hex Value)
  constant CSR_TIME_STAMP_YEAR_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(16, 8);
  constant CSR_TIME_STAMP_YEAR_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- Time_Stamp_Month - Time Stamp Month (Hex Value)
  constant CSR_TIME_STAMP_MONTH_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(20, 8);
  constant CSR_TIME_STAMP_MONTH_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- Time_Stamp_Day - Time Stamp Day (Hex Value)
  constant CSR_TIME_STAMP_DAY_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(24, 8);
  constant CSR_TIME_STAMP_DAY_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- Time_Stamp_Hour - Time Stamp Hour (Hex Value)
  constant CSR_TIME_STAMP_HOUR_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(28, 8);
  constant CSR_TIME_STAMP_HOUR_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- Time_Stamp_Minute - Time Stamp Minute (Hex Value)
  constant CSR_TIME_STAMP_MINUTE_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(32, 8);
  constant CSR_TIME_STAMP_MINUTE_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- Time_Stamp_Seconds - Time Stamp Seconds (Hex Value)
  constant CSR_TIME_STAMP_SECONDS_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(36, 8);
  constant CSR_TIME_STAMP_SECONDS_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);



end package timestamp_pkg;


package body timestamp_pkg is

end package body;
