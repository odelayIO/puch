--#############################################################################################
--#############################################################################################
--#
--#   The MIT License (MIT)
--#   
--#   Copyright (c) 2023 http://odelay.io 
--#   
--#   Permission is hereby granted, free of charge, to any person obtaining a copy
--#   of this software and associated documentation files (the "Software"), to deal
--#   in the Software without restriction, including without limitation the rights
--#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--#   copies of the Software, and to permit persons to whom the Software is
--#   furnished to do so, subject to the following conditions:
--#   
--#   The above copyright notice and this permission notice shall be included in all
--#   copies or substantial portions of the Software.
--#   
--#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--#   SOFTWARE.
--#   
--#   Contact : <everett@odelay.io>
--#  
--#   Description : Xilinx Vitis HLS Fixed Gain Block for AXI Stream Interface
--#
--#   Version History:
--#   
--#       Date        Description
--#     -----------   -----------------------------------------------------------------------
--#      2024-02-04    Original Creation
--#
--###########################################################################################
--###########################################################################################


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.ALL;

entity tb_gng is
end tb_gng;

architecture Behavioral of tb_gng is

    -- Constants
    constant ClkPeriod  : time := 10.0 ns;
    constant N          : integer := 1000;
    constant F_FRAC     : integer := 11; -- fractional bits output of GNG

    file fpOut          : text open write_mode is
      "../../../../../../../lib/AWGN_GNG/sim/gng_data_out.txt";

    -- Signals
    signal clk          : std_logic := '0';
    signal rstn         : std_logic := '0';
    signal ce           : std_logic := '0';
    signal valid_out_I  : std_logic := '0';
    signal data_out_I   : std_logic_vector(15 downto 0);
    signal valid_out_Q  : std_logic := '0';
    signal data_out_Q   : std_logic_vector(15 downto 0);


begin

    -- ----------------------------------------
    -- Clock Generation Process
    -- ----------------------------------------
    clk_gen: process
    begin
        clk <= '0';
        wait for ClkPeriod / 2;
        clk <= '1';
        wait for ClkPeriod / 2;
    end process clk_gen;

    -- ----------------------------------------
    -- Reset Process
    -- ----------------------------------------
    rstn_gen: process
    begin
        rstn <= '0';
        wait for ClkPeriod * 20;
        rstn <= '1';
        wait;
    end process rstn_gen;


    -- ----------------------------------------
    -- Test the CE
    -- ----------------------------------------
    ce_gen: process
    begin

        -- Assert ce initially
        ce <= '1';
        wait for 1 us;


        -- Deassert ce 
        wait until rising_edge(clk);
        ce <= '0';
        wait for 3 us;

        -- Assert ce 
        wait until rising_edge(clk);
        ce <= '1';
        wait for 6 us;

        -- Deassert ce 
        wait until rising_edge(clk);
        ce <= '0';
        wait for 4 us;

        -- Assert ce 
        wait until rising_edge(clk);
        ce <= '1';

        -- Stop simulation
        assert false report "Simulation stopped" severity note;
        wait;
    end process ce_gen;


    -- ----------------------------------------
    -- Record data
    -- ----------------------------------------
    write_file: process(clk)
      variable v_line   : line;
    begin
        if rising_edge(clk) then
            if valid_out_I = '1' then
                -- Write data to file
                write(v_line, real(to_integer(signed(data_out_I)))/2.0**F_FRAC);
                --write(v_line, ',');
                write(v_line, string'(", "));
                write(v_line, real(to_integer(signed(data_out_Q)))/2.0**F_FRAC);
                writeline(fpOut, v_line);
            end if;
        end if;
    end process write_file;

    -- --------------------------------------------------------
    -- Instantiate U_gng_I (example values for INIT_Z)
    -- --------------------------------------------------------
    u_gng_I : entity work.gng
      generic map (
        INIT_Z1     => x"6094bc1bd3d8db9a",
        INIT_Z2     => x"d36035b0ca17e666",
        INIT_Z3     => x"e2d0b140ab8ac10b"
      )
      port map (
        clk         => clk,
        rstn        => rstn,
        ce          => ce,
        valid_out   => valid_out_I,
        data_out    => data_out_I
      );

    -- --------------------------------------------------------
    -- Instantiate U_gng_Q (example values for INIT_Z)
    -- --------------------------------------------------------
    u_gng_Q : entity work.gng
      generic map (
        INIT_Z1     => x"bc6840786a43d19a",
        INIT_Z2     => x"4756b3c2f33b8c9f",
        INIT_Z3     => x"32b439953f41c5e7"
      )
      port map (
        clk         => clk,
        rstn        => rstn,
        ce          => ce,
        valid_out   => valid_out_Q,
        data_out    => data_out_Q
      );

end Behavioral;

