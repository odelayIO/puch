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

