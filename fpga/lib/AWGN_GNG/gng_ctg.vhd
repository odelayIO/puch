-- ------------------------------------------------------------------------------
-- gng_ctg.vhdl
--
-- This file is part of the Gaussian Noise Generator IP Core
--
-- Description
--     Maximally equidistributed combined Tausworthe generator with
-- (k1,k2,k3) = (63,58,55); (q1,q2,q3) = (5,19,24); (s1,s2,s3) = (24,13,7).
-- Period is approximately 2^176.
--
-- ------------------------------------------------------------------------------
-- Copyright (C) 2014, Guangxi Liu <guangxi.liu@opencores.org>
-- ------------------------------------------------------------------------------
-- This source file may be used and distributed without restriction provided
-- that this copyright statement is not removed from the file and that any
-- derivative work contains the original copyright notice and the associated
-- disclaimer.
-- ------------------------------------------------------------------------------
-- This source is free software; you can redistribute it and/or modify it
-- under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2.1 of the License,
-- or (at your option) any later version.
-- ------------------------------------------------------------------------------
-- You should have received a copy of the GNU Lesser General Public License
-- along with this source; if not, download it from
-- http://www.opencores.org/lgpl.shtml
-- ------------------------------------------------------------------------------
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity gng_ctg is
    generic (
        INIT_Z1 : integer := 5030521883283424767;
        INIT_Z2 : integer := 18445829279364155008;
        INIT_Z3 : integer := 18436106298727503359
    );
    port (
        clk        : in  STD_LOGIC;             -- system clock
        rstn       : in  STD_LOGIC;             -- system synchronous reset, active low
        ce         : in  STD_LOGIC;             -- clock enable
        valid_out  : out STD_LOGIC;             -- output data valid
        data_out   : out STD_LOGIC_VECTOR(63 downto 0)  -- output data
    );
end gng_ctg;
 
architecture Behavioral of gng_ctg is
    signal z1, z2, z3 : STD_LOGIC_VECTOR(63 downto 0);
    signal z1_next, z2_next, z3_next : STD_LOGIC_VECTOR(63 downto 0);
 
begin
 
    -- Update state (next values for z1, z2, and z3)
    z1_next <= z1(39 downto 1) & z1(58 downto 34) xor z1(63 downto 39);
    z2_next <= z2(50 downto 6) & z2(44 downto 26) xor z2(63 downto 45);
    z3_next <= z3(56 downto 9) & z3(39 downto 24) xor z3(63 downto 48);
 
    -- Sequential logic for updating z1, z2, z3 on each clock cycle
    process(clk, rstn)
    begin
        if (rstn = '0') then
            z1 <= (others => '0');
            z2 <= (others => '0');
            z3 <= (others => '0');
        elsif (rising_edge(clk)) then
            if (ce = '1') then
                z1 <= z1_next;
                z2 <= z2_next;
                z3 <= z3_next;
            end if;
        end if;
    end process;
 
    -- Output data valid signal
    process(clk, rstn)
    begin
        if (rstn = '0') then
            valid_out <= '0';
        elsif (rising_edge(clk)) then
            valid_out <= ce;
        end if;
    end process;
 
    -- Output data (XOR of z1_next, z2_next, and z3_next)
    process(clk, rstn)
    begin
        if (rstn = '0') then
            data_out <= (others => '0');
        elsif (rising_edge(clk)) then
            data_out <= z1_next xor z2_next xor z3_next;
        end if;
    end process;
 
end Behavioral;

