

-- Created with Corsair vgit-latest
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity awgn_reg is
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

    -- F_awgn.F_awgn_total
    csr_f_awgn_f_awgn_total_in : in std_logic_vector(15 downto 0);
    -- F_awgn.F_awgn_fractional
    csr_f_awgn_f_awgn_fractional_in : in std_logic_vector(15 downto 0);

    -- awgn_noise_gain.awgn_noise_gain
    csr_awgn_noise_gain_awgn_noise_gain_out : out std_logic_vector(15 downto 0);

    -- awgn_enable.awgn_enable
    csr_awgn_enable_awgn_enable_out : out std_logic;
    -- awgn_enable.sat_I_ch
    csr_awgn_enable_sat_i_ch_en : in std_logic;
    csr_awgn_enable_sat_i_ch_in : in std_logic;
    -- awgn_enable.sat_Q_ch
    csr_awgn_enable_sat_q_ch_en : in std_logic;
    csr_awgn_enable_sat_q_ch_in : in std_logic;

    -- tvalid_cnt.tvalid_cnt
    csr_tvalid_cnt_tvalid_cnt_in : in std_logic_vector(31 downto 0);

    -- tlast_cnt.tlast_cnt
    csr_tlast_cnt_tlast_cnt_in : in std_logic_vector(31 downto 0);

    -- cnt_ctrl.clear_cnt
    csr_cnt_ctrl_clear_cnt_out : out std_logic;
    -- cnt_ctrl.capture_cnt
    csr_cnt_ctrl_capture_cnt_out : out std_logic;

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

architecture rtl of awgn_reg is
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

signal csr_f_awgn_rdata : std_logic_vector(31 downto 0);
signal csr_f_awgn_ren : std_logic;
signal csr_f_awgn_ren_ff : std_logic;
signal csr_f_awgn_f_awgn_total_ff : std_logic_vector(15 downto 0);
signal csr_f_awgn_f_awgn_fractional_ff : std_logic_vector(15 downto 0);

signal csr_awgn_noise_gain_rdata : std_logic_vector(31 downto 0);
signal csr_awgn_noise_gain_wen : std_logic;
signal csr_awgn_noise_gain_ren : std_logic;
signal csr_awgn_noise_gain_ren_ff : std_logic;
signal csr_awgn_noise_gain_awgn_noise_gain_ff : std_logic_vector(15 downto 0);

signal csr_awgn_enable_rdata : std_logic_vector(31 downto 0);
signal csr_awgn_enable_wen : std_logic;
signal csr_awgn_enable_ren : std_logic;
signal csr_awgn_enable_ren_ff : std_logic;
signal csr_awgn_enable_awgn_enable_ff : std_logic;
signal csr_awgn_enable_sat_i_ch_ff : std_logic;
signal csr_awgn_enable_sat_q_ch_ff : std_logic;

signal csr_tvalid_cnt_rdata : std_logic_vector(31 downto 0);
signal csr_tvalid_cnt_ren : std_logic;
signal csr_tvalid_cnt_ren_ff : std_logic;
signal csr_tvalid_cnt_tvalid_cnt_ff : std_logic_vector(31 downto 0);

signal csr_tlast_cnt_rdata : std_logic_vector(31 downto 0);
signal csr_tlast_cnt_ren : std_logic;
signal csr_tlast_cnt_ren_ff : std_logic;
signal csr_tlast_cnt_tlast_cnt_ff : std_logic_vector(31 downto 0);

signal csr_cnt_ctrl_rdata : std_logic_vector(31 downto 0);
signal csr_cnt_ctrl_wen : std_logic;
signal csr_cnt_ctrl_clear_cnt_ff : std_logic;
signal csr_cnt_ctrl_capture_cnt_ff : std_logic;

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
-- [0x8] - F_awgn - Output AWGN data stream format
--------------------------------------------------------------------------------


csr_f_awgn_ren <= ren when (raddr = "00001000") else '0'; -- 0x8
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_awgn_ren_ff <= '0'; -- 0x0
else
        csr_f_awgn_ren_ff <= csr_f_awgn_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- F_awgn(15 downto 0) - F_awgn_total - Output AWGN data stream format total bit width
-- access: ro, hardware: i
-----------------------

