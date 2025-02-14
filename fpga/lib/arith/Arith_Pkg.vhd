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
use ieee.numeric_std_unsigned.all;
use ieee.math_real.all;


package Arith_Pkg is

  -- -------------------------------------------------------------------------
  -- Signal Types
  -- -------------------------------------------------------------------------
  -- tBits: total # of bits in value; fBits: # of fractional bits
  type format is record
    tBits       : integer;
    fBits       : integer;
  end record format;

  -- -------------------------------------------------------------------------
  -- Functions
  -- -------------------------------------------------------------------------
  function slv2real(F : format; sign : boolean; A : std_logic_vector) return real;
  function real2slv(F : format; sign : boolean; A : real) return std_logic_vector;
  function neg(A : std_logic_vector) return std_logic_vector;
  function re(A : std_logic_vector) return std_logic_vector;
  function im(A : std_logic_vector) return std_logic_vector;

  function zeros(n  : natural) return std_logic_vector;
  function ones(n  : natural) return std_logic_vector;
  function max(a, b : std_logic_vector) return std_logic_vector;
  function max(a, b : signed) return signed;
  function max(a, b : unsigned) return unsigned;
  function max(a, b : integer) return integer;

  function min(a, b : std_logic_vector) return std_logic_vector;
  function min(a, b : signed) return signed;
  function min(a, b : unsigned) return unsigned;
  function min(a, b : integer) return integer;


  function grow(a   : std_logic_vector; a_f, r_f : format; sign : boolean := true) return std_logic_vector;
  function round(a  : std_logic_vector; n : natural; sat_check : boolean := true) return std_logic_vector;
  function sat(a    : std_logic_vector; sign, rnd : boolean; n : natural) return std_logic_vector;
  function is_sat(a : std_logic_vector; sign : boolean := true) return std_logic;

  function reduce (
    a : std_logic_vector;
    a_f, r_f : format; 
    sign  : boolean := true; 
    satr  : boolean := true;
    rnd   : boolean := false) return std_logic_vector;

  -- -------------------------------------------------------------------------
  -- Components
  -- -------------------------------------------------------------------------


    --  Should instantiate the modules with library reference
    --  Example:
    -- 
    --    U_DUT : entity work.Add 
    --      ...


end;

