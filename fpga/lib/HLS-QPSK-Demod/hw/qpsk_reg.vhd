

-- Created with Corsair vgit-latest
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity qpsk_reg is
generic(
    ADDR_W : integer := 8;
    DATA_W : integer := 32;
    STRB_W : integer := 4
);
port(
    clk    : in std_logic;
    rst    : in std_logic;
    -- F_in.F_in_total
    csr_f_in_f_in_total_in : in std_logic_vector(15 downto 0);
    -- F_in.F_in_fractional
    csr_f_in_f_in_fractional_in : in std_logic_vector(15 downto 0);

    -- F_out.F_out_total
    csr_f_out_f_out_total_in : in std_logic_vector(15 downto 0);
    -- F_out.F_out_fractional
    csr_f_out_f_out_fractional_in : in std_logic_vector(15 downto 0);

    -- AP_Control.ap_start
    csr_ap_control_ap_start_out : out std_logic;
    -- AP_Control.ap_done
    csr_ap_control_ap_done_in : in std_logic;
    -- AP_Control.ap_idle
    csr_ap_control_ap_idle_in : in std_logic;

    -- WR_Cap_CTRL.wr_addr
    csr_wr_cap_ctrl_wr_addr_in : in std_logic_vector(15 downto 0);
    -- WR_Cap_CTRL.wr_enable
    csr_wr_cap_ctrl_wr_enable_out : out std_logic;
    -- WR_Cap_CTRL.wr_addr_clr
    csr_wr_cap_ctrl_wr_addr_clr_out : out std_logic;

    -- RD_Cap_CTRL.rd_addr
    csr_rd_cap_ctrl_rd_addr_out : out std_logic_vector(15 downto 0);
    -- RD_Cap_CTRL.rd_enable
    csr_rd_cap_ctrl_rd_enable_out : out std_logic;

    -- RD_Cap_DATA.rd_data
    csr_rd_cap_data_rd_data_in : in std_logic_vector(31 downto 0);

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

architecture rtl of qpsk_reg is
subtype ADDR_T is std_logic_vector(7 downto 0);

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

signal csr_f_in_rdata : std_logic_vector(31 downto 0);
signal csr_f_in_ren : std_logic;
signal csr_f_in_ren_ff : std_logic;
signal csr_f_in_f_in_total_ff : std_logic_vector(15 downto 0);
signal csr_f_in_f_in_fractional_ff : std_logic_vector(15 downto 0);

signal csr_f_out_rdata : std_logic_vector(31 downto 0);
signal csr_f_out_ren : std_logic;
signal csr_f_out_ren_ff : std_logic;
signal csr_f_out_f_out_total_ff : std_logic_vector(15 downto 0);
signal csr_f_out_f_out_fractional_ff : std_logic_vector(15 downto 0);

signal csr_ap_control_rdata : std_logic_vector(31 downto 0);
signal csr_ap_control_wen : std_logic;
signal csr_ap_control_ren : std_logic;
signal csr_ap_control_ren_ff : std_logic;
signal csr_ap_control_ap_start_ff : std_logic;
signal csr_ap_control_ap_done_ff : std_logic;
signal csr_ap_control_ap_idle_ff : std_logic;

signal csr_wr_cap_ctrl_rdata : std_logic_vector(31 downto 0);
signal csr_wr_cap_ctrl_wen : std_logic;
signal csr_wr_cap_ctrl_ren : std_logic;
signal csr_wr_cap_ctrl_ren_ff : std_logic;
signal csr_wr_cap_ctrl_wr_addr_ff : std_logic_vector(15 downto 0);
signal csr_wr_cap_ctrl_wr_enable_ff : std_logic;
signal csr_wr_cap_ctrl_wr_addr_clr_ff : std_logic;

signal csr_rd_cap_ctrl_rdata : std_logic_vector(31 downto 0);
signal csr_rd_cap_ctrl_wen : std_logic;
signal csr_rd_cap_ctrl_ren : std_logic;
signal csr_rd_cap_ctrl_ren_ff : std_logic;
signal csr_rd_cap_ctrl_rd_addr_ff : std_logic_vector(15 downto 0);
signal csr_rd_cap_ctrl_rd_enable_ff : std_logic;

signal csr_rd_cap_data_rdata : std_logic_vector(31 downto 0);
signal csr_rd_cap_data_wen : std_logic;
signal csr_rd_cap_data_ren : std_logic;
signal csr_rd_cap_data_ren_ff : std_logic;
signal csr_rd_cap_data_rd_data_ff : std_logic_vector(31 downto 0);

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
-- [0x0] - F_in - Input data stream format
--------------------------------------------------------------------------------


csr_f_in_ren <= ren when (raddr = "00000000") else '0'; -- 0x0
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_in_ren_ff <= '0'; -- 0x0
else
        csr_f_in_ren_ff <= csr_f_in_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- F_in(15 downto 0) - F_in_total - Input data stream format total bit width
-- access: ro, hardware: i
-----------------------

csr_f_in_rdata(15 downto 0) <= csr_f_in_f_in_total_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_in_f_in_total_ff <= "0000000000000000"; -- 0x0
else
            csr_f_in_f_in_total_ff <= csr_f_in_f_in_total_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- F_in(31 downto 16) - F_in_fractional - Input data stream format fractional bits
-- access: ro, hardware: i
-----------------------

csr_f_in_rdata(31 downto 16) <= csr_f_in_f_in_fractional_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_in_f_in_fractional_ff <= "0000000000000000"; -- 0x0
else
            csr_f_in_f_in_fractional_ff <= csr_f_in_f_in_fractional_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x4] - F_out - Output data stream format
