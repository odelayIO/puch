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
use ieee.math_real.all;

library work;
use work.Arith_Pkg.all;

-- nothing to declare in testbench entity
entity TB_Add is
end TB_Add;

-- begining of architecture
architecture inside of TB_Add is

  -- -------------------------------------------------------------------------------
  -- Test Bench Parameters
  -- -------------------------------------------------------------------------------
  constant CLOCK_FREQ     : real := 200.0e6;   -- in Hz
  constant A_F            : format := (16,11);
  constant B_F            : format := (16,14);
  constant C_F            : format := (16,12);
  constant sign           : boolean := true;
  constant satr           : boolean := true;
  constant rnd            : boolean := true;
  constant arst           : boolean := false;
  constant dly            : natural := 2;

  -- -------------------------------------------------------------------------------
  -- Clock and reset
  -- -------------------------------------------------------------------------------
  constant CLOCK_PERIOD   : time := 1.0 sec / CLOCK_FREQ;
  signal clk              : std_logic := '0';
  signal rst              : std_logic := '1';
  signal ce               : std_logic := '1';

  -- -------------------------------------------------------------------------------
  -- UUT Signals
  -- -------------------------------------------------------------------------------
  signal A                : std_logic_vector(A_F.tBits-1 downto 0) := real2slv(A_F,sign,8.83);
  signal B                : std_logic_vector(B_F.tBits-1 downto 0) := real2slv(B_F,sign,-1.13);
  signal In_stb           : std_logic := '0';
  signal C                : std_logic_vector(C_F.tBits-1 downto 0);
  signal Out_stb          : std_logic;

  signal a_real           : real := 0.0;
  signal b_real           : real := 0.0;
  signal c_real           : real := 0.0;


begin
  
  -- -------------------------------------------------
  -- Create Clock with CLOCK_FREQ
  -- -------------------------------------------------
  process
  begin
    wait for CLOCK_PERIOD/2;
    clk <= NOT(clk);
  end process;

  -- -------------------------------------------------
  -- Reset Module
  -- -------------------------------------------------
  process
  begin
    wait for 200 ns;
    rst <= '0';
    wait;
  end process;

  -- -------------------------------------------------
  -- Drive Input Signals
  -- -------------------------------------------------
  process
  begin
    In_stb  <= '0';
    wait until rst = '0';
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    In_stb  <= '1';
    wait until rising_edge(clk);
    In_stb  <= '0';
    ce      <= '0';
    wait until rising_edge(clk);
    ce      <= '1';
    wait;
  end process;
   

  -- -------------------------------------------------
  -- Unit Under Test
  -- -------------------------------------------------
  UUT : entity work.Add
    generic map (
      a_f         => A_F,
      b_f         => B_F,
      c_f         => C_F,
      sign        => sign,
      satr        => satr,
      rnd         => rnd,
      arst        => arst,
      dly         => dly
    )
    port map (
      ------------+-------------------------
      -- Clock and Reset
      clk         => clk,
      ce          => ce,
      rst         => rst,
      ------------+-------------------------
      -- Input Signals
      A           => A,
      B           => B,
      In_stb      => In_stb,
      ------------+-------------------------
      -- Output Signals
      C           => C,
      Out_stb     => Out_stb
    );

  A_real <= slv2real(A_F, sign, A);
  B_real <= slv2real(B_F, sign, B);
  C_real <= slv2real(C_F, sign, C);
      
end inside;

