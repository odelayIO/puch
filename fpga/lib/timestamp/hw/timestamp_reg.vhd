

-- Created with Corsair vgit-latest
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timestamp_reg is
generic(
    ADDR_W : integer := 16;
    DATA_W : integer := 32;
    STRB_W : integer := 4
);
port(
    clk    : in std_logic;
    rst    : in std_logic;
    -- Time_Stamp_Year.ts_year
    csr_time_stamp_year_ts_year_in : in std_logic_vector(15 downto 0);

    -- Time_Stamp_Month.ts_month
    csr_time_stamp_month_ts_month_in : in std_logic_vector(7 downto 0);

    -- Time_Stamp_Day.ts_day
    csr_time_stamp_day_ts_day_in : in std_logic_vector(7 downto 0);

    -- Time_Stamp_Hour.ts_hour
    csr_time_stamp_hour_ts_hour_in : in std_logic_vector(7 downto 0);

    -- Time_Stamp_Minute.ts_min
    csr_time_stamp_minute_ts_min_in : in std_logic_vector(7 downto 0);

    -- Time_Stamp_Seconds.ts_sec
    csr_time_stamp_seconds_ts_sec_in : in std_logic_vector(7 downto 0);

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

architecture rtl of timestamp_reg is
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

signal csr_time_stamp_year_rdata : std_logic_vector(31 downto 0);
signal csr_time_stamp_year_ren : std_logic;
signal csr_time_stamp_year_ren_ff : std_logic;
signal csr_time_stamp_year_ts_year_ff : std_logic_vector(15 downto 0);

signal csr_time_stamp_month_rdata : std_logic_vector(31 downto 0);
signal csr_time_stamp_month_ren : std_logic;
signal csr_time_stamp_month_ren_ff : std_logic;
signal csr_time_stamp_month_ts_month_ff : std_logic_vector(7 downto 0);

signal csr_time_stamp_day_rdata : std_logic_vector(31 downto 0);
signal csr_time_stamp_day_ren : std_logic;
signal csr_time_stamp_day_ren_ff : std_logic;
signal csr_time_stamp_day_ts_day_ff : std_logic_vector(7 downto 0);

signal csr_time_stamp_hour_rdata : std_logic_vector(31 downto 0);
signal csr_time_stamp_hour_ren : std_logic;
signal csr_time_stamp_hour_ren_ff : std_logic;
signal csr_time_stamp_hour_ts_hour_ff : std_logic_vector(7 downto 0);

signal csr_time_stamp_minute_rdata : std_logic_vector(31 downto 0);
signal csr_time_stamp_minute_ren : std_logic;
signal csr_time_stamp_minute_ren_ff : std_logic;
signal csr_time_stamp_minute_ts_min_ff : std_logic_vector(7 downto 0);

signal csr_time_stamp_seconds_rdata : std_logic_vector(31 downto 0);
signal csr_time_stamp_seconds_ren : std_logic;
signal csr_time_stamp_seconds_ren_ff : std_logic;
signal csr_time_stamp_seconds_ts_sec_ff : std_logic_vector(7 downto 0);

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
-- [0x10] - Time_Stamp_Year - Time Stamp Year (Hex Value)
--------------------------------------------------------------------------------
csr_time_stamp_year_rdata(31 downto 16) <= (others => '0');


csr_time_stamp_year_ren <= ren when (raddr = "0000000000010000") else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_year_ren_ff <= '0'; -- 0x0
else
        csr_time_stamp_year_ren_ff <= csr_time_stamp_year_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Time_Stamp_Year(15 downto 0) - ts_year - Time Stamp Year (Hex Value)
-- access: ro, hardware: i
-----------------------

csr_time_stamp_year_rdata(15 downto 0) <= csr_time_stamp_year_ts_year_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_year_ts_year_ff <= "0000000000000000"; -- 0x0
else
            csr_time_stamp_year_ts_year_ff <= csr_time_stamp_year_ts_year_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x14] - Time_Stamp_Month - Time Stamp Month (Hex Value)
--------------------------------------------------------------------------------
csr_time_stamp_month_rdata(31 downto 8) <= (others => '0');


csr_time_stamp_month_ren <= ren when (raddr = "0000000000010100") else '0'; -- 0x14
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_month_ren_ff <= '0'; -- 0x0
else
        csr_time_stamp_month_ren_ff <= csr_time_stamp_month_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Time_Stamp_Month(7 downto 0) - ts_month - Time Stamp Month (Hex Value)
-- access: ro, hardware: i
-----------------------