--------------------------------------------------------------------------------


csr_f_out_ren <= ren when (raddr = "00000100") else '0'; -- 0x4
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_out_ren_ff <= '0'; -- 0x0
else
        csr_f_out_ren_ff <= csr_f_out_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- F_out(15 downto 0) - F_out_total - Output data stream format total bit width
-- access: ro, hardware: i
-----------------------

csr_f_out_rdata(15 downto 0) <= csr_f_out_f_out_total_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_out_f_out_total_ff <= "0000000000000000"; -- 0x0
else
            csr_f_out_f_out_total_ff <= csr_f_out_f_out_total_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- F_out(31 downto 16) - F_out_fractional - Output data stream format fractional bits
-- access: ro, hardware: i
-----------------------

csr_f_out_rdata(31 downto 16) <= csr_f_out_f_out_fractional_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_out_f_out_fractional_ff <= "0000000000000000"; -- 0x0
else
            csr_f_out_f_out_fractional_ff <= csr_f_out_f_out_fractional_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x8] - AP_Control - HLS block level control protocol signals
--------------------------------------------------------------------------------
csr_ap_control_rdata(31 downto 3) <= (others => '0');

csr_ap_control_wen <= wen when (waddr = "00001000") else '0'; -- 0x8

csr_ap_control_ren <= ren when (raddr = "00001000") else '0'; -- 0x8
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_ap_control_ren_ff <= '0'; -- 0x0
else
        csr_ap_control_ren_ff <= csr_ap_control_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- AP_Control(0) - ap_start - The start of HLS processor
-- access: rw, hardware: o
-----------------------

csr_ap_control_rdata(0) <= csr_ap_control_ap_start_ff;

csr_ap_control_ap_start_out <= csr_ap_control_ap_start_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_ap_control_ap_start_ff <= '0'; -- 0x0
else
        if (csr_ap_control_wen = '1') then
            if (wstrb(0) = '1') then
                csr_ap_control_ap_start_ff <= wdata(0);
            end if;
        else
            csr_ap_control_ap_start_ff <= csr_ap_control_ap_start_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- AP_Control(1) - ap_done - HLS ap_done
-- access: ro, hardware: i
-----------------------

csr_ap_control_rdata(1) <= csr_ap_control_ap_done_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_ap_control_ap_done_ff <= '0'; -- 0x0
else
            csr_ap_control_ap_done_ff <= csr_ap_control_ap_done_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- AP_Control(2) - ap_idle - HLS ap_idle
-- access: ro, hardware: i
-----------------------

csr_ap_control_rdata(2) <= csr_ap_control_ap_idle_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_ap_control_ap_idle_ff <= '0'; -- 0x0
else
            csr_ap_control_ap_idle_ff <= csr_ap_control_ap_idle_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xc] - WR_Cap_CTRL - QPSK Demodulator write buffer control registers
--------------------------------------------------------------------------------
csr_wr_cap_ctrl_rdata(31 downto 18) <= (others => '0');

csr_wr_cap_ctrl_wen <= wen when (waddr = "00001100") else '0'; -- 0xc

csr_wr_cap_ctrl_ren <= ren when (raddr = "00001100") else '0'; -- 0xc
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_wr_cap_ctrl_ren_ff <= '0'; -- 0x0
else
        csr_wr_cap_ctrl_ren_ff <= csr_wr_cap_ctrl_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- WR_Cap_CTRL(15 downto 0) - wr_addr - The write address pointer.  Value is the number of samples written to BRAM and can reset the pointer
-- access: rw, hardware: i
-----------------------

csr_wr_cap_ctrl_rdata(15 downto 0) <= csr_wr_cap_ctrl_wr_addr_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_wr_cap_ctrl_wr_addr_ff <= "0000000000000000"; -- 0x0
else
        if (csr_wr_cap_ctrl_wen = '1') then
            if (wstrb(0) = '1') then
                csr_wr_cap_ctrl_wr_addr_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_wr_cap_ctrl_wr_addr_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            csr_wr_cap_ctrl_wr_addr_ff <= csr_wr_cap_ctrl_wr_addr_in;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- WR_Cap_CTRL(16) - wr_enable - The write enable to capture output of the QPSK Demodulator
-- access: rw, hardware: o
-----------------------

csr_wr_cap_ctrl_rdata(16) <= csr_wr_cap_ctrl_wr_enable_ff;

