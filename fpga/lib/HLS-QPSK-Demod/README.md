# HLS-QPSK-Demod	

The QPSK HLS was copied from: https://github.com/ttown523/QPSK-VivadoHLS

## Register Map

See [QPSK Register Document](./doc/qpsk_reg.md)

## Entity `qpsk_demod`

```vhdl
entity qpsk_demod is
  port (
    ap_clk             : IN STD_LOGIC;
    ap_rst             : IN STD_LOGIC;
    ap_start           : IN STD_LOGIC;
    ap_done            : OUT STD_LOGIC;
    ap_idle            : OUT STD_LOGIC;
    ap_ready           : OUT STD_LOGIC;
    I_in               : IN STD_LOGIC_VECTOR (15 downto 0);
    I_in_ap_vld        : IN STD_LOGIC;
    Q_in               : IN STD_LOGIC_VECTOR (15 downto 0);
    Q_in_ap_vld        : IN STD_LOGIC;
    I_out              : OUT STD_LOGIC_VECTOR (15 downto 0);
    I_out_ap_vld       : OUT STD_LOGIC;
    Q_out              : OUT STD_LOGIC_VECTOR (15 downto 0);
    Q_out_ap_vld       : OUT STD_LOGIC;
    demod_bits         : OUT STD_LOGIC_VECTOR (1 downto 0);
    demod_bits_ap_vld  : OUT STD_LOGIC;
    ap_return          : OUT STD_LOGIC_VECTOR (0 downto 0) 
  );
end;

```

## Port Formats

```c++
//----------------------------------------
//  Define AXI Stream Interface
//----------------------------------------
typedef ap_fixed<16,4, AP_RND, AP_SAT> Fin;
typedef ap_fixed<16,4, AP_RND, AP_SAT> Fout;

typedef ap_uint<3> DownsampleCounter;
typedef ap_int<2> Sign;


//----------------------------------------
//	Constants          
//----------------------------------------
//QPSK Variables
#define SAMPLES_PER_SYMBOL 16
#define FILTER_TAPS 193
#define TIMING_PHASE_SPS 8

```

## Post-Synthesis Resource Usage

```bash
#=== Post-Synthesis Resource usage ===
SLICE:            0
LUT:          21006
FF:            8307
DSP:            163
BRAM:             0
URAM:             0
LATCH:            0
SRL:              0
CLB:              0

```



## Latency Measurements

| pragma     | Latency Clock Cycles | Notes                                                        |
| ---------- | -------------------- | ------------------------------------------------------------ |
| qpsk_demod | 56                   | Enabled all the `pragma` .  This does increase the logic usage. |
| qpsk_demod | 123                  | Disabled all the `pragma`                                    |

