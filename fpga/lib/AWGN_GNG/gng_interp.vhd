-- ------------------------------------------------------------------------------
-- gng_interp.vhdl
--
-- This file is part of the Gaussian Noise Generator IP Core
--
-- Description
--     Polynomial interpolation.
-- ------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gng_interp is
    port (
        -- System signals
        clk        : in  STD_LOGIC;                -- system clock
        rstn       : in  STD_LOGIC;                -- system synchronous reset, active low
        
        -- Data interface
        valid_in   : in  STD_LOGIC;                -- input data valid
        data_in    : in  STD_LOGIC_VECTOR(63 downto 0);  -- input data
        valid_out  : out STD_LOGIC;                -- output data valid
        data_out   : out STD_LOGIC_VECTOR(15 downto 0)  -- output data, s<16,11>
    );
end gng_interp;

architecture Behavioral of gng_interp is

    -- Local signals
    signal num_lzd      : STD_LOGIC_VECTOR(5 downto 0);
    signal num_lzd_r    : STD_LOGIC_VECTOR(5 downto 0);
    signal mask         : STD_LOGIC_VECTOR(14 downto 0);
    signal offset       : STD_LOGIC_VECTOR(1 downto 0);
    signal addr         : STD_LOGIC_VECTOR(7 downto 0);
    signal c0, c1, c2  : STD_LOGIC_VECTOR(17 downto 0);
    signal x            : STD_LOGIC_VECTOR(14 downto 0);
    signal x_r1, x_r2, x_r3, x_r4 : STD_LOGIC_VECTOR(14 downto 0);
    signal c1_r1        : STD_LOGIC_VECTOR(17 downto 0);
    signal sum1         : STD_LOGIC_VECTOR(37 downto 0);
    signal sum1_new     : STD_LOGIC_VECTOR(17 downto 0);
    signal mul1         : STD_LOGIC_VECTOR(33 downto 0);
    signal mul1_new     : STD_LOGIC_VECTOR(13 downto 0);
    signal c0_r1, c0_r2, c0_r3, c0_r4, c0_r5 : STD_LOGIC_VECTOR(17 downto 0);
    signal sum2         : STD_LOGIC_VECTOR(18 downto 0);
    signal sum2_rnd     : STD_LOGIC_VECTOR(14 downto 0);
    signal sign_r       : STD_LOGIC_VECTOR(8 downto 0);
    signal valid_in_r   : STD_LOGIC_VECTOR(8 downto 0);

