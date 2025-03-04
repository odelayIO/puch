#include "qpsk_demod.h"
#include "ap_fixed.h"
#include "ap_int.h"
#include "ap_axi_sdata.h"
#include "hls_stream.h"


bool qpsk_demod(Fin I_in, Fin Q_in, Fout *I_out, Fout *Q_out, ap_uint<2> *demod_bits){
#pragma HLS INTERFACE mode=ap_vld port=I_in
#pragma HLS INTERFACE mode=ap_vld port=Q_in
#pragma HLS inline recursive
#pragma HLS latency max=16
#pragma HLS pipeline II=16
// Uncomment to wrap the control protocols to AXI Lite bus
//#pragma HLS INTERFACE s_axilite port=return bundle=control

  static DownsampleCounter downsampleCount = 0; // 3-bit counter

  double ICorrected = 0, QCorrected = 0;
  bool strobe = false; 

  // Convert Fixed-Point to Double
  double Ifir = I_in;
  double Qfir = Q_in;

  if (downsampleCount == 0){
    timingPhaseCorrection(Ifir, Qfir, &ICorrected, &QCorrected, &strobe);

    if (strobe){
      *I_out = (Fout) ICorrected;
      *Q_out = (Fout) QCorrected;
      (*demod_bits)[0] = (ICorrected > 0.0 ? 1 : 0);
      (*demod_bits)[1] = (QCorrected > 0.0 ? 1 : 0);

    }
    downsampleCount++;

    return strobe;
  }
  else{
    downsampleCount++;
    return false;
  }
}
