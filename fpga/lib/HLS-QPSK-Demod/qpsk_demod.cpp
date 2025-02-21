#include "qpsk_demod.h"
#include "ap_fixed.h"
#include "ap_int.h"
#include "ap_axi_sdata.h"
#include "hls_stream.h"


bool qpsk_demod(Fin I_in, Fin Q_in, Fout *I_out, Fout *Q_out){
//#pragma HLS INTERFACE s_axilite port=return bundle=control
//#pragma HLS inline recursive
//#pragma HLS latency max=16
//#pragma HLS pipeline II=16

  static DownsampleCounter downsampleCount = 0; // 3-bit counter

  double ICorrected = 0, QCorrected = 0;
  bool strobe = false; 

  // Convert Fixed-Point to Double
  double Ifir = I_in;
  double Qfir = Q_in;

  if (downsampleCount == 0){
    timingPhaseCorrection(Ifir, Qfir, &ICorrected, &QCorrected, &strobe);

    //decision block -- perhaps I should make this its own function...so the reader can know what its doing
    if (strobe){
      //std::cout << ICorrected <<  " " << QCorrected << std::endl;
      //Fout I_tmp = ICorrected;
      //Fout Q_tmp = QCorrected;
      //I_out = I_tmp;
      //Q_out = Q_tmp;
      //I_out = 0;
      //Q_out = 0;
      //I_out = (ICorrected > 0.0 ? 1 : 0);
      //Q_out = (QCorrected > 0.0 ? 1 : 0);
      //*I_out = I_in;
      //*Q_out = Q_in;
      *I_out = (Fout) ICorrected;
      *Q_out = (Fout) QCorrected;

      //(out)[1] = (ICorrected > 0.0 ? 1 : 0);
    }
    downsampleCount++;

    return strobe;
  }
  else{
    downsampleCount++;
    return false;
  }
}
