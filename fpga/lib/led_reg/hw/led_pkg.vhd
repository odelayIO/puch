-- Created with Corsair vgit-latest

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package led_pkg is



  constant CSR_BASE_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);

  -- User_LEDs - User Leds on KR260 (user_leds[1:0])
  constant CSR_USER_LEDS_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(16, 8);
  constant CSR_USER_LEDS_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);



end package led_pkg;


package body led_pkg is

end package body;
