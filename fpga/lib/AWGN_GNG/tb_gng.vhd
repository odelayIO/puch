-- ------------------------------------------------------------------------------
-- tb_gng.vhdl
-- This file is part of the Gaussian Noise Generator IP Core
--
-- Description
--     VHDL testbench for module gng. Generate noise sequences of
--     length N and output to file.
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
-- This source is free software; you can redistribute it and/or modify it
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
use IEEE.STD_LOGIC_SIGNED.ALL;

entity tb_gng is
end tb_gng;

architecture Behavioral of tb_gng is

    -- Constants
    constant ClkPeriod : time := 10.0 ns;
    constant Dly       : time := 1.0 ns;
    constant N         : integer := 1000;

    -- Signals
    signal clk        : std_logic := '0';
    signal rstn       : std_logic := '0';
    signal ce         : std_logic := '0';
    signal valid_out  : std_logic := '0';
    signal data_out   : std_logic_vector(15 downto 0);

    -- Instantiate the gng module for I and Q with different INIT_Z values
    component gng is
        port (
            clk         : in std_logic;
            rstn        : in std_logic;
            ce          : in std_logic;
            valid_out   : out std_logic;
            data_out    : out std_logic_vector(15 downto 0)
        );
    end component;

begin

    -- Clock Generation Process
    clk_gen: process
    begin
        clk <= '0';
        wait for ClkPeriod / 2;
        clk <= '1';
        wait for ClkPeriod / 2;
    end process clk_gen;

    -- Reset Process
    rstn_gen: process
    begin
        rstn <= '0';
        wait for ClkPeriod * 2;
        rstn <= '1';
        wait;
    end process rstn_gen;

    -- Enable Signal Process
    ce_gen: process
    begin
        ce <= '1';
        wait;
    end process ce_gen;

    -- Main Test Process
    process
        variable fpOut : text;
    begin
        -- Open file for writing
        file_open(fpOut, "gng_data_out.txt", write_mode);

        -- Deassert ce initially
        ce <= '0';

        -- Wait some time and then activate ce for noise generation
        wait for ClkPeriod * 10;
        for i in 1 to N loop
            wait until rising_edge(clk);
            wait for Dly;
            ce <= '1';
        end loop;

        -- Deassert ce after noise generation
        wait until rising_edge(clk);
        wait for Dly;
        ce <= '0';

        -- Close the file after some time
        wait for ClkPeriod * 20;
        file_close(fpOut);

        -- Stop simulation
        assert false report "Simulation stopped" severity failure;

    end process;

    -- Record data
    process(clk)
    begin
        if rising_edge(clk) then
            if valid_out = '1' then
                -- Write data to file
                write(fpOut, data_out);
                write_line(fpOut);
            end if;
        end if;
    end process;

    -- Instantiate U_gng_I (example values for INIT_Z)
    u_gng_I : gng
        port map (
            clk => clk,
            rstn => rstn,
            ce => ce,
            valid_out => valid_out,
            data_out => data_out
        );

    -- Instantiate U_gng_Q (example values for INIT_Z)
    u_gng_Q : gng
        port map (
            clk => clk,
            rstn => rstn,
            ce => ce,
            valid_out => valid_out,
            data_out => data_out
        );

end Behavioral;

