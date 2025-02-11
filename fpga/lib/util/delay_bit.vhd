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
--****  Entity      : Utility Library
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

entity delay_bit is
  generic (
    DLY       : integer;
    ARST      : boolean -- Async Reset True: async rst, False: sync rst
  );
  port (
    rst       : in  std_logic;
    clk       : in  std_logic;
    ce        : in  std_logic;
    bit_in    : in  std_logic;
    bit_out   : out std_logic
  );
end delay_bit;

architecture RTL of delay_bit is

  signal vect_in    : std_logic_vector(0 downto 0);
  signal vect_out   : std_logic_vector(0 downto 0);
  
begin
  vect_in(0)  <= bit_in;
  bit_out     <= vect_out(0);
  
  DSLV : entity work.delay_slv 
    generic map (
      DLY       => DLY,
      BITS_LEN  => 1,
      ARST      => ARST
    ) 
    port map (
      rst     => rst,
      clk     => clk,
      ce      => ce,
      slv_in  => vect_in,
      slv_out => vect_out
    );
  
end RTL;
      
  
    
    
