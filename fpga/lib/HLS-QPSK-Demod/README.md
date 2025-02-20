# HLS-QPSK-Demod	

The QPSK HLS was copied from: https://github.com/ttown523/QPSK-VivadoHLS

I have updated the ports to be AXI Stream interface, and have the `ap` control ports to the AXI Lite interface.

## Port Formats

```c++
//----------------------------------------
//  Define AXI Stream Interface
//----------------------------------------
typedef hls::axis<ap_fixed<32,4>,0,0,0> pkt32;
typedef hls::axis<ap_uint<2>,0,0,0> pkt2;

typedef ap_uint<2> Symbol;
typedef ap_uint<2> TwoBitCounter;
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



## Latency Measurements

| pragma                                                       | Latency Min | Latency Max |
| ------------------------------------------------------------ | ----------- | ----------- |
| None                                                         | 1575        | 1695        |
| #pragma HLS latency max=160                                  | 1575        | 1696        |
| #pragma HLS latency max=160<br />#pragma HLS unroll          | 980         | 1102        |
| #pragma HLS latency max=160<br />#pragma HLS unroll<br />#pragma HLS latency max=1 | 981         | 1086        |
| #pragma HLS latency max=160<br />#pragma HLS unroll<br />#pragma HLS latency max=1<br />#pragma HLS pipeline II=16 | 981         | 1086        |