package body Arith_Pkg is
  -- Converts SLV to a real value given tBits and fBits
  function slv2real(F : format; sign : boolean; A : std_logic_vector) return real is
    variable result  : real := 0.0;
  begin
    if (sign = true) then
      for i in 0 to F.tBits-2 loop
        if (A(i) = '1') then
          result := result + real(2.0**(i-F.fBits));
        end if;
      end loop;
      if (A(F.tBits-1) = '1') then
        result := real(-1) * real(real(2**(F.tBits-F.fBits-1)) - result);
      end if;
    else
      for i in 0 to F.tBits-1 loop
        if (A(i) = '1') then
          result := result + real(2.0**(i-F.fBits));
        end if;
      end loop;
    end if;
    return result;
  end function slv2real;
  
  -- Converts a real value to a SLV given tBits and fBits 
  function real2slv(F : format; sign : boolean; A : real) return std_logic_vector is
    variable result     : std_logic_vector(F.tBits-1 downto 0);
    variable frac       : integer;
    variable int        : integer;
  begin
    int       := integer(floor(A));
    frac      := integer(floor((A - floor(A)) * real(2**(F.fBits))));
    if (sign = true) then
      result    := std_logic_vector(to_signed(int,F.tBits-F.fBits)) &
                   std_logic_vector(to_signed(frac,F.fBits));
    else
      result    := std_logic_vector(to_unsigned(int,F.tBits-F.fBits)) &
                   std_logic_vector(to_unsigned(frac,F.fBits));
    end if;
    return result;
  end function real2slv;

  function sat(a  : std_logic_vector; sign, rnd : boolean; n : natural) return std_logic_vector is
    constant zero : std_logic_vector(a'length-n-1 downto 0) := ( others => '0' );
    constant one  : std_logic_vector(a'length-n-1 downto 0) := ( others => '1' );
    variable b    : std_logic_vector(n-1 downto 0);
  begin
    if ( n = a'length ) then
      return a;
    end if;
    if ( sign = true ) then
      if ( a(a'length-1) = '0' ) then
        if ( (a((a'length-2) downto (n-1)) = zero) OR (rnd = false)) then
          b := a(b'range);
        else
          b := (others  => '1');
          b(b'left) := '0';
        end if;
      else
        if ( (a((a'length-2) downto (n-1)) = one) OR (rnd = false)) then
          b := a(b'range);
        else
          b := (others  => '0');
          b(b'left) := '1';
        end if;
      end if;
    else
      -- saturate unsigned input a to unsigned output b
      if ( (a((a'length-1) downto n) = zero) OR (rnd = false) ) then
        b := a(b'range);
      else
        b := ( others => '1' );
      end if;
    end if;
    return b;
  end sat;

  function is_sat(a : std_logic_vector; sign : boolean := true) return std_logic is
    constant one  : std_logic_vector(a'length-1 downto 0) := (others => '1');
    constant zero : std_logic_vector(a'length-1 downto 0) := (others => '0');
  begin
    if (sign = true) then
      if(a(a'length-1) = '1') then
        if (a(a'length-2 downto 0) = zero(a'length-2 downto 0)) then
          -- Sign Value is min, e.g. 1000.0000 = -2 (8,6)
          return '1';
        else
          return '0';
        end if;
      else
        if (a(a'length-2 downto 0) = one(a'length-2 downto 0)) then
          -- Sign Value is max, e.g. 0111.1111 = 1.9844 (8,6)
          return '1';
        else
          return '0';
        end if;
      end if;
    else
      if (a = one) then
        -- Unsigned value is max, e.g. 1111.1111 = 3.9844 (8,6)
        return '1';
      else
        return '0';
      end if;
    end if;
    return '0';
  end is_sat;



  function reduce(
    a : std_logic_vector;
    a_f, r_f : format; 
    sign  : boolean := true; 
    satr  : boolean := true;
    rnd   : boolean := false) return std_logic_vector is
    constant shift : integer := (a_f.tBits-a_f.fBits)-(r_f.tBits-r_f.fBits);
    variable q1    : std_logic_vector(a'length-((a_f.tBits-a_f.fBits)-(r_f.tBits-r_f.fBits))-1 downto 0);
    variable q2    : std_logic_vector(a'length-shift-1 downto 0);
  begin
    if (satr = true) then
      q1 := sat(a=>a, sign=>sign, rnd=>true, n=>q1'length);
    else
      q2 := sat(a=>a, sign=>sign, rnd=>false, n=>q1'length);
    end if;
    if (rnd = true) then
      if (satr = true) then
        return round(q1, r_f.tBits, satr);
      else
        return round(q2, r_f.tBits, satr);
      end if;
    else
      if (satr = true) then
        return q1(q1'length-1 downto q1'length-r_f.tBits);
      else
        return q2(q2'length-1 downto q2'length-r_f.tBits);
      end if;
    end if;
  end function reduce;

      
  function neg(A : std_logic_vector) return std_logic_vector is
  begin
    return std_logic_vector(unsigned(NOT(A))+1);
  end function neg;

  function re(A : std_logic_vector) return std_logic_vector is
  begin
    return std_logic_vector(A(A'length-1 downto A'length/2));
  end function re;

  function im(A : std_logic_vector) return std_logic_vector is
  begin
    return std_logic_vector(A(A'length/2-1 downto 0));
  end function im;

  function zeros(n : natural) return std_logic_vector is
    variable b     : std_logic_vector(n-1 downto 0);
  begin
    b := ( others => '0' );
    return b;
  end zeros;

  function ones(n : natural) return std_logic_vector is
    variable b    : std_logic_vector(n-1 downto 0);
  begin
    b := ( others => '1' );
    return b;
  end ones;

  function max(a, b : std_logic_vector) return std_logic_vector is
  begin
    if(a > b) then
      return a;
    else
      return b;
    end if;
  end function max;

  function max(a, b : signed) return signed is
  begin
    if(a > b) then
      return a;
    else
      return b;
    end if;
  end function max;

  function max(a, b : unsigned) return unsigned is
  begin
    if(a > b) then
      return a;
    else
      return b;
    end if;
  end function max;


  function max(a, b : integer) return integer is
  begin
    if(a > b) then
      return a;
    else
      return b;
    end if;
  end function max;

  function min(a, b : std_logic_vector) return std_logic_vector is
  begin
    if(a > b) then
      return b;
    else
      return a;
    end if;
  end function min;

  function min(a, b : signed) return signed is
  begin
    if(a > b) then
      return b;
    else
      return a;
    end if;
  end function min;

  function min(a, b : unsigned) return unsigned is
  begin
    if(a > b) then
      return b;
    else
      return a;
    end if;
  end function min;

  function min(a, b : integer) return integer is
  begin
    if(a > b) then
      return b;
    else
      return a;
    end if;
  end function min;

  function grow(
    a         : std_logic_vector;
    a_f, r_f  : format;
    sign      : boolean := true) return std_logic_vector is
  begin
    if(r_f.fBits > a_f.fBits) then
      if(sign) then
        return std_logic_vector(resize(signed(a & zeros(r_f.fBits-a_f.fBits)),r_f.tBits));
      else
        return std_logic_vector(resize(unsigned(a & zeros(r_f.fBits-a_f.fBits)),r_f.tBits));
      end if;
    else
      if(sign) then
        return std_logic_vector(resize(signed(a),r_f.tBits));
      else
        return std_logic_vector(resize(unsigned(a),r_f.tBits));
      end if;
    end if;
  end function grow;

  function round(a : std_logic_vector; n : natural; sat_check : boolean := true) return std_logic_vector is
    variable b : std_logic_vector(n-1 downto 0);
  begin
    if n = a'length then
      b := a;
    elsif n > a'length then
      assert false report "Cannot round to higher precision" severity error;
      b := a;
    else
      if (a(a'length-n-1) = '1') then
         if sat_check then
           if (a(a'length-1) = '0' and a(a'length-2 downto a'length-n) = ones(n-1)) then
             b := a(a'length-1 downto a'length-n);
           else
             b := a(a'length-1 downto a'length-n) + 1;
           end if;
         else
           b := a(a'length-1 downto a'length-n) + 1;
         end if;   
      else
        b := a(a'length-1 downto a'length-n);
      end if;
    end if;
    return b;
  end round;


end package body;
  

