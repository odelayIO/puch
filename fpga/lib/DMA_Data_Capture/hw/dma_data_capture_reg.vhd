

-- Created with Corsair vgit-latest
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dma_data_capture_reg is
generic(
    ADDR_W : integer := 8;
    DATA_W : integer := 32;
    STRB_W : integer := 4
);
port(
    clk    : in std_logic;
    rst    : in std_logic;
    -- Max_Depth.len
    csr_max_depth_len_in : in std_logic_vector(31 downto 0);

    -- Capture_Length.len
    csr_capture_length_len_out : out std_logic_vector(31 downto 0);

    -- Capture_Stb.cap_stb
    csr_capture_stb_cap_stb_out : out std_logic;

    -- FIFO_Flush.flush
    csr_fifo_flush_flush_out : out std_logic;

    -- FIFO_WR_Ptr.wr_ptr
    csr_fifo_wr_ptr_wr_ptr_in : in std_logic_vector(31 downto 0);

    -- FIFO_RD_Ptr.rd_ptr
    csr_fifo_rd_ptr_rd_ptr_in : in std_logic_vector(31 downto 0);

    -- Enable_Debug_Cnt.en_debug_cnt
    csr_enable_debug_cnt_en_debug_cnt_out : out std_logic;

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

architecture rtl of dma_data_capture_reg is
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

signal csr_max_depth_rdata : std_logic_vector(31 downto 0);
signal csr_max_depth_ren : std_logic;
signal csr_max_depth_ren_ff : std_logic;
signal csr_max_depth_len_ff : std_logic_vector(31 downto 0);

signal csr_capture_length_rdata : std_logic_vector(31 downto 0);
signal csr_capture_length_wen : std_logic;
signal csr_capture_length_ren : std_logic;
signal csr_capture_length_ren_ff : std_logic;
signal csr_capture_length_len_ff : std_logic_vector(31 downto 0);

signal csr_capture_stb_rdata : std_logic_vector(31 downto 0);
signal csr_capture_stb_wen : std_logic;
signal csr_capture_stb_cap_stb_ff : std_logic;

signal csr_fifo_flush_rdata : std_logic_vector(31 downto 0);
signal csr_fifo_flush_wen : std_logic;
signal csr_fifo_flush_ren : std_logic;
signal csr_fifo_flush_ren_ff : std_logic;
signal csr_fifo_flush_flush_ff : std_logic;

signal csr_fifo_wr_ptr_rdata : std_logic_vector(31 downto 0);
signal csr_fifo_wr_ptr_ren : std_logic;
signal csr_fifo_wr_ptr_ren_ff : std_logic;
signal csr_fifo_wr_ptr_wr_ptr_ff : std_logic_vector(31 downto 0);

signal csr_fifo_rd_ptr_rdata : std_logic_vector(31 downto 0);
signal csr_fifo_rd_ptr_ren : std_logic;
signal csr_fifo_rd_ptr_ren_ff : std_logic;
signal csr_fifo_rd_ptr_rd_ptr_ff : std_logic_vector(31 downto 0);

signal csr_enable_debug_cnt_rdata : std_logic_vector(31 downto 0);
signal csr_enable_debug_cnt_wen : std_logic;
signal csr_enable_debug_cnt_ren : std_logic;
signal csr_enable_debug_cnt_ren_ff : std_logic;
signal csr_enable_debug_cnt_en_debug_cnt_ff : std_logic;

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
-- [0x0] - Max_Depth - The depth of the capture FIFO
--------------------------------------------------------------------------------


csr_max_depth_ren <= ren when (raddr = "00000000") else '0'; -- 0x0
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_max_depth_ren_ff <= '0'; -- 0x0
else
        csr_max_depth_ren_ff <= csr_max_depth_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Max_Depth(31 downto 0) - len - The depth of the capture FIFO
-- access: ro, hardware: i
-----------------------

csr_max_depth_rdata(31 downto 0) <= csr_max_depth_len_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_max_depth_len_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_max_depth_len_ff <= csr_max_depth_len_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x4] - Capture_Length - The number of samples to capture in buffer
--------------------------------------------------------------------------------

csr_capture_length_wen <= wen when (waddr = "00000100") else '0'; -- 0x4

csr_capture_length_ren <= ren when (raddr = "00000100") else '0'; -- 0x4
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_capture_length_ren_ff <= '0'; -- 0x0
else
        csr_capture_length_ren_ff <= csr_capture_length_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Capture_Length(31 downto 0) - len - The start of HLS processor
-- access: rw, hardware: o
-----------------------

csr_capture_length_rdata(31 downto 0) <= csr_capture_length_len_ff;

csr_capture_length_len_out <= csr_capture_length_len_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_capture_length_len_ff <= "00000000000000000000000000000000"; -- 0x0
else
        if (csr_capture_length_wen = '1') then
            if (wstrb(0) = '1') then
                csr_capture_length_len_ff(7 downto 0) <= wdata(7 downto 0);
            end if;
            if (wstrb(1) = '1') then
                csr_capture_length_len_ff(15 downto 8) <= wdata(15 downto 8);
            end if;
            if (wstrb(2) = '1') then
                csr_capture_length_len_ff(23 downto 16) <= wdata(23 downto 16);
            end if;
            if (wstrb(3) = '1') then
                csr_capture_length_len_ff(31 downto 24) <= wdata(31 downto 24);
            end if;
        else
            csr_capture_length_len_ff <= csr_capture_length_len_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x8] - Capture_Stb - Capture Strobe, self clearing 1cc strobe
--------------------------------------------------------------------------------
csr_capture_stb_rdata(31 downto 1) <= (others => '0');

csr_capture_stb_wen <= wen when (waddr = "00001000") else '0'; -- 0x8

-----------------------
-- Bit field:
-- Capture_Stb(0) - cap_stb - Capture Strobe, self clearing 1cc strobe
-- access: wosc, hardware: o
-----------------------

csr_capture_stb_rdata(0) <= '0';

csr_capture_stb_cap_stb_out <= csr_capture_stb_cap_stb_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_capture_stb_cap_stb_ff <= '0'; -- 0x0
else
        if (csr_capture_stb_wen = '1') then
            if (wstrb(0) = '1') then
                csr_capture_stb_cap_stb_ff <= wdata(0);
            end if;
        else
            csr_capture_stb_cap_stb_ff <= '0';
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0xc] - FIFO_Flush - Flush the FIFO for a new capture trigger
--------------------------------------------------------------------------------
csr_fifo_flush_rdata(31 downto 1) <= (others => '0');

csr_fifo_flush_wen <= wen when (waddr = "00001100") else '0'; -- 0xc

csr_fifo_flush_ren <= ren when (raddr = "00001100") else '0'; -- 0xc
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_fifo_flush_ren_ff <= '0'; -- 0x0
else
        csr_fifo_flush_ren_ff <= csr_fifo_flush_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- FIFO_Flush(0) - flush - Flush the FIFO for a new capture trigger
-- access: rw, hardware: o
-----------------------

csr_fifo_flush_rdata(0) <= csr_fifo_flush_flush_ff;

csr_fifo_flush_flush_out <= csr_fifo_flush_flush_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_fifo_flush_flush_ff <= '0'; -- 0x0
else
        if (csr_fifo_flush_wen = '1') then
            if (wstrb(0) = '1') then
                csr_fifo_flush_flush_ff <= wdata(0);
            end if;
        else
            csr_fifo_flush_flush_ff <= csr_fifo_flush_flush_ff;
        end if;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x10] - FIFO_WR_Ptr - FIFO Write Pointer
--------------------------------------------------------------------------------


csr_fifo_wr_ptr_ren <= ren when (raddr = "00010000") else '0'; -- 0x10
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_fifo_wr_ptr_ren_ff <= '0'; -- 0x0
else
        csr_fifo_wr_ptr_ren_ff <= csr_fifo_wr_ptr_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- FIFO_WR_Ptr(31 downto 0) - wr_ptr - FIFO Write Pointer
-- access: ro, hardware: i
-----------------------

csr_fifo_wr_ptr_rdata(31 downto 0) <= csr_fifo_wr_ptr_wr_ptr_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_fifo_wr_ptr_wr_ptr_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_fifo_wr_ptr_wr_ptr_ff <= csr_fifo_wr_ptr_wr_ptr_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x14] - FIFO_RD_Ptr - FIFO Read Pointer
--------------------------------------------------------------------------------


csr_fifo_rd_ptr_ren <= ren when (raddr = "00010100") else '0'; -- 0x14
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_fifo_rd_ptr_ren_ff <= '0'; -- 0x0
else
        csr_fifo_rd_ptr_ren_ff <= csr_fifo_rd_ptr_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- FIFO_RD_Ptr(31 downto 0) - rd_ptr - FIFO Read Pointer
-- access: ro, hardware: i
-----------------------

csr_fifo_rd_ptr_rdata(31 downto 0) <= csr_fifo_rd_ptr_rd_ptr_ff;


process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_fifo_rd_ptr_rd_ptr_ff <= "00000000000000000000000000000000"; -- 0x0
else
            csr_fifo_rd_ptr_rd_ptr_ff <= csr_fifo_rd_ptr_rd_ptr_in;
end if;
end if;
end process;



--------------------------------------------------------------------------------
-- CSR:
-- [0x18] - Enable_Debug_Cnt - Enable the debug counter on DMA data output port
--------------------------------------------------------------------------------
csr_enable_debug_cnt_rdata(31 downto 1) <= (others => '0');

csr_enable_debug_cnt_wen <= wen when (waddr = "00011000") else '0'; -- 0x18

csr_enable_debug_cnt_ren <= ren when (raddr = "00011000") else '0'; -- 0x18
process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_enable_debug_cnt_ren_ff <= '0'; -- 0x0
else
        csr_enable_debug_cnt_ren_ff <= csr_enable_debug_cnt_ren;
end if;
end if;
end process;

-----------------------
-- Bit field:
-- Enable_Debug_Cnt(0) - en_debug_cnt - Enable the debug counter on DMA data output port
-- access: rw, hardware: o
-----------------------

csr_enable_debug_cnt_rdata(0) <= csr_enable_debug_cnt_en_debug_cnt_ff;

csr_enable_debug_cnt_en_debug_cnt_out <= csr_enable_debug_cnt_en_debug_cnt_ff;

process (clk) begin
if rising_edge(clk) then
if (rst = '1') then
    csr_enable_debug_cnt_en_debug_cnt_ff <= '0'; -- 0x0
else
        if (csr_enable_debug_cnt_wen = '1') then
            if (wstrb(0) = '1') then
                csr_enable_debug_cnt_en_debug_cnt_ff <= wdata(0);
            end if;
        else
            csr_enable_debug_cnt_en_debug_cnt_ff <= csr_enable_debug_cnt_en_debug_cnt_ff;
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
            when "00000000" => rdata_ff <= csr_max_depth_rdata; -- 0x0
            when "00000100" => rdata_ff <= csr_capture_length_rdata; -- 0x4
            when "00001000" => rdata_ff <= csr_capture_stb_rdata; -- 0x8
            when "00001100" => rdata_ff <= csr_fifo_flush_rdata; -- 0xc
            when "00010000" => rdata_ff <= csr_fifo_wr_ptr_rdata; -- 0x10
            when "00010100" => rdata_ff <= csr_fifo_rd_ptr_rdata; -- 0x14
            when "00011000" => rdata_ff <= csr_enable_debug_cnt_rdata; -- 0x18
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