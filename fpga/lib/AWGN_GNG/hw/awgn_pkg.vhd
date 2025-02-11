-- Created with Corsair vgit-latest

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package awgn_pkg is



  constant CSR_BASE_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);

  -- F_in - Input data stream format
  constant CSR_F_IN_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);
  constant CSR_F_IN_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- F_out - Output data stream format
  constant CSR_F_OUT_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(4, 8);
  constant CSR_F_OUT_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- F_awgn - Output AWGN data stream format
  constant CSR_F_AWGN_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(8, 8);
  constant CSR_F_AWGN_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- awgn_noise_gain - AWGN Noise Gain
  constant CSR_AWGN_NOISE_GAIN_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(12, 8);
  constant CSR_AWGN_NOISE_GAIN_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- awgn_enable - AWGN Noise Enable
  constant CSR_AWGN_ENABLE_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(16, 8);
  constant CSR_AWGN_ENABLE_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);



end package awgn_pkg;


package body awgn_pkg is

end package body;
