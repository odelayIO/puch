
--******************************************************************************
--******************************************************************************
--****
--****  (c) Copyright 2018 Odelay Solutions.  
--****  All rights reserved. This code embodies materials and 
--****  concepts which are confidential to Odelay Solutions 
--****  and is made available subject to the terms
--****  of a separate written license agreement.
--****
--****
--****  Author      : Everett M. Stone
--****  Company     : Odelay Solutions
--****  Date        : 2019.02.08
--****
--****
--****  Entity      : Arith Library
--****  Technology  : VHDL-2008
--****  Library     : work
--****
--****  Description : 
--****
--****
--****  Revision    : v1 - Initial Release 
--****
--****
--******************************************************************************
--******************************************************************************




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Arith_Pkg.all;

entity Add is
generic (
  A_F       : format;
  B_F       : format;
  C_F       : format;
  SIGN      : boolean := TRUE;
  SATR      : boolean := TRUE;
  RND       : boolean := TRUE;
	ARST      : boolean := TRUE;
  DLY       : natural := 1
);
port (
  clk       : in  std_logic;
  ce        : in  std_logic;
  rst       : in  std_logic;
  a         : in  std_logic_vector;
  b         : in  std_logic_vector;
  in_stb    : in  std_logic;
  c         : out std_logic_vector;
  out_stb   : out std_logic
);
end Add;

architecture Add_a of Add is


  signal ax     : std_logic_vector(max(A_F.fBits, B_F.fBits) +
                      max(A_F.tBits-A_F.fBits, B_F.tBits-B_F.fBits) downto 0);
  signal bx     : std_logic_vector(max(A_F.fBits, B_F.fBits) +
                      max(A_F.tBits-A_F.fBits, B_F.tBits-B_F.fBits) downto 0);

  signal   q    : std_logic_vector(ax'length-1 downto 0);
  constant Q_F  : format := (ax'length, max(A_F.fBits, B_F.fBits));

  subtype pipe_word is std_logic_vector(q'length-1 downto 0);
  type pipe_word_array is array (0 to DLY-1) of pipe_word;

  signal q_out  : std_logic_vector(q'length-1 downto 0);


  signal pipe_slv   : pipe_word_array;
  signal pipe_bit   : std_logic_vector(0 to DLY-1);

  signal ax_real    : real;
  signal bx_real    : real;

begin

  --ax <= grow(a, A_F, Q_F, SIGN) when (Q_F.tBits > A_F.tBits) else a;
  --bx <= grow(b, B_F, Q_F, SIGN) when (Q_F.tBits > B_F.tBits) else b;
  ax <= grow(a, A_F, Q_F, SIGN);
  bx <= grow(b, B_F, Q_F, SIGN);
  --ax_real <= slv2real(Q_F, SIGN, ax);
  --bx_real <= slv2real(Q_F, SIGN, bx);


  q <= std_logic_vector(ieee.numeric_std."+"(
           signed(ax), signed(bx))) when SIGN else
       std_logic_vector(ieee.numeric_std."+"(
           unsigned(ax), unsigned(bx)));

  G_DLY_Eq_0 : if ( DLY = 0 ) generate
    q_out   <= q;
    out_stb <= in_stb;
  end generate G_DLY_Eq_0;

	-- Sync Reset Signal 
	G_SYNC_RST : if( ARST = false ) generate
		G_DLY_Gt_0 : if ( DLY > 0 ) generate
			process(clk,ce)
			begin
				if ( rising_edge(clk) AND ce='1' ) then
					if ( rst = '1' ) then
						pipe_slv  <= ( others => ( others => '0' ) );
            pipe_bit  <= (others => '0');
					else
            if(in_stb = '1') then
						  pipe_slv(0) <= q;
              pipe_bit(0) <= in_stb;
            else
              pipe_bit(0) <= '0';
            end if;
						for i in 1 to DLY-1 loop
							pipe_slv(i) <= pipe_slv(i-1);
							pipe_bit(i) <= pipe_bit(i-1);
						end loop;
					end if;
				end if;
			end process;
			q_out   <= pipe_slv(DLY-1);
      out_stb <= pipe_bit(DLY-1);
		end generate G_DLY_Gt_0;
	end generate G_SYNC_RST;


	-- Async Reset Signal 
	G_ASYNC_RST : if( ARST = true ) generate
		G_DLY_Gt_0 : if ( DLY > 0 ) generate
			process(clk,rst,ce)
			begin
				if ( rst = '1' ) then
					pipe_slv <= ( others => ( others => '0' ) );
					pipe_bit <= (others => '0');
				elsif ( rising_edge(clk) AND ce='1' ) then
          if(in_stb = '1') then
					  pipe_slv(0) <= q;
            pipe_bit(0) <= in_stb;
          else
            pipe_bit(0) <= '0';
          end if;
					for i in 1 to DLY-1 loop
						pipe_slv(i) <= pipe_slv(i-1);
						pipe_bit(i) <= pipe_bit(i-1);
					end loop;
				end if;
			end process;
			q_out   <= pipe_slv(DLY-1);
      out_stb <= pipe_bit(DLY-1);
		end generate G_DLY_Gt_0;
	end generate G_ASYNC_RST;

  c <= reduce(q_out,Q_F,C_F,SIGN,SATR,RND);
  
end Add_a;
