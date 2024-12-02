library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gng_smul_16_18_sadd_37 is
    Port (
        clk : in STD_LOGIC;                       -- System clock
        a   : in STD_LOGIC_VECTOR(15 downto 0);   -- Multiplicand (16 bits)
        b   : in STD_LOGIC_VECTOR(17 downto 0);   -- Multiplicator (18 bits)
        c   : in STD_LOGIC_VECTOR(36 downto 0);   -- Adder input (37 bits)
        p   : out STD_LOGIC_VECTOR(37 downto 0)   -- Result (37 bits)
    );
end gng_smul_16_18_sadd_37;

architecture Behavioral of gng_smul_16_18_sadd_37 is
    -- Internal signal declarations
    signal a_reg   : STD_LOGIC_VECTOR(15 downto 0);
    signal b_reg   : STD_LOGIC_VECTOR(17 downto 0);
    signal c_reg   : STD_LOGIC_VECTOR(36 downto 0);
    signal prod    : STD_LOGIC_VECTOR(33 downto 0);  -- Product (34 bits)
    signal sum     : STD_LOGIC_VECTOR(37 downto 0);  -- Sum (38 bits)
    signal result  : STD_LOGIC_VECTOR(37 downto 0);  -- Final result (38 bits)
begin

    -- Sequential logic for a, b, and c registers
    process(clk)
    begin
        if rising_edge(clk) then
            a_reg <= a;
            b_reg <= b;
            c_reg <= c;
        end if;
    end process;

    -- Sequential logic for product computation
    process(clk)
    begin
        if rising_edge(clk) then
            prod <= std_logic_vector(signed(a_reg) * signed(b_reg));  -- Signed multiplication
        end if;
    end process;

    -- Sum calculation
    sum <= std_logic_vector(signed(c_reg) + signed(prod));  -- Signed addition of c and prod

    -- Sequential logic to store the result
    process(clk)
    begin
        if rising_edge(clk) then
            result <= sum;  -- Store the result after the sum
        end if;
    end process;

    -- Assign the final result to the output
    p <= result;

end Behavioral;

