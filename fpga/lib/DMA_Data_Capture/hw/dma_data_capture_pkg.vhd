-- Created with Corsair vgit-latest

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


package dma_data_capture_pkg is



  constant CSR_BASE_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);

  -- Max_Depth - The depth of the capture FIFO
  constant CSR_MAX_DEPTH_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(0, 8);
  constant CSR_MAX_DEPTH_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- Capture_Length - The number of samples to capture in buffer
  constant CSR_CAPTURE_LENGTH_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(4, 8);
  constant CSR_CAPTURE_LENGTH_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- Capture_Stb - Capture Strobe, self clearing 1cc strobe
  constant CSR_CAPTURE_STB_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(8, 8);
  constant CSR_CAPTURE_STB_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- FIFO_Flush - Flush the FIFO for a new capture trigger
  constant CSR_FIFO_FLUSH_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(12, 8);
  constant CSR_FIFO_FLUSH_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- FIFO_WR_Ptr - FIFO Write Pointer
  constant CSR_FIFO_WR_PTR_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(16, 8);
  constant CSR_FIFO_WR_PTR_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);

  -- FIFO_RD_Ptr - FIFO Read Pointer
  constant CSR_FIFO_RD_PTR_ADDR : std_logic_vector(8-1 downto 0) := to_unsigned(20, 8);
  constant CSR_FIFO_RD_PTR_RESET : std_logic_vector(32-1 downto 0) := to_unsigned(0, 32);



end package dma_data_capture_pkg;


package body dma_data_capture_pkg is

end package body;
