--------------------------------------------------------------------------------
--
-- gng_coef.vhdl
--
-- This file is part of the Gaussian Noise Generator IP Core
--
-- Description:
--     Coefficients ROM table for polynomial interpolation.
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

entity gng_coef is
    port (
        clk    : in  STD_LOGIC;        -- system clock
        addr   : in  STD_LOGIC_VECTOR(7 downto 0);  -- read address
        c0     : out STD_LOGIC_VECTOR(17 downto 0); -- coefficient c0, u<18,14>
        c1     : out STD_LOGIC_VECTOR(17 downto 0); -- coefficient c1, s<18,19>
        c2     : out STD_LOGIC_VECTOR(16 downto 0)  -- coefficient c2, u<17,23>
    );
end gng_coef;

architecture Behavioral of gng_coef is

    -- Local variable to hold the coefficients
    signal d : STD_LOGIC_VECTOR(52 downto 0);  -- {c0, c1, c2}

begin

  -- Table for coefficients based on the address
  process (addr)
  begin
      case addr is
          when "00000000" => d <= "000010101100101001_100110111110001110_10100011110000000";
          when "00000001" => d <= "000001111101000111_101001011111011001_01011111011110011";
          when "00000010" => d <= "000001010001100100_101010111101101110_00110010101000000";
          when "00000011" => d <= "000000101000010001_101011101111111001_00001111111010011";
          when "00000100" => d <= "000100100110011110_101100101100100010_10101101110011100";
          when "00000101" => d <= "000100000010100011_101111010111110111_01110101000001100";
          when "00000110" => d <= "000011100011000111_110001001011101011_01010011011010011";
          when "00000111" => d <= "000011000110110001_110010011110011100_00111101101011001";
          when "00001000" => d <= "000110001000101110_101111110110101010_10100011001000110";

      8'd9  : d = 53'b000101101010111101_110010010111100001_01101111010111011;
      8'd10 : d = 53'b000101010001011010_110100000101110001_01010000111111000;
      8'd11 : d = 53'b000100111010110110_110101010110001001_00111101100100011;
      8'd12 : d = 53'b000111011100110110_110001111001100101_10010111001100011;
      8'd13 : d = 53'b000111000010111111_110100001110101001_01100111010010101;
      8'd14 : d = 53'b000110101101000010_110101110100111010_01001011010000101;
      8'd15 : d = 53'b000110011001110111_110110111111100110_00111001011001010;
      8'd16 : d = 53'b001000100111011000_110011010110100101_10001100100110110;
      8'd17 : d = 53'b001000010000010000_110101100001001100_01011111111010010;
      8'd18 : d = 53'b000111111100110010_110111000000001000_01000101110011111;
      8'd19 : d = 53'b000111101011110111_111000000101011011_00110101001101001;
      8'd20 : d = 53'b001001101010111000_110100011100101111_10000011100100011;
      8'd21 : d = 53'b001001010101110100_110110011110011100_01011001100101001;
      8'd22 : d = 53'b001001000100001010_110111110111000110_01000001000110100;
      8'd23 : d = 53'b001000110100111000_111000110111101101_00110001100011100;
      8'd24 : d = 53'b001010101000111110_110101010011111110_01111011110111110;
      8'd25 : d = 53'b001010010101100000_110111001110000100_01010100001100011;
      8'd26 : d = 53'b001010000101010000_111000100001011001_00111101000110010;
      8'd27 : d = 53'b001001110111001111_111001011110000001_00101110011100100;
      8'd28 : d = 53'b001011100010101101_110110000000110101_01110101010001000;
      8'd29 : d = 53'b001011010000100011_110111110100011001_01001111100101010;
      8'd30 : d = 53'b001011000001011011_111001000011001010_00111001101011010;
      8'd31 : d = 53'b001010110100011010_111001111100011001_00101011110010110;
      8'd32 : d = 53'b001100011000111001_110110100110001001_01101111100010101;
      8'd33 : d = 53'b001100000111110011_111000010100000101_01001011100110010;
      8'd34 : d = 53'b001011111001100110_111001011110111001_00110110101110100;
      8'd35 : d = 53'b001011101101011011_111010010101001100_00101001100000110;
      8'd36 : d = 53'b001101001100000100_110111000101110100_01101010100010001;
      8'd37 : d = 53'b001100111011111001_111000101110110010_01001000000111110;
      8'd38 : d = 53'b001100101110011110_111001110110001010_00110100001010001;
      8'd39 : d = 53'b001100100010111110_111010101001111011_00100111100001111;
      8'd40 : d = 53'b001101111100101100_110111100001000101_01100110000110111;
      8'd41 : d = 53'b001101101101010011_111001000101101101_01000101000011110;
      8'd42 : d = 53'b001101100000100011_111010001010000011_00110001111001101;
      8'd43 : d = 53'b001101010101101000_111010111011100011_00100101110010101;
      8'd44 : d = 53'b001110101011000101_110111111000111001_01100010001010110;
      8'd45 : d = 53'b001110011100011000_111001011001101000_01000010010101101;
      8'd46 : d = 53'b001110010000001101_111010011011010001_00101111111001101;
      8'd47 : d = 53'b001110000101110011_111011001010110011_00100100010000001;
      8'd48 : d = 53'b001111010111100001_111000001101111010_01011110101000100;
      8'd49 : d = 53'b001111001001011011_111001101011001001_00111111111001110;
      8'd50 : d = 53'b001110111101110000_111010101010011000_00101110000111001;
      8'd51 : d = 53'b001110110011110011_111011011000001000_00100010111000010;
      8'd52 : d = 53'b010000000010001111_111000100000100111_01011011011100010;
      8'd53 : d = 53'b001111110100101011_111001111010101101_00111101101101001;
      8'd54 : d = 53'b001111101001011101_111010110111110001_00101100100000001;
      8'd55 : d = 53'b001111011111111001_111011100011111010_00100001101001010;
      8'd56 : d = 53'b010000101011011010_111000110001011010_01011000100010101;
      8'd57 : d = 53'b010000011110010100_111010001000101001_00111011101101101;
      8'd58 : d = 53'b010000010011100000_111011000011101110_00101011000010110;
      8'd59 : d = 53'b010000001010010010_111011101110011011_00100000100001110;
      8'd60 : d = 53'b010001010011001011_111001000000100110_01010101111001000;
      8'd61 : d = 53'b010001000110100001_111010010101001110_00111001111001011;
      8'd62 : d = 53'b010000111100000101_111011001110100000_00101001101101110;
      8'd63 : d = 53'b010000110011001011_111011110111111001_00011111100000110;
      8'd64 : d = 53'b010001111001101011_111001001110011010_01010011011101011;
      8'd65 : d = 53'b010001101101011010_111010100000101000_00111000001110110;
      8'd66 : d = 53'b010001100011010011_111011011000010001_00101000011111111;
      8'd67 : d = 53'b010001011010101100_111100000000011100_00011110100101010;
      8'd68 : d = 53'b010010011111000010_111001011011000010_01010001001101111;
      8'd69 : d = 53'b010010010011001000_111010101011000011_00110110101100101;
      8'd70 : d = 53'b010010001001010100_111011100001001011_00100111011000011;
      8'd71 : d = 53'b010010000000111110_111100001000001111_00011101101110101;
      8'd72 : d = 53'b010011000011010100_111001100110101010_01001111001001001;
      8'd73 : d = 53'b010010110111110000_111010110100101000_00110101010001111;
      8'd74 : d = 53'b010010101110001110_111011101001010101_00100110010110010;
      8'd75 : d = 53'b010010100110000111_111100001111011000_00011100111100001;
      8'd76 : d = 53'b010011100110101001_111001110001011000_01001101001101110;
      8'd77 : d = 53'b010011011011011000_111010111101011100_00110011111101110;
      8'd78 : d = 53'b010011010010000110_111011110000110110_00100101011000111;
      8'd79 : d = 53'b010011001010001101_111100010101111100_00011100001101100;
      8'd80 : d = 53'b010100001001000100_111001111011010100_01001011011010110;
      8'd81 : d = 53'b010011111110000101_111011000101100111_00110010101111010;
      8'd82 : d = 53'b010011110101000010_111011110111110011_00100100011111111;
      8'd83 : d = 53'b010011101101010110_111100011100000001_00011011100010000;
      8'd84 : d = 53'b010100101010101001_111010000100100011_01001001101111010;
      8'd85 : d = 53'b010100011111111011_111011001101001100_00110001100110000;
      8'd86 : d = 53'b010100010111000110_111011111110010000_00100011101010101;
      8'd87 : d = 53'b010100001111100110_111100100001101001_00011010111001100;
      8'd88 : d = 53'b010101001011011100_111010001101001011_01001000001010100;
      8'd89 : d = 53'b010101000000111110_111011010100010000_00110000100001100;
      8'd90 : d = 53'b010100111000010110_111100000100010001_00100010111000110;
      8'd91 : d = 53'b010100110001000001_111100100110111000_00011010010011100;
      8'd92 : d = 53'b010101101011100000_111010010101001111_01000110101011110;
      8'd93 : d = 53'b010101100001010001_111011011010111000_00101111100001000;
      8'd94 : d = 53'b010101011000110110_111100001001111000_00100010001010000;
      8'd95 : d = 53'b010101010001101011_111100101011110001_00011001110000000;
      8'd96 : d = 53'b010110001010111001_111010011100110100_01000101010010101;
      8'd97 : d = 53'b010110000000110111_111011100001000100_00101110100100011;
      8'd98 : d = 53'b010101111000101000_111100001111001001_00100001011110000;
      8'd99 : d = 53'b010101110001100111_111100110000010110_00011001001110100;
      8'd100: d = 53'b010110101001101001_111010100011111100_01000011111110011;
      8'd101: d = 53'b010110011111110100_111011100110111001_00101101101011001;
      8'd102: d = 53'b010110010111101111_111100010100000101_00100000110100100;
      8'd103: d = 53'b010110010000111000_111100110100101001_00011000101111000;
      8'd104: d = 53'b010111000111110010_111010101010101010_01000010101110101;
      8'd105: d = 53'b010110111110001010_111011101100011001_00101100110101000;
      8'd106: d = 53'b010110110110001111_111100011000101111_00100000001101010;
      8'd107: d = 53'b010110101111100000_111100111000101100_00011000010001010;
      8'd108: d = 53'b010111100101010111_111010110001000000_01000001100011001;
      8'd109: d = 53'b010111011011111010_111011110001100101_00101100000001110;
      8'd110: d = 53'b010111010100001000_111100011101001000_00011111101000001;
      8'd111: d = 53'b010111001101100010_111100111100100000_00010111110101000;
      8'd112: d = 53'b011000000010011001_111010110111000001_01000000011011011;
      8'd113: d = 53'b010111111001000111_111011110110011111_00101011010001001;
      8'd114: d = 53'b010111110001011110_111100100001010011_00011111000100111;
      8'd115: d = 53'b010111101011000000_111101000000000111_00010111011010010;
      8'd116: d = 53'b011000011110111010_111010111100101110_00111111010111001;
      8'd117: d = 53'b011000010101110010_111011111011001001_00101010100010111;
      8'd118: d = 53'b011000001110010011_111100100101001111_00011110100011011;
      8'd119: d = 53'b011000000111111011_111101000011100010_00010111000000111;
      8'd120: d = 53'b011000111010111100_111011000010001010_00111110010110001;
      8'd121: d = 53'b011000110001111110_111011111111100100_00101001110110111;
      8'd122: d = 53'b011000101010100111_111100101000111110_00011110000011100;
      8'd123: d = 53'b011000100100010110_111101000110110010_00010110101000110;
      8'd124: d = 53'b011001010110100001_111011000111010100_00111101011000001;
      8'd125: d = 53'b011001001101101100_111100000011110001_00101001001100110;
      8'd126: d = 53'b011001000110011100_111100101100100010_00011101100101001;
      8'd127: d = 53'b011001000000010011_111101001001111000_00010110010001110;
      8'd128: d = 53'b011001110001101001_111011001100001111_00111100011100111;
      8'd129: d = 53'b011001101000111101_111100000111110010_00101000100100101;
      8'd130: d = 53'b011001100001110101_111100101111111011_00011101001000001;
      8'd131: d = 53'b011001011011110010_111101001100110100_00010101111011110;
      8'd132: d = 53'b011010001100010110_111011010000111100_00111011100100001;
      8'd133: d = 53'b011010000011110011_111100001011100111_00100111111110010;
      8'd134: d = 53'b011001111100110010_111100110011001001_00011100101100011;
      8'd135: d = 53'b011001110110110101_111101001111100111_00010101100110101;
      8'd136: d = 53'b011010100110101010_111011010101011011_00111010101101111;
      8'd137: d = 53'b011010011110001111_111100001111010001_00100111011001101;
      8'd138: d = 53'b011010010111010101_111100110110001111_00011100010001111;
      8'd139: d = 53'b011010010001011101_111101010010010010_00010101010010101;
      8'd140: d = 53'b011011000000100101_111011011001101110_00111001111001110;
      8'd141: d = 53'b011010111000010010_111100010010110001_00100110110110011;
      8'd142: d = 53'b011010110001011110_111100111001001100_00011011111000011;
      8'd143: d = 53'b011010101011101100_111101010100110110_00010100111111010;
      8'd144: d = 53'b011011011010001001_111011011101110110_00111001000111110;
      8'd145: d = 53'b011011010001111101_111100010110000111_00100110010100100;
      8'd146: d = 53'b011011001011001111_111100111100000001_00011011100000000;
      8'd147: d = 53'b011011000101100010_111101010111010011_00010100101100111;
      8'd148: d = 53'b011011110011010110_111011100001110011_00111000010111101;
      8'd149: d = 53'b011011101011010001_111100011001010101_00100101110100000;
      8'd150: d = 53'b011011100100101001_111100111110101111_00011011001000100;
      8'd151: d = 53'b011011011111000010_111101011001101010_00010100011011000;
      8'd152: d = 53'b011100001100001101_111011100101100111_00110111101001100;
      8'd153: d = 53'b011100000100001111_111100011100011011_00100101010100110;
      8'd154: d = 53'b011011111101101101_111101000001010110_00011010110001111;
      8'd155: d = 53'b011011111000001010_111101011011111010_00010100001010000;
      8'd156: d = 53'b011100100100110000_111011101001010001_00110110111100111;
      8'd157: d = 53'b011100011100111000_111100011111011001_00100100110110110;
      8'd158: d = 53'b011100010110011100_111101000011110110_00011010011100010;
      8'd159: d = 53'b011100010000111110_111101011110000101_00010011111001101;
      8'd160: d = 53'b011100111100111110_111011101100110010_00110110010010000;
      8'd161: d = 53'b011100110101001101_111100100010001111_00100100011001110;
      8'd162: d = 53'b011100101110110110_111101000110010000_00011010000111010;
      8'd163: d = 53'b011100101001011100_111101100000001010_00010011101001110;
      8'd164: d = 53'b011101010100111001_111011110000001011_00110101101000101;
      8'd165: d = 53'b011101001101001110_111100100101000000_00100011111101110;
      8'd166: d = 53'b011101000110111100_111101001000100101_00011001110011001;
      8'd167: d = 53'b011101000001100111_111101100010001010_00010011011010100;
      8'd168: d = 53'b011101101100100001_111011110011011100_00110101000000101;
      8'd169: d = 53'b011101100100111101_111100100111101001_00100011100010111;
      8'd170: d = 53'b011101011110101111_111101001010110100_00011001011111101;
      8'd171: d = 53'b011101011001011110_111101100100000110_00010011001011110;
      8'd172: d = 53'b011110000011111000_111011110110100110_00110100011010000;
      8'd173: d = 53'b011101111100011001_111100101010001101_00100011001000110;
      8'd174: d = 53'b011101110110010000_111101001100111110_00011001001100111;
      8'd175: d = 53'b011101110001000011_111101100101111110_00010010111101101;
      8'd176: d = 53'b011110011010111101_111011111001101001_00110011110100110;
      8'd177: d = 53'b011110010011100100_111100101100101011_00100010101111100;
      8'd178: d = 53'b011110001101011111_111101001111000011_00011000111010110;
      8'd179: d = 53'b011110001000010110_111101100111110001_00010010101111111;
      8'd180: d = 53'b011110110001110001_111011111100100101_00110011010000101;
      8'd181: d = 53'b011110101010011101_111100101111000100_00100010010111001;
      8'd182: d = 53'b011110100100011101_111101010001000100_00011000101001001;
      8'd183: d = 53'b011110011111011000_111101101001100000_00010010100010100;
      8'd184: d = 53'b011111001000010110_111011111111011011_00110010101101101;
      8'd185: d = 53'b011111000001000111_111100110001011000_00100001111111101;
      8'd186: d = 53'b011110111011001011_111101010011000000_00011000011000001;
      8'd187: d = 53'b011110110110001001_111101101011001100_00010010010101110;
      8'd188: d = 53'b011111011110101010_111100000010001100_00110010001011110;
      8'd189: d = 53'b011111010111100000_111100110011100111_00100001101000110;
      8'd190: d = 53'b011111010001101001_111101010100111001_00011000000111101;
      8'd191: d = 53'b011111001100101010_111101101100110100_00010010001001010;
      8'd192: d = 53'b011111110100101111_111100000100110111_00110001101011000;
      8'd193: d = 53'b011111101101101010_111100110101110010_00100001010010101;
      8'd194: d = 53'b011111100111110111_111101010110101101_00010111110111110;
      8'd195: d = 53'b011111100010111100_111101101110011001_00010001111101010;
      8'd196: d = 53'b100000001010100110_111100000111011101_00110001001011010;
      8'd197: d = 53'b100000000011100101_111100110111111000_00100000111101010;
      8'd198: d = 53'b011111111101110110_111101011000011110_00010111101000010;
      8'd199: d = 53'b011111111000111110_111101101111111010_00010001110001100;
      8'd200: d = 53'b100000100000001110_111100001001111101_00110000101100101;
      8'd201: d = 53'b100000011001010010_111100111001111010_00100000101000100;
      8'd202: d = 53'b100000010011100110_111101011010001100_00010111011001011;
      8'd203: d = 53'b100000001110110010_111101110001011001_00010001100110010;
      8'd204: d = 53'b100000110101101001_111100001100011001_00110000001111001;
      8'd205: d = 53'b100000101110110001_111100111011111000_00100000010100101;
      8'd206: d = 53'b100000101001001001_111101011011110110_00010111001011000;
      8'd207: d = 53'b100000100100011000_111101110010110101_00010001011011011;
      8'd208: d = 53'b100001001010110110_111100001110110000_00101111110011010;
      8'd209: d = 53'b100001000100000010_111100111101110011_00100000000001101;
      8'd210: d = 53'b100000111110011110_111101011101011101_00010110111101010;
      8'd211: d = 53'b100000111001101111_111101110100001110_00010001010001000;
      8'd212: d = 53'b100001011111110110_111100010001000010_00101111011001100;
      8'd213: d = 53'b100001011001000111_111100111111101001_00011111101111111;
      8'd214: d = 53'b100001010011100101_111101011111000001_00010110110000010;
      8'd215: d = 53'b100001001110111010_111101110101100100_00010001000111001;
      8'd216: d = 53'b100001110100101001_111100010011001110_00101111000011000;
      8'd217: d = 53'b100001101101111110_111101000001011100_00011111100000001;
      8'd218: d = 53'b100001101000100000_111101100000100010_00010110100100101;
      8'd219: d = 53'b100001100011110111_111101110110111000_00010000111110001;
      8'd220: d = 53'b100010001001010000_111100010101010100_00101110110010010;
      8'd221: d = 53'b100010000010101001_111101000011001010_00011111010011101;
      8'd222: d = 53'b100001111101001110_111101100001111111_00010110011011000;
      8'd223: d = 53'b100001111000101000_111101111000001001_00010000110110100;
      8'd224: d = 53'b100010011101101011_111100010111010010_00101110101100100;
      8'd225: d = 53'b100010010111000111_111101000100110010_00011111001101001;
      8'd226: d = 53'b100010010001110000_111101100011011000_00010110010101000;
      8'd227: d = 53'b100010001101001101_111101111001010110_00010000110001010;
      8'd228: d = 53'b100010110001111010_111100011001000101_00101110111011101;
      8'd229: d = 53'b100010101011011010_111101000110010011_00011111010010001;
      8'd230: d = 53'b100010100110000110_111101100100101100_00010110010110000;
      8'd231: d = 53'b100010100001100101_111101111010100000_00010000110000101;
      8'd232: d = 53'b100011000101111110_111100011010100111_00101111110100001;
      8'd233: d = 53'b100010111111100010_111101000111101011_00011111101101110;
      8'd234: d = 53'b100010111010010000_111101100101111001_00010110100100111;
      8'd235: d = 53'b100010110101110010_111101111011100101_00010000111001000;
      8'd236: d = 53'b100011011001110111_111100101000100000_00000000000000000;
      8'd237: d = 53'b100011010011011110_111101010001001010_00000000000000000;
      8'd238: d = 53'b100011001110010000_111101101100110110_00000000000000000;
      8'd239: d = 53'b100011001001110100_111110000000111011_00000000000000000;
      8'd240: d = 53'b100011101101100101_000000000000000000_00000000000000000;
      8'd241: d = 53'b100011100111010000_000000000000000000_00000000000000000;
      8'd242: d = 53'b100011100010000100_000000000000000000_00000000000000000;
      8'd243: d = 53'b100011011101101011_000000000000000000_00000000000000000;
      8'd244: d = 53'b100100100111110000_000000000000000000_00000000000000000;
      8'd245: d = 53'b100100010100100001_000000000000000000_00000000000000000;
      8'd246: d = 53'b100100000001001000_000000000000000000_00000000000000000;
      8'd247: d = 53'b100011110101101101_000000000000000000_00000000000000000;



          -- Add other cases here as per the original Verilog code...
          when others => d <= (others => '0');
      end case;
  end process;

  -- Assign the coefficients to the output signals
  process (d)
  begin
      c0 <= d(52 downto 35);  -- Coefficient c0
      c1 <= d(34 downto 17);   -- Coefficient c1
      c2 <= d(16 downto 0);    -- Coefficient c2
  end process;

end Behavioral;