begin

    -- Leading zero detector
    u_gng_lzd : entity work.gng_lzd
        port map (
            data_in => data_in(63 downto 3),
            data_out => num_lzd
        );

    -- Register num_lzd_r
    process(clk, rstn)
    begin
        if rstn = '0' then
            num_lzd_r <= (others => '0');
        elsif rising_edge(clk) then
            num_lzd_r <= num_lzd;
        end if;
    end process;

    -- Get mask for value x
    process(clk, rstn)
    begin
        if rstn = '0' then
            mask <= (others => '1');
        elsif rising_edge(clk) then
            case num_lzd_r is
                when "111101" => mask <= "111111111111111";
                when "111100" => mask <= "011111111111111";
                when "111011" => mask <= "101111111111111";
                when "111010" => mask <= "110111111111111";
                when "111001" => mask <= "111011111111111";
                when "111000" => mask <= "111101111111111";
                when "110111" => mask <= "111110111111111";
                when "110110" => mask <= "111111011111111";
                when "110101" => mask <= "111111101111111";
                when "110100" => mask <= "111111110111111";
                when "110011" => mask <= "111111111011111";
                when "110010" => mask <= "111111111101111";
                when "110001" => mask <= "111111111110111";
                when "110000" => mask <= "111111111111011";
                when "101111" => mask <= "111111111111101";
                when "101110" => mask <= "111111111111110";
                when others => mask <= "111111111111111";
            end case;
        end if;
    end process;

    -- Generate table address and coefficients
    process(clk, rstn)
    begin
        if rstn = '0' then
            offset <= "00";
        elsif rising_edge(clk) then
            offset <= data_in(2 downto 1);
        end if;
    end process;

    addr <= num_lzd_r & offset;

    -- Coefficients generator
    u_gng_coef : entity work.gng_coef
        port map (
            clk => clk,
            addr => addr,
            c0 => c0,
            c1 => c1,
            c2 => c2
        );

    -- Data delay
    process(clk, rstn)
    begin
        if rstn = '0' then
            x <= (others => '0');
        elsif rising_edge(clk) then
            x <= data_in(17 downto 3);
        end if;
    end process;

    process(clk, rstn)
    begin
        if rstn = '0' then
            x_r1 <= (others => '0');
            x_r2 <= (others => '0');
            x_r3 <= (others => '0');
            x_r4 <= (others => '0');
        elsif rising_edge(clk) then
            x_r1 <= x and mask;
            x_r2 <= x_r1;
            x_r3 <= x_r2;
            x_r4 <= x_r3;
        end if;
    end process;

    -- Register c1_r1
    process(clk, rstn)
    begin
        if rstn = '0' then
            c1_r1 <= (others => '0');
        elsif rising_edge(clk) then
            c1_r1 <= c1;
        end if;
    end process;

    -- Register c0 coefficients
    process(clk, rstn)
    begin
        if rstn = '0' then
            c0_r1 <= (others => '0');
            c0_r2 <= (others => '0');
            c0_r3 <= (others => '0');
            c0_r4 <= (others => '0');
            c0_r5 <= (others => '0');
        elsif rising_edge(clk) then
            c0_r1 <= c0;
            c0_r2 <= c0_r1;
            c0_r3 <= c0_r2;
            c0_r4 <= c0_r3;
            c0_r5 <= c0_r4;
        end if;
    end process;

    -- Register sign
    process(clk, rstn)
    begin
        if rstn = '0' then
            sign_r <= (others => '0');
        elsif rising_edge(clk) then
            sign_r <= sign_r(7 downto 0) & data_in(0);
        end if;
    end process;

    -- Register valid_in_r
    process(clk, rstn)
    begin
        if rstn = '0' then
            valid_in_r <= (others => '0');
        elsif rising_edge(clk) then
            valid_in_r <= valid_in_r(7 downto 0) & valid_in;
        end if;
    end process;

    -- Polynomial interpolation: Multiply and add
    u_gng_smul_16_18_sadd_37 : entity work.gng_smul_16_18_sadd_37
        port map (
            clk => clk,
            a => "0" & x_r1,
            b => "0" & c2,
            c => c1_r1 & "000000000000000000",
            p => sum1
        );

    sum1_new <= sum1(37 downto 20);

    u_gng_smul_16_18 : entity work.gng_smul_16_18
        port map (
            clk => clk,
            a => "0" & x_r4,
            b => sum1_new,
            p => mul1
        );

    mul1_new <= mul1(32 downto 19);

    -- Sum2 calculation
    process(clk, rstn)
    begin
        if rstn = '0' then
            sum2 <= (others => '0');
        elsif rising_edge(clk) then
            sum2 <= signed("0" & c0_r5) + signed(mul1_new);
        end if;
    end process;

    -- Round sum2
    sum2_rnd <= sum2(17 downto 3) + sum2(2);

    -- Output valid_out and data_out
    process(clk, rstn)
    begin
      if(rstn = '0') then
        valid_out  <= '0';
      else
        valid_out  <= valid_in_r(8);
      end if;
    end process;

  process(clk, rstn)
  begin
      if rstn = '0' then
          data_out <= (others => '0');
      elsif rising_edge(clk) then
          if sign_r(8) = '1' then
              data_out <= "1" & not sum2_rnd + "1";
          else
              data_out <= "0" & sum2_rnd;
          end if;
      end if;
  end process;

end Behavioral;