csr_f_awgn_rdata(15 downto 0) <= csr_f_awgn_f_awgn_total_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_awgn_f_awgn_total_ff <= "0000000000000000"; -- 0x0
else
            csr_f_awgn_f_awgn_total_ff <= csr_f_awgn_f_awgn_total_in;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- F_awgn(31 downto 16) - F_awgn_fractional - Output AWGN data stream format fractional bits
-- access: ro, hardware: i
-----------------------

csr_f_awgn_rdata(31 downto 16) <= csr_f_awgn_f_awgn_fractional_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_f_awgn_f_awgn_fractional_ff <= "0000000000000000"; -- 0x0
else
            csr_f_awgn_f_awgn_fractional_ff <= csr_f_awgn_f_awgn_fractional_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xc] - awgn_noise_gain - AWGN Noise Gain
--------------------------------------------------------------------------------
csr_awgn_noise_gain_rdata(31 downto 16) <= (others => '0');

csr_awgn_noise_gain_wen <= wen when (waddr = "00001100") else '0'; -- 0xc

csr_awgn_noise_gain_ren <= ren when (raddr = "00001100") else '0'; -- 0xc
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_awgn_noise_gain_ren_ff <= '0'; -- 0x0
else
        csr_awgn_noise_gain_ren_ff <= csr_awgn_noise_gain_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- awgn_noise_gain(15 downto 0) - awgn_noise_gain - AWGN Noise Gain, same format as AWGN
-- access: rw, hardware: o
-----------------------

csr_awgn_noise_gain_rdata(15 downto 0) <= csr_awgn_noise_gain_awgn_noise_gain_ff;

csr_awgn_noise_gain_awgn_noise_gain_out <= csr_awgn_noise_gain_awgn_noise_gain_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_awgn_noise_gain_awgn_noise_gain_ff <= "0000000000000000"; -- 0x0
else
        if (csr_awgn_noise_gain_wen = '1') then
            if (wstrb(0) = '1') then
                csr_awgn_noise_gain_awgn_noise_gain_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_awgn_noise_gain_awgn_noise_gain_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
        else
            csr_awgn_noise_gain_awgn_noise_gain_ff <= csr_awgn_noise_gain_awgn_noise_gain_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x10] - awgn_enable - AWGN Noise Enable
--------------------------------------------------------------------------------
csr_awgn_enable_rdata(31 downto 3) <= (others => '0');

csr_awgn_enable_wen <= wen when (waddr = "00010000") else '0'; -- 0x10

csr_awgn_enable_ren <= ren when (raddr = "00010000") else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_awgn_enable_ren_ff <= '0'; -- 0x0
else
        csr_awgn_enable_ren_ff <= csr_awgn_enable_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- awgn_enable(0) - awgn_enable - AWGN Noise Enable Control, '1' - Enabled, '0' - Bypassed (Default '0')
-- access: rw, hardware: o
-----------------------

csr_awgn_enable_rdata(0) <= csr_awgn_enable_awgn_enable_ff;

csr_awgn_enable_awgn_enable_out <= csr_awgn_enable_awgn_enable_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_awgn_enable_awgn_enable_ff <= '0'; -- 0x0
else
        if (csr_awgn_enable_wen = '1') then
            if (wstrb(0) = '1') then
                csr_awgn_enable_awgn_enable_ff <= wdata(0);
            end if;
        else
            csr_awgn_enable_awgn_enable_ff <= csr_awgn_enable_awgn_enable_ff;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- awgn_enable(1) - sat_I_ch - A '1' means I-Channel was Saturated since last read.  Read clear bit field
-- access: roc, hardware: ie
-----------------------

csr_awgn_enable_rdata(1) <= csr_awgn_enable_sat_i_ch_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_awgn_enable_sat_i_ch_ff <= '0'; -- 0x0
else
        if (csr_awgn_enable_ren = '1') then
            csr_awgn_enable_sat_i_ch_ff <= '0';
        elsif (csr_awgn_enable_sat_i_ch_en = '1') then
            csr_awgn_enable_sat_i_ch_ff <= csr_awgn_enable_sat_i_ch_in;
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- awgn_enable(2) - sat_Q_ch - A '1' means Q-Channel was Saturated since last read.  Read clear bit field
-- access: roc, hardware: ie
-----------------------

