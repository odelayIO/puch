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

entity delay_slv is
  generic (
    DLY       : integer := 0; -- 0: no delay, >=1: delayed
    BITS_LEN  : natural := 8;
    ARST      : boolean := TRUE -- Async Reset True: async rst, False: sync rst
  );
  port (
    rst       : in  std_logic;
    clk       : in  std_logic;
    ce        : in  std_logic;
    slv_in    : in  std_logic_vector(BITS_LEN-1 downto 0);
    slv_out   : out std_logic_vector(BITS_LEN-1 downto 0)
  );
end delay_slv;

architecture RTL of delay_slv is

  subtype subtype_pipe is std_logic_vector(BITS_LEN-1 downto 0);
  type type_pipe is array (0 to DLY-1) of subtype_pipe;

begin
  
  -- ------------------------------------------
  --  Delay std_logic_vector
  -- ------------------------------------------
  G_DELAY : if (DLY > 0) generate
    -- ------------------------------------------
    --  Sync Reset Circuit
    -- ------------------------------------------
    G_SYNC_RST : if(ARST = false) generate 
      signal pipe     : type_pipe;
    begin
      process(clk,ce)
      begin
        if(rising_edge(clk) AND ce='1') then
          if(rst = '1') then
            pipe    <= (others => (others => '0'));
          else
            pipe(0) <= slv_in;
            if (DLY > 1) then
              pipe(1 to DLY-1) <= pipe(0 to DLY-2);
            end if;
          end if;
        end if;
      end process;
      slv_out <= pipe(DLY-1);
    end generate G_SYNC_RST;

    -- ------------------------------------------
    --  ASync Reset Circuit
    -- ------------------------------------------
    G_ASYNC_RST : if(ARST = true) generate 
      signal pipe     : type_pipe;
    begin
      process(clk,ce,rst)
      begin
        if(rst = '1') then
          pipe    <= (others => (others => '0'));
        elsif(rising_edge(clk) AND ce='1') then
          pipe(0) <= slv_in;
          if (DLY > 1) then
            pipe(1 to DLY-1) <= pipe(0 to DLY-2);
          end if;
        end if;
      end process;
      slv_out <= pipe(DLY-1);
    end generate G_ASYNC_RST;
  end generate G_DELAY;


  -- ------------------------------------------
  --  Zero Delay, passthrough
  -- ------------------------------------------
  G_ZERO : if (DLY = 0) generate
    process(slv_in)
    begin
      slv_out <= slv_in;
    end process;
  end generate G_ZERO;

end RTL;
      
  
    
    

