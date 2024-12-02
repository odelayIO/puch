--------------------------------------------------------------------------------
--
-- gng.vhdl
--
-- This file is part of the Gaussian Noise Generator IP Core
--
-- Description
--     Top module of Gaussian noise generator.
--
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gng is
    generic (
        INIT_Z1 : integer := 5030521883283424767;
        INIT_Z2 : integer := 18445829279364155008;
        INIT_Z3 : integer := 18436106298727503359
    );
    port (
        -- System signals
        clk        : in  std_logic;           -- system clock
        rstn       : in  std_logic;           -- system synchronous reset, active low
        
        -- Data interface
        ce         : in  std_logic;           -- clock enable
        valid_out  : out std_logic;           -- output data valid
        data_out   : out std_logic_vector(15 downto 0)  -- output data, s<16,11>
    );
end gng;

architecture Behavioral of gng is

    -- Local signals
    signal valid_out_ctg : std_logic;
    signal data_out_ctg  : std_logic_vector(63 downto 0);

    -- Component Declaration for gng_ctg
    component gng_ctg is
        generic (
            INIT_Z1 : integer := 5030521883283424767;
            INIT_Z2 : integer := 18445829279364155008;
            INIT_Z3 : integer := 18436106298727503359
        );
        port (
            clk        : in  std_logic;
            rstn       : in  std_logic;
            ce         : in  std_logic;
            valid_out  : out std_logic;
            data_out   : out std_logic_vector(63 downto 0)
        );
    end component;

    -- Component Declaration for gng_interp
    component gng_interp is
        port (
            clk        : in  std_logic;
            rstn       : in  std_logic;
            valid_in   : in  std_logic;
            data_in    : in  std_logic_vector(63 downto 0);
            valid_out  : out std_logic;
            data_out   : out std_logic_vector(15 downto 0)
        );
    end component;

begin

    -- Instantiation of gng_ctg
    u_gng_ctg : gng_ctg
        generic map (
            INIT_Z1 => INIT_Z1,
            INIT_Z2 => INIT_Z2,
            INIT_Z3 => INIT_Z3
        )
        port map (
            clk        => clk,
            rstn       => rstn,
            ce         => ce,
            valid_out  => valid_out_ctg,
            data_out   => data_out_ctg
        );

    -- Instantiation of gng_interp
    u_gng_interp : gng_interp
        port map (
            clk        => clk,
            rstn       => rstn,
            valid_in   => valid_out_ctg,
            data_in    => data_out_ctg,
            valid_out  => valid_out,
            data_out   => data_out
        );

end Behavioral;