csr_awgn_enable_rdata(2) <= csr_awgn_enable_sat_q_ch_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_awgn_enable_sat_q_ch_ff <= '0'; -- 0x0
else
        if (csr_awgn_enable_ren = '1') then
            csr_awgn_enable_sat_q_ch_ff <= '0';
        elsif (csr_awgn_enable_sat_q_ch_en = '1') then
            csr_awgn_enable_sat_q_ch_ff <= csr_awgn_enable_sat_q_ch_in;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x14] - tvalid_cnt - Counter for TValid
--------------------------------------------------------------------------------


csr_tvalid_cnt_ren <= ren when (raddr = "00010100") else '0'; -- 0x14
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_tvalid_cnt_ren_ff <= '0'; -- 0x0
else
        csr_tvalid_cnt_ren_ff <= csr_tvalid_cnt_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- tvalid_cnt(31 downto 0) - tvalid_cnt - Counter of tvalids
-- access: ro, hardware: i
-----------------------

csr_tvalid_cnt_rdata(31 downto 0) <= csr_tvalid_cnt_tvalid_cnt_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_tvalid_cnt_tvalid_cnt_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_tvalid_cnt_tvalid_cnt_ff <= csr_tvalid_cnt_tvalid_cnt_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x18] - tlast_cnt - Counter for TLast
--------------------------------------------------------------------------------


csr_tlast_cnt_ren <= ren when (raddr = "00011000") else '0'; -- 0x18
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_tlast_cnt_ren_ff <= '0'; -- 0x0
else
        csr_tlast_cnt_ren_ff <= csr_tlast_cnt_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- tlast_cnt(31 downto 0) - tlast_cnt - Counter of tlast
-- access: ro, hardware: i
-----------------------

csr_tlast_cnt_rdata(31 downto 0) <= csr_tlast_cnt_tlast_cnt_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_tlast_cnt_tlast_cnt_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_tlast_cnt_tlast_cnt_ff <= csr_tlast_cnt_tlast_cnt_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x1c] - cnt_ctrl - Control Signals for the Strobe Counters
--------------------------------------------------------------------------------
csr_cnt_ctrl_rdata(31 downto 2) <= (others => '0');

csr_cnt_ctrl_wen <= wen when (waddr = "00011100") else '0'; -- 0x1c

-----------------------
-- Bit field:
-- cnt_ctrl(0) - clear_cnt - A '1' clears all counters
-- access: wosc, hardware: o
-----------------------

csr_cnt_ctrl_rdata(0) <= '0';

csr_cnt_ctrl_clear_cnt_out <= csr_cnt_ctrl_clear_cnt_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_cnt_ctrl_clear_cnt_ff <= '0'; -- 0x0
else
        if (csr_cnt_ctrl_wen = '1') then
            if (wstrb(0) = '1') then
                csr_cnt_ctrl_clear_cnt_ff <= wdata(0);
            end if;
        else
            csr_cnt_ctrl_clear_cnt_ff <= '0';
        end if;
end if;
end if;
end process;



-----------------------
-- Bit field:
-- cnt_ctrl(1) - capture_cnt - A '1' captures all counter
-- access: wosc, hardware: o
-----------------------

csr_cnt_ctrl_rdata(1) <= '0';

csr_cnt_ctrl_capture_cnt_out <= csr_cnt_ctrl_capture_cnt_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_cnt_ctrl_capture_cnt_ff <= '0'; -- 0x0
else
        if (csr_cnt_ctrl_wen = '1') then
            if (wstrb(0) = '1') then
                csr_cnt_ctrl_capture_cnt_ff <= wdata(1);
            end if;
        else
            csr_cnt_ctrl_capture_cnt_ff <= '0';
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
            when "00001000" => rdata_ff <= csr_f_awgn_rdata; -- 0x8
            when "00001100" => rdata_ff <= csr_awgn_noise_gain_rdata; -- 0xc
            when "00010000" => rdata_ff <= csr_awgn_enable_rdata; -- 0x10
            when "00010100" => rdata_ff <= csr_tvalid_cnt_rdata; -- 0x14
            when "00011000" => rdata_ff <= csr_tlast_cnt_rdata; -- 0x18
            when "00011100" => rdata_ff <= csr_cnt_ctrl_rdata; -- 0x1c
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