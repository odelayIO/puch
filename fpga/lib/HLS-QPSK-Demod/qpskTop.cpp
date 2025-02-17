#include "qpskTop.h"
#include "ap_fixed.h"
#include "ap_int.h"
#include "ap_axi_sdata.h"
#include "hls_stream.h"


bool qpskElementDemodulatorTimingPhase(hls::stream<pkt32> &A, hls::stream<pkt2> &B){
#pragma HLS INTERFACE axis port=A
#pragma HLS INTERFACE axis port=B
#pragma HLS INTERFACE s_axilite port=return bundle=control

  // Define output port
  Symbol out;
  pkt2 dout_t;

  // Define Input Stream and read
  pkt32 din_t;
  A.read(din_t);

  static DownsampleCounter downsampleCount = 0; // 3-bit counter
  static TwoBitCounter carrierIndex = 0; // 2-bit counter

  double Irec = 0.0, Qrec = 0.0, Ifir = 0.0, Qfir = 0.0;
  double ICorrected = 0, QCorrected = 0;
  bool strobe = false; //
  double sampleIn = din_t.data; //Convert Fixed Point to Double

  // Signal is Fs/2, demodulating to baseband
  Irec = sampleIn*Icarrier[carrierIndex];
  Qrec = sampleIn*Qcarrier[carrierIndex];

  //update carrier index
  carrierIndex++; //This two bit counter will wrap and keep counting so no need for checks

  //compute the next filter sample...need two filters, because they each use static delay values within the function
  simple_fir_filterI(&Ifir, Irec);
  simple_fir_filterQ(&Qfir, Qrec);

  if (downsampleCount == 0){
    timingPhaseCorrection(Ifir, Qfir, &ICorrected, &QCorrected, &strobe);

    //decision block -- perhaps I should make this its own function...so the reader can know what its doing
    if (strobe){
      //std::cout << ICorrected <<  " " << QCorrected << std::endl;
      (out)[1] = (ICorrected > 0.0 ? 1 : 0);
      (out)[0] = (QCorrected > 0.0 ? 1 : 0);
      // Drive AXI Bus.  Just going to assert last every strobe
      dout_t.data = out;
      dout_t.strb = strobe;
      dout_t.last = strobe;
      dout_t.keep = 0xF;
      B.write(dout_t);
    }
    downsampleCount++;

    return strobe;
  }
  else{
    downsampleCount++;
    return false;
  }
}
