
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

entity Sub is
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
  ----------+-------------------------
  -- Clock and Reset
  rst       : in  std_logic;
  clk       : in  std_logic;
  ce        : in  std_logic;
  ----------+-------------------------
  -- Input signals
  a         : in  std_logic_vector;
  b         : in  std_logic_vector;
  in_stb    : in  std_logic;
  ----------+-------------------------
  -- Output Signals
  c         : out std_logic_vector;
  out_stb   : out std_logic
);
end Sub;

architecture Sub_a of Sub is


  signal ax     : std_logic_vector(max(A_F.fBits, B_F.fBits) +
                      max(A_F.tBits-A_F.fBits, B_F.tBits-B_F.fBits) downto 0);
  signal bx     :  std_logic_vector(max(A_F.fBits, B_F.fBits) +
                      max(A_F.tBits-A_F.fBits, B_F.tBits-B_F.fBits) downto 0);

  signal q      : std_logic_vector(ax'length-1 downto 0);
  constant Q_F  : format := (ax'length, max(A_F.fBits, B_F.fBits));

  signal q_reduced    : std_logic_vector(C_F.tBits-1 downto 0);

  --signal ax_real    : real;
  --signal bx_real    : real;

begin

  -- ------------------------------------------------------
  --  Sub, then reduce
  -- ------------------------------------------------------

  ax <= grow(a, A_F, Q_F, SIGN);
  bx <= grow(b, B_F, Q_F, SIGN);
  --ax_real <= slv2real(Q_F, SIGN, ax);
  --bx_real <= slv2real(Q_F, SIGN, bx);


  q <= std_logic_vector(ieee.numeric_std."-"(
           signed(ax), signed(bx))) when SIGN else
       std_logic_vector(ieee.numeric_std."-"(
           unsigned(ax), unsigned(bx)));


  q_reduced <= reduce(q,Q_F,C_F,SIGN,SATR,RND);


  -- -----------------------------------------------
  --  Pipeline Register (DLY=0 is passthrough)
  -- -----------------------------------------------
  U_STB_DLY : entity work.delay_bit 
    generic map (
      DLY       => DLY,
      ARST      => ARST
    )
    port map (
      rst       => rst,
      clk       => clk,
      ce        => ce,
      bit_in    => in_stb,
      bit_out   => out_stb
    );

 
  U_DATA_DLY : entity work.delay_slv 
    generic map (
      DLY       => DLY,
      BITS_LEN  => C_F.tBits,
      ARST      => ARST
    ) 
    port map (
      rst     => rst,
      clk     => clk,
      ce      => ce,
      slv_in  => q_reduced,
      slv_out => c 
    );

  
end Sub_a;
