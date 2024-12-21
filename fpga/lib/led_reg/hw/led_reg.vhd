

-- Created with Corsair vgit-latest
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_reg is
generic(
    ADDR_W : integer := 16;
    DATA_W : integer := 32;
    STRB_W : integer := 4
);
port(
    clk    : in std_logic;
    rst    : in std_logic;
    -- User_LEDs.user_leds
    csr_user_leds_user_leds_out : out std_logic_vector(1 downto 0);

    -- AXI-Lite
    axil_awaddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_awprot   : in  std_logic_vector(2 downto 0);
    axil_awvalid  : in  std_logic;
    axil_awready  : out std_logic;
    axil_wdata    : in  std_logic_vector(DATA_W-1 downto 0);
    axil_wstrb    : in  std_logic_vector(STRB_W-1 downto 0);
    axil_wvalid   : in  std_logic;
    axil_wready   : out std_logic;
    axil_bresp    : out std_logic_vector(1 downto 0);
    axil_bvalid   : out std_logic;
    axil_bready   : in  std_logic;
    axil_araddr   : in  std_logic_vector(ADDR_W-1 downto 0);
    axil_arprot   : in  std_logic_vector(2 downto 0);
    axil_arvalid  : in  std_logic;
    axil_arready  : out std_logic;
    axil_rdata    : out std_logic_vector(DATA_W-1 downto 0);
    axil_rresp    : out std_logic_vector(1 downto 0);
    axil_rvalid   : out std_logic;
    axil_rready   : in  std_logic

);
end entity;

architecture rtl of led_reg is
subtype ADDR_T is std_logic_vector(15 downto 0);

signal wready : std_logic;
signal waddr  : std_logic_vector(ADDR_W-1 downto 0);
signal wdata  : std_logic_vector(DATA_W-1 downto 0);
signal wen    : std_logic;
signal wstrb  : std_logic_vector(STRB_W-1 downto 0);
signal rdata  : std_logic_vector(DATA_W-1 downto 0);
signal rvalid : std_logic;
signal raddr  : std_logic_vector(ADDR_W-1 downto 0);
signal ren    : std_logic;
signal waddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal raddr_int       : std_logic_vector(ADDR_W-1 downto 0);
signal wdata_int       : std_logic_vector(DATA_W-1 downto 0);
signal strb_int        : std_logic_vector(STRB_W-1 downto 0);
signal awflag          : std_logic;
signal wflag           : std_logic;
signal arflag          : std_logic;
signal rflag           : std_logic;
signal wen_int         : std_logic;
signal ren_int         : std_logic;
signal axil_bvalid_int : std_logic;
signal axil_rdata_int  : std_logic_vector(DATA_W-1 downto 0);
signal axil_rvalid_int : std_logic;

signal csr_user_leds_rdata : std_logic_vector(31 downto 0);
signal csr_user_leds_wen : std_logic;
signal csr_user_leds_ren : std_logic;
signal csr_user_leds_ren_ff : std_logic;
signal csr_user_leds_user_leds_ff : std_logic_vector(1 downto 0);

signal rdata_ff : std_logic_vector(31 downto 0);
signal rvalid_ff : std_logic;
begin

axil_awready <= not awflag;
axil_wready  <= not wflag;
axil_bvalid  <= axil_bvalid_int;
waddr        <= waddr_int;
wdata        <= wdata_int;
wstrb        <= strb_int;
wen_int      <= awflag and wflag;
wen          <= wen_int;
axil_bresp   <= b"00";

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    waddr_int <= (others => '0');
    wdata_int <= (others => '0');
    strb_int <= (others => '0');
    awflag <= '0';
    wflag <= '0';
    axil_bvalid_int <= '0';
