# HLS-QPSK-Demod	

The QPSK HLS was copied from: https://github.com/ttown523/QPSK-VivadoHLS

## Register Map

See [QPSK Register Document](./doc/qpsk_reg.md)

## Entity `qpsk_demod`

```vhdl
entity qpsk_demod is
port (
    ap_clk            : IN STD_LOGIC;
    ap_rst            : IN STD_LOGIC;
    ap_start          : IN STD_LOGIC;
    ap_done           : OUT STD_LOGIC;
    ap_idle           : OUT STD_LOGIC;
    ap_ready          : OUT STD_LOGIC;
    I_in              : IN STD_LOGIC_VECTOR (15 downto 0);
    I_in_ap_vld       : IN STD_LOGIC;
    Q_in              : IN STD_LOGIC_VECTOR (15 downto 0);
    Q_in_ap_vld       : IN STD_LOGIC;
    I_out             : OUT STD_LOGIC_VECTOR (15 downto 0);
    I_out_ap_vld      : OUT STD_LOGIC;
    Q_out             : OUT STD_LOGIC_VECTOR (15 downto 0);
    Q_out_ap_vld      : OUT STD_LOGIC;
    demod_bits        : OUT STD_LOGIC_VECTOR (1 downto 0);
    demod_bits_ap_vld : OUT STD_LOGIC;
    ap_return         : OUT STD_LOGIC_VECTOR (0 downto 0) );
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

//Phase locked loop constants
#define K1_PHASE 0.004975000621875
#define K2_PHASE 4.97500062187508e-05

//Timing sync loop constants
#define K1_TIMING -.002939400726737
#define K2_TIMING -1.17576029069497e-05

```

## Post-Synthesis Resource Usage

```bash
#=== Post-Synthesis Resource usage ===
SLICE:            0
LUT:          17206
FF:           10129
DSP:            194
BRAM:             0
URAM:             0
LATCH:            0
SRL:              0
CLB:              0

```



## Latency Measurements

HLS QPSK Demodulator IP core frequency @ 100MHz. Enabled the `#pragma HLS pipeline II=64`.  The pipeline can be lowered, but the core has issues meeting timing.

| Parameter   | Latency Clock Cycles                      | Max Sample Rate | Max Symbol Rate   |
| ----------- | ----------------------------------------- | --------------- | ----------------- |
| Demod Input | 64 (Sample input until `TREADY` asserted) | 1.5625MSPS      | 97.65625 KSym/sec |
|             |                                           |                 |                   |

