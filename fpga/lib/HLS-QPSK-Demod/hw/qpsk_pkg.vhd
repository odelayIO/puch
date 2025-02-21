-- Created with Corsair vgit-latest

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package qpsk_pkg is



  constant CSR_BASE_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);

  -- F_in - Input data stream format
  constant CSR_F_IN_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);
  constant CSR_F_IN_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- F_out - Output data stream format
  constant CSR_F_OUT_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(4, 8);
  constant CSR_F_OUT_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- AP_Control - HLS block level control protocol signals
  constant CSR_AP_CONTROL_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(8, 8);
  constant CSR_AP_CONTROL_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);



end package qpsk_pkg;


package body qpsk_pkg is

end package body;
