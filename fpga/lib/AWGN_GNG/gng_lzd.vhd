library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gng_lzd is
    Port ( data_in : in  STD_LOGIC_VECTOR (60 downto 0);  -- input data
           data_out : out  STD_LOGIC_VECTOR (5 downto 0)   -- output number of leading zeros
           );
end gng_lzd;

architecture Behavioral of gng_lzd is
    -- Local variables
    signal d : STD_LOGIC_VECTOR(63 downto 0);
    signal p1 : STD_LOGIC_VECTOR(31 downto 0);
    signal v1 : STD_LOGIC_VECTOR(31 downto 0);
    signal p2 : STD_LOGIC_VECTOR(15 downto 0);
    signal v2 : STD_LOGIC_VECTOR(15 downto 0);
    signal p3 : STD_LOGIC_VECTOR(7 downto 0);
    signal v3 : STD_LOGIC_VECTOR(7 downto 0);
    signal p4 : STD_LOGIC_VECTOR(3 downto 0);
    signal v4 : STD_LOGIC_VECTOR(3 downto 0);
    signal p5 : STD_LOGIC_VECTOR(1 downto 0);
    signal v5 : STD_LOGIC_VECTOR(1 downto 0);
    signal p6 : STD_LOGIC_VECTOR(5 downto 0);
    
    -- Signal declarations for intermediate signals
    signal p3_internal : STD_LOGIC_VECTOR(7 downto 0);
    signal v3_internal : STD_LOGIC_VECTOR(7 downto 0);
    signal p4_internal : STD_LOGIC_VECTOR(3 downto 0);
    signal v4_internal : STD_LOGIC_VECTOR(3 downto 0);
    signal p5_internal : STD_LOGIC_VECTOR(1 downto 0);
    signal v5_internal : STD_LOGIC_VECTOR(1 downto 0);
    