csr_time_stamp_month_rdata(7 downto 0) <= csr_time_stamp_month_ts_month_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_month_ts_month_ff <= "00000000"; -- 0x0
else
            csr_time_stamp_month_ts_month_ff <= csr_time_stamp_month_ts_month_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x18] - Time_Stamp_Day - Time Stamp Day (Hex Value)
--------------------------------------------------------------------------------
csr_time_stamp_day_rdata(31 downto 8) <= (others => '0');


csr_time_stamp_day_ren <= ren when (raddr = "0000000000011000") else '0'; -- 0x18
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_day_ren_ff <= '0'; -- 0x0
else
        csr_time_stamp_day_ren_ff <= csr_time_stamp_day_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Time_Stamp_Day(7 downto 0) - ts_day - Time Stamp Day (Hex Value)
-- access: ro, hardware: i
-----------------------

csr_time_stamp_day_rdata(7 downto 0) <= csr_time_stamp_day_ts_day_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_day_ts_day_ff <= "00000000"; -- 0x0
else
            csr_time_stamp_day_ts_day_ff <= csr_time_stamp_day_ts_day_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x1c] - Time_Stamp_Hour - Time Stamp Hour (Hex Value)
--------------------------------------------------------------------------------
csr_time_stamp_hour_rdata(31 downto 8) <= (others => '0');


csr_time_stamp_hour_ren <= ren when (raddr = "0000000000011100") else '0'; -- 0x1c
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_hour_ren_ff <= '0'; -- 0x0
else
        csr_time_stamp_hour_ren_ff <= csr_time_stamp_hour_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Time_Stamp_Hour(7 downto 0) - ts_hour - Time Stamp Hour (Hex Value)
-- access: ro, hardware: i
-----------------------

csr_time_stamp_hour_rdata(7 downto 0) <= csr_time_stamp_hour_ts_hour_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_hour_ts_hour_ff <= "00000000"; -- 0x0
else
            csr_time_stamp_hour_ts_hour_ff <= csr_time_stamp_hour_ts_hour_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x20] - Time_Stamp_Minute - Time Stamp Minute (Hex Value)
--------------------------------------------------------------------------------
csr_time_stamp_minute_rdata(31 downto 8) <= (others => '0');


csr_time_stamp_minute_ren <= ren when (raddr = "0000000000100000") else '0'; -- 0x20
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_minute_ren_ff <= '0'; -- 0x0
else
        csr_time_stamp_minute_ren_ff <= csr_time_stamp_minute_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Time_Stamp_Minute(7 downto 0) - ts_min - Time Stamp Minute (Hex Value)
-- access: ro, hardware: i
-----------------------

csr_time_stamp_minute_rdata(7 downto 0) <= csr_time_stamp_minute_ts_min_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_minute_ts_min_ff <= "00000000"; -- 0x0
else
            csr_time_stamp_minute_ts_min_ff <= csr_time_stamp_minute_ts_min_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x24] - Time_Stamp_Seconds - Time Stamp Seconds (Hex Value)
--------------------------------------------------------------------------------
csr_time_stamp_seconds_rdata(31 downto 8) <= (others => '0');


csr_time_stamp_seconds_ren <= ren when (raddr = "0000000000100100") else '0'; -- 0x24
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_seconds_ren_ff <= '0'; -- 0x0
else
        csr_time_stamp_seconds_ren_ff <= csr_time_stamp_seconds_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Time_Stamp_Seconds(7 downto 0) - ts_sec - Time Stamp Seconds (Hex Value)
-- access: ro, hardware: i
-----------------------

csr_time_stamp_seconds_rdata(7 downto 0) <= csr_time_stamp_seconds_ts_sec_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_time_stamp_seconds_ts_sec_ff <= "00000000"; -- 0x0
else
            csr_time_stamp_seconds_ts_sec_ff <= csr_time_stamp_seconds_ts_sec_in;
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
            when "0000000000010000" => rdata_ff <= csr_time_stamp_year_rdata; -- 0x10
            when "0000000000010100" => rdata_ff <= csr_time_stamp_month_rdata; -- 0x14
            when "0000000000011000" => rdata_ff <= csr_time_stamp_day_rdata; -- 0x18
            when "0000000000011100" => rdata_ff <= csr_time_stamp_hour_rdata; -- 0x1c
            when "0000000000100000" => rdata_ff <= csr_time_stamp_minute_rdata; -- 0x20
            when "0000000000100100" => rdata_ff <= csr_time_stamp_seconds_rdata; -- 0x24
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