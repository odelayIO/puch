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

entity mult is
  generic (
    a_f, b_f, c_f     : format  := (8,4);
    satr              : boolean := true;
    rnd               : boolean := true;
    sign              : boolean := false;
    DLY               : natural := 1;
    ARST              : boolean := false -- Async Reset
  );
  port (
    ------------+-----------------------------------------------------------
    -- Clock and Reset
    rst         : in  std_logic;  -- active high reset
    clk         : in  std_logic;
    ce          : in  std_logic := '1';
    ------------+-----------------------------------------------------------
    -- Input Signals  
    A           : in  std_logic_vector(a_f.tBits-1 downto 0);
    B           : in  std_logic_vector(b_f.tBits-1 downto 0);
    In_stb      : in  std_logic;
    ------------+-----------------------------------------------------------
    -- Output Signals 
    C           : out std_logic_vector(c_f.tBits-1 downto 0);
    Out_stb     : out std_logic
  );
  --attribute USE_DSP48 : string;
  --attribute USE_DSP48 of mult : entity is "YES";
end mult;

------------------------------------------------------------------
-- Architecture for Mult
------------------------------------------------------------------
architecture RTL of mult is

  constant Q_F          : format := (A_F.tBits+B_F.tBits, A_F.fBits+B_F.fBits);
  signal q              : std_logic_vector(Q_F.tBits-1 downto 0);
  signal q_reduced      : std_logic_vector(C_F.tBits-1 downto 0);

  signal q_real         : real;
  signal q_reduced_real : real;

begin

  -- ------------------------------------------------------
  --  Multiple, then reduce
  -- ------------------------------------------------------
  q <= std_logic_vector(ieee.numeric_std."*"(
           signed(A), signed(B))) when SIGN else
       std_logic_vector(ieee.numeric_std."*"(
           unsigned(B), unsigned(B)));
  

  q_reduced <= reduce(q,Q_F,C_F,SIGN,SATR,RND);

  q_real          <= slv2real(C_F,SIGN,q_reduced);
  q_reduced_real  <= slv2real(Q_F,SIGN,q);


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



end RTL;