csr_wr_cap_ctrl_wr_enable_out <= csr_wr_cap_ctrl_wr_enable_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_wr_cap_ctrl_wr_enable_ff <= '0'; -- 0x0
else
        if (csr_wr_cap_ctrl_wen = '1') then
            if (wstrb(2) = '1') then
                csr_wr_cap_ctrl_wr_enable_ff <= wdata(16);
            end if;
        else
            csr_wr_cap_ctrl_wr_enable_ff <= csr_wr_cap_ctrl_wr_enable_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- WR_Cap_CTRL(17) - wr_addr_clr - The write address pointer clear.  Strobed for 1 cc, self cleared
-- access: wosc, hardware: o
-----------------------

csr_wr_cap_ctrl_rdata(17) <= '0';

csr_wr_cap_ctrl_wr_addr_clr_out <= csr_wr_cap_ctrl_wr_addr_clr_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_wr_cap_ctrl_wr_addr_clr_ff <= '0'; -- 0x0
else
        if (csr_wr_cap_ctrl_wen = '1') then
            if (wstrb(2) = '1') then
                csr_wr_cap_ctrl_wr_addr_clr_ff <= wdata(17);
            end if;
        else
            csr_wr_cap_ctrl_wr_addr_clr_ff <= '0';
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x10] - RD_Cap_CTRL - QPSK Demodulator read buffer control registers
--------------------------------------------------------------------------------
csr_rd_cap_ctrl_rdata(31 downto 17) <= (others => '0');

csr_rd_cap_ctrl_wen <= wen when (waddr = "00010000") else '0'; -- 0x10

csr_rd_cap_ctrl_ren <= ren when (raddr = "00010000") else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_rd_cap_ctrl_ren_ff <= '0'; -- 0x0
else
        csr_rd_cap_ctrl_ren_ff <= csr_rd_cap_ctrl_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- RD_Cap_CTRL(15 downto 0) - rd_addr - The read address pointer.
-- access: rw, hardware: o
-----------------------

csr_rd_cap_ctrl_rdata(15 downto 0) <= csr_rd_cap_ctrl_rd_addr_ff;

csr_rd_cap_ctrl_rd_addr_out <= csr_rd_cap_ctrl_rd_addr_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_rd_cap_ctrl_rd_addr_ff <= "0000000000000000"; -- 0x0
else
        if (csr_rd_cap_ctrl_wen = '1') then
            if (wstrb(0) = '1') then
                csr_rd_cap_ctrl_rd_addr_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_rd_cap_ctrl_rd_addr_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
        else
            csr_rd_cap_ctrl_rd_addr_ff <= csr_rd_cap_ctrl_rd_addr_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- RD_Cap_CTRL(16) - rd_enable - The read enable. Strobed for 1cc, self cleared
-- access: wosc, hardware: o
-----------------------

csr_rd_cap_ctrl_rdata(16) <= '0';

csr_rd_cap_ctrl_rd_enable_out <= csr_rd_cap_ctrl_rd_enable_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_rd_cap_ctrl_rd_enable_ff <= '0'; -- 0x0
else
        if (csr_rd_cap_ctrl_wen = '1') then
            if (wstrb(2) = '1') then
                csr_rd_cap_ctrl_rd_enable_ff <= wdata(16);
            end if;
        else
            csr_rd_cap_ctrl_rd_enable_ff <= '0';
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x14] - RD_Cap_DATA - QPSK Demodulator read buffer data register
--------------------------------------------------------------------------------

csr_rd_cap_data_wen <= wen when (waddr = "00010100") else '0'; -- 0x14

csr_rd_cap_data_ren <= ren when (raddr = "00010100") else '0'; -- 0x14
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_rd_cap_data_ren_ff <= '0'; -- 0x0
else
        csr_rd_cap_data_ren_ff <= csr_rd_cap_data_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- RD_Cap_DATA(31 downto 0) - rd_data - The read data
-- access: rw, hardware: i
-----------------------

csr_rd_cap_data_rdata(31 downto 0) <= csr_rd_cap_data_rd_data_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_rd_cap_data_rd_data_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_rd_cap_data_wen = '1') then
            if (wstrb(0) = '1') then
                csr_rd_cap_data_rd_data_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_rd_cap_data_rd_data_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_rd_cap_data_rd_data_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_rd_cap_data_rd_data_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
            csr_rd_cap_data_rd_data_ff <= csr_rd_cap_data_rd_data_in;
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
            when "00000000" => rdata_ff <= csr_f_in_rdata; -- 0x0
            when "00000100" => rdata_ff <= csr_f_out_rdata; -- 0x4
            when "00001000" => rdata_ff <= csr_ap_control_rdata; -- 0x8
            when "00001100" => rdata_ff <= csr_wr_cap_ctrl_rdata; -- 0xc
            when "00010000" => rdata_ff <= csr_rd_cap_ctrl_rdata; -- 0x10
            when "00010100" => rdata_ff <= csr_rd_cap_data_rdata; -- 0x14
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