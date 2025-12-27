
# Entity: Timestamp 
- **File**: Timestamp.vhd

## Diagram
![Diagram](Timestamp.svg "Diagram")
## Generics

| Generic name | Type    | Value | Description |
| ------------ | ------- | ----- | ----------- |
| ADDR_W       | integer | 8     |             |
| DATA_W       | integer | 32    |             |
| STRB_W       | integer | 4     |             |

## Ports

| Port name    | Direction | Type                                | Description |
| ------------ | --------- | ----------------------------------- | ----------- |
| clk          | in        | std_logic                           |             |
| rst          | in        | std_logic                           |             |
| axil_awaddr  | in        | std_logic_vector(ADDR_W-1 downto 0) |             |
| axil_awprot  | in        | std_logic_vector(2 downto 0)        |             |
| axil_awvalid | in        | std_logic                           |             |
| axil_awready | out       | std_logic                           |             |
| axil_wdata   | in        | std_logic_vector(DATA_W-1 downto 0) |             |
| axil_wstrb   | in        | std_logic_vector(STRB_W-1 downto 0) |             |
| axil_wvalid  | in        | std_logic                           |             |
| axil_wready  | out       | std_logic                           |             |
| axil_bresp   | out       | std_logic_vector(1 downto 0)        |             |
| axil_bvalid  | out       | std_logic                           |             |
| axil_bready  | in        | std_logic                           |             |
| axil_araddr  | in        | std_logic_vector(ADDR_W-1 downto 0) |             |
| axil_arprot  | in        | std_logic_vector(2 downto 0)        |             |
| axil_arvalid | in        | std_logic                           |             |
| axil_arready | out       | std_logic                           |             |
| axil_rdata   | out       | std_logic_vector(DATA_W-1 downto 0) |             |
| axil_rresp   | out       | std_logic_vector(1 downto 0)        |             |
| axil_rvalid  | out       | std_logic                           |             |
| axil_rready  | in        | std_logic                           |             |

## Instantiations

- U_TIMESTAMP_REG: work.timestamp_reg
