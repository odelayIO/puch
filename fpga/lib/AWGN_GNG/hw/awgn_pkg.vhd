-- Created with Corsair vgit-latest

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package awgn_pkg is



  constant CSR_BASE_ADDR : std_logic_vector(8-1 downto 0) := "00000000"; -- 0x0

  -- F_in - Input data stream format
  constant CSR_F_IN_ADDR : std_logic_vector(8-1 downto 0) := "00000000"; -- 0x0
  constant CSR_F_IN_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0

  -- F_out - Output data stream format
  constant CSR_F_OUT_ADDR : std_logic_vector(8-1 downto 0) := "00000100"; -- 0x4
  constant CSR_F_OUT_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0

  -- F_awgn - Output AWGN data stream format
  constant CSR_F_AWGN_ADDR : std_logic_vector(8-1 downto 0) := "00001000"; -- 0x8
  constant CSR_F_AWGN_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0

  -- awgn_noise_gain - AWGN Noise Gain
  constant CSR_AWGN_NOISE_GAIN_ADDR : std_logic_vector(8-1 downto 0) := "00001100"; -- 0xc
  constant CSR_AWGN_NOISE_GAIN_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0

  -- awgn_enable - AWGN Noise Enable
  constant CSR_AWGN_ENABLE_ADDR : std_logic_vector(8-1 downto 0) := "00010000"; -- 0x10
  constant CSR_AWGN_ENABLE_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0

  -- tvalid_cnt - Counter for TValid
  constant CSR_TVALID_CNT_ADDR : std_logic_vector(8-1 downto 0) := "00010100"; -- 0x14
  constant CSR_TVALID_CNT_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0

  -- tlast_cnt - Counter for TLast
  constant CSR_TLAST_CNT_ADDR : std_logic_vector(8-1 downto 0) := "00011000"; -- 0x18
  constant CSR_TLAST_CNT_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0

  -- cnt_ctrl - Control Signals for the Strobe Counters
  constant CSR_CNT_CTRL_ADDR : std_logic_vector(8-1 downto 0) := "00011100"; -- 0x1c
  constant CSR_CNT_CTRL_RESET : std_logic_vector(32-1 downto 0) := "00000000000000000000000000000000"; -- 0x0



end package awgn_pkg;


package body awgn_pkg is

end package body;