else
    if (axil_awvalid = '1' and awflag = '0') then
        awflag    <= '1';
        waddr_int <= axil_awaddr;
    elsif (wen_int = '1' and wready = '1') then
        awflag    <= '0';
    end if;
    if (axil_wvalid = '1' and wflag = '0') then
        wflag     <= '1';
        wdata_int <= axil_wdata;
        strb_int  <= axil_wstrb;
    elsif (wen_int = '1' and wready = '1') then
        wflag     <= '0';
    end if;
    if (axil_bvalid_int = '1' and axil_bready = '1') then
        axil_bvalid_int <= '0';
    elsif ((axil_wvalid = '1' and awflag = '1') or (axil_awvalid = '1' and wflag = '1') or (wflag = '1' and awflag = '1')) then
        axil_bvalid_int <= wready;
    end if;
end if;
end if;
end process;


axil_arready <= not arflag;
axil_rdata   <= axil_rdata_int;
axil_rvalid  <= axil_rvalid_int;
raddr        <= raddr_int;
ren_int      <= arflag and (not rflag);
ren          <= ren_int;
axil_rresp   <= b"00";

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    raddr_int <= (others => '0');
    arflag <= '0';
    rflag <= '0';
    axil_rdata_int <= (others => '0');
    axil_rvalid_int <= '0';
else
    if (axil_arvalid = '1' and arflag = '0') then
        arflag    <= '1';
        raddr_int <= axil_araddr;
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        arflag    <= '0';
    end if;
    if (rvalid = '1' and ren_int = '1' and rflag = '0') then
        rflag <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        rflag <= '0';
    end if;
    if (rvalid = '1' and axil_rvalid_int = '0') then
        axil_rdata_int  <= rdata;
        axil_rvalid_int <= '1';
    elsif (axil_rvalid_int = '1' and axil_rready = '1') then
        axil_rvalid_int <= '0';
    end if;
end if;
end if;
end process;


--------------------------------------------------------------------------------
-- CSR:
-- [0x10] - User_LEDs - User Leds on KR260 (user_leds[1:0])
--------------------------------------------------------------------------------
csr_user_leds_rdata(31 downto 2) <= (others => '0');

csr_user_leds_wen <= wen when (waddr = "0000000000010000") else '0'; -- 0x10

csr_user_leds_ren <= ren when (raddr = "0000000000010000") else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_user_leds_ren_ff <= '0'; -- 0x0
else
        csr_user_leds_ren_ff <= csr_user_leds_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- User_LEDs(1 downto 0) - user_leds - User LEDs
-- access: rw, hardware: o
-----------------------

csr_user_leds_rdata(1 downto 0) <= csr_user_leds_user_leds_ff;

csr_user_leds_user_leds_out <= csr_user_leds_user_leds_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_user_leds_user_leds_ff <= "00"; -- 0x0
else
        if (csr_user_leds_wen = '1') then
            if (wstrb(0) = '1') then
                csr_user_leds_user_leds_ff(1 downto 0) <= wdata(1 downto 0);
            end if;
        else
            csr_user_leds_user_leds_ff <= csr_user_leds_user_leds_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- Write ready
--------------------------------------------------------------------------------
wready <= '1';

--------------------------------------------------------------------------------
-- Read address decoder
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    rdata_ff <= "00000000000000000000000000000000"; -- 0x0
else
    if (ren = '1') then
        case ADDR_T'(raddr) is
            when "0000000000010000" => rdata_ff <= csr_user_leds_rdata; -- 0x10
            when others => rdata_ff <= "00000000000000000000000000000000"; -- 0x0
        end case;
    else
        rdata_ff <= "00000000000000000000000000000000"; -- 0x0
    end if;
end if;
end if;
end process;

rdata <= rdata_ff;

--------------------------------------------------------------------------------
-- Read data valid
--------------------------------------------------------------------------------
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    rvalid_ff <= '0'; -- 0x0
else
    if ((ren = '1') and (rvalid = '1')) then
        rvalid_ff <= '0';
    elsif (ren = '1') then
        rvalid_ff <= '1';
    end if;
end if;
end if;
end process;


rvalid <= rvalid_ff;

end architecture;