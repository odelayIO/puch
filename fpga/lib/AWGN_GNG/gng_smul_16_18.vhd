-- ------------------------------------------------------------------------------
-- gng_smul_16_18.vhdl
-- This file is part of the Gaussian Noise Generator IP Core
--
-- Description
--     Signed multiplier 16-bit x 18-bit, delay 2 cycles.
--
-- ------------------------------------------------------------------------------
--
-- Copyright (C) 2014, Guangxi Liu <guangxi.liu@opencores.org>
--
-- This source file may be used and distributed without restriction provided
-- that this copyright statement is not removed from the file and that any
-- derivative work contains the original copyright notice and the associated
-- disclaimer.
--
-- This source file is free software; you can redistribute it and/or modify it
-- under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2.1 of the License,
-- or (at your option) any later version.
--
-- This source is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-- or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
-- License for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with this source; if not, download it from
-- http://www.opencores.org/lgpl.shtml
--
-- ------------------------------------------------------------------------------
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gng_smul_16_18 is
    Port ( clk : in STD_LOGIC;                  -- system clock
           a   : in STD_LOGIC_VECTOR(15 downto 0); -- multiplicand
           b   : in STD_LOGIC_VECTOR(17 downto 0); -- multiplicator
           p   : out STD_LOGIC_VECTOR(33 downto 0) -- result
         );
end gng_smul_16_18;

architecture Behavioral of gng_smul_16_18 is
    signal a_reg : signed(15 downto 0);
    signal b_reg : signed(17 downto 0);
    signal prod  : signed(33 downto 0);
begin

    -- Process to store inputs on rising edge of clk
    process(clk)
    begin
        if rising_edge(clk) then
            a_reg <= to_signed(to_integer(signed(a)), 16);
            b_reg <= to_signed(to_integer(signed(b)), 18);
        end if;
    end process;

    -- Process to multiply the inputs on rising edge of clk
    process(clk)
    begin
        if rising_edge(clk) then
            prod <= a_reg * b_reg;
        end if;
    end process;

    -- Assign the product to the output
    p <= std_logic_vector(prod);

end Behavioral;