begin

    -- Parallel structure
    d <= data_in & "111";  -- Fill last 3 bits with '1'

    -- p1 assignments
    p1(0) <= not d(1);
    p1(1) <= not d(3);
    p1(2) <= not d(5);
    p1(3) <= not d(7);
    p1(4) <= not d(9);
    p1(5) <= not d(11);
    p1(6) <= not d(13);
    p1(7) <= not d(15);
    p1(8) <= not d(17);
    p1(9) <= not d(19);
    p1(10) <= not d(21);
    p1(11) <= not d(23);
    p1(12) <= not d(25);
    p1(13) <= not d(27);
    p1(14) <= not d(29);
    p1(15) <= not d(31);
    p1(16) <= not d(33);
    p1(17) <= not d(35);
    p1(18) <= not d(37);
    p1(19) <= not d(39);
    p1(20) <= not d(41);
    p1(21) <= not d(43);
    p1(22) <= not d(45);
    p1(23) <= not d(47);
    p1(24) <= not d(49);
    p1(25) <= not d(51);
    p1(26) <= not d(53);
    p1(27) <= not d(55);
    p1(28) <= not d(57);
    p1(29) <= not d(59);
    p1(30) <= not d(61);
    p1(31) <= not d(63);

    -- v1 assignments
    v1(0) <= d(0) or d(1);
    v1(1) <= d(2) or d(3);
    v1(2) <= d(4) or d(5);
    v1(3) <= d(6) or d(7);
    v1(4) <= d(8) or d(9);
    v1(5) <= d(10) or d(11);
    v1(6) <= d(12) or d(13);
    v1(7) <= d(14) or d(15);
    v1(8) <= d(16) or d(17);
    v1(9) <= d(18) or d(19);
    v1(10) <= d(20) or d(21);
    v1(11) <= d(22) or d(23);
    v1(12) <= d(24) or d(25);
    v1(13) <= d(26) or d(27);
    v1(14) <= d(28) or d(29);
    v1(15) <= d(30) or d(31);
    v1(16) <= d(32) or d(33);
    v1(17) <= d(34) or d(35);
    v1(18) <= d(36) or d(37);
    v1(19) <= d(38) or d(39);
    v1(20) <= d(40) or d(41);
    v1(21) <= d(42) or d(43);
    v1(22) <= d(44) or d(45);
    v1(23) <= d(46) or d(47);
    v1(24) <= d(48) or d(49);
    v1(25) <= d(50) or d(51);
    v1(26) <= d(52) or d(53);
    v1(27) <= d(54) or d(55);
    v1(28) <= d(56) or d(57);
    v1(29) <= d(58) or d(59);
    v1(30) <= d(60) or d(61);
    v1(31) <= d(62) or d(63);

    -- p2 assignments
    p2(0) <= not v1(1) & (v1(1) ? p1(1) : p1(0));
    p2(1) <= not v1(3) & (v1(3) ? p1(3) : p1(2));
    p2(2) <= not v1(5) & (v1(5) ? p1(5) : p1(4));
    p2(3) <= not v1(7) & (v1(7) ? p1(7) : p1(6));
    p2(4) <= not v1(9) & (v1(9) ? p1(9) : p1(8));
    p2(5) <= not v1(11) & (v1(11) ? p1(11) : p1(10));
    p2(6) <= not v1(13) & (v1(13) ? p1(13) : p1(12));
    p2(7) <= not v1(15) & (v1(15) ? p1(15) : p1(14));
    p2(8) <= not v1(17) & (v1(17) ? p1(17) : p1(16));
    p2(9) <= not v1(19) & (v1(19) ? p1(19) : p1(18));
    p2(10) <= not v1(21) & (v1(21) ? p1(21) : p1(20));
    p2(11) <= not v1(23) & (v1(23) ? p1(23) : p1(22));
    p2(12) <= not v1(25) & (v1(25) ? p1(25) : p1(24));
    p2(13) <= not v1(27) & (v1(27) ? p1(27) : p1(26));
    p2(14) <= not v1(29) & (v1(29) ? p1(29) : p1(28));
    p2(15) <= not v1(31) & (v1(31) ? p1(31) : p1(30));

    -- v2 assignments
    v2(0) <= v1(1) or v1(0);
    v2(1) <= v1(3) or v1(2);
    v2(2) <= v1(5) or v1(4);
    v2(3) <= v1(7) or v1(6);
    v2(4) <= v1(9) or v1(8);
    v2(5) <= v1(11) or v1(10);
    v2(6) <= v1(13) or v1(12);
    v2(7) <= v1(15) or v1(14);
    v2(8) <= v1(17) or v1(16);
    v2(9) <= v1(19) or v1(18);
    v2(10) <= v1(21) or v1(20);
    v2(11) <= v1(23) or v1(22);
    v2(12) <= v1(25) or v1(24);
    v2(13) <= v1(27) or v1(26);
    v2(14) <= v1(29) or v1(28);
    v2(15) <= v1(31) or v1(30);
    -- Assignments for p3
    p3_internal(0) <= not v2(1) & (v2(1) = '1' ? p2(1) : p2(0));
    p3_internal(1) <= not v2(3) & (v2(3) = '1' ? p2(3) : p2(2));
    p3_internal(2) <= not v2(5) & (v2(5) = '1' ? p2(5) : p2(4));
    p3_internal(3) <= not v2(7) & (v2(7) = '1' ? p2(7) : p2(6));
    p3_internal(4) <= not v2(9) & (v2(9) = '1' ? p2(9) : p2(8));
    p3_internal(5) <= not v2(11) & (v2(11) = '1' ? p2(11) : p2(10));
    p3_internal(6) <= not v2(13) & (v2(13) = '1' ? p2(13) : p2(12));
    p3_internal(7) <= not v2(15) & (v2(15) = '1' ? p2(15) : p2(14));

    -- Assignments for v3
    v3_internal(0) <= v2(1) or v2(0);
    v3_internal(1) <= v2(3) or v2(2);
    v3_internal(2) <= v2(5) or v2(4);
    v3_internal(3) <= v2(7) or v2(6);
    v3_internal(4) <= v2(9) or v2(8);
    v3_internal(5) <= v2(11) or v2(10);
    v3_internal(6) <= v2(13) or v2(12);
    v3_internal(7) <= v2(15) or v2(14);

    -- Assignments for p4
    p4_internal(0) <= not v3_internal(1) & (v3_internal(1) = '1' ? p3_internal(1) : p3_internal(0));
    p4_internal(1) <= not v3_internal(3) & (v3_internal(3) = '1' ? p3_internal(3) : p3_internal(2));
    p4_internal(2) <= not v3_internal(5) & (v3_internal(5) = '1' ? p3_internal(5) : p3_internal(4));
    p4_internal(3) <= not v3_internal(7) & (v3_internal(7) = '1' ? p3_internal(7) : p3_internal(6));

    -- Assignments for v4
    v4_internal(0) <= v3_internal(1) or v3_internal(0);
    v4_internal(1) <= v3_internal(3) or v3_internal(2);
    v4_internal(2) <= v3_internal(5) or v3_internal(4);
    v4_internal(3) <= v3_internal(7) or v3_internal(6);

    -- Assignments for p5
    p5_internal(0) <= not v4_internal(1) & (v4_internal(1) = '1' ? p4_internal(1) : p4_internal(0));
    p5_internal(1) <= not v4_internal(3) & (v4_internal(3) = '1' ? p4_internal(3) : p4_internal(2));

    -- Assignments for v5
    v5_internal(0) <= v4_internal(1) or v4_internal(0);
    v5_internal(1) <= v4_internal(3) or v4_internal(2);

    -- Assignments for p6
    p6 <= not v5_internal(1) & (v5_internal(1) = '1' ? p5_internal(1) : p5_internal(0));

    -- Output assignments
    p3 <= p3_internal;
    v3 <= v3_internal;
    p4 <= p4_internal;
    v4 <= v4_internal;
    p5 <= p5_internal;
    v5 <= v5_internal;


end Behavioral;

