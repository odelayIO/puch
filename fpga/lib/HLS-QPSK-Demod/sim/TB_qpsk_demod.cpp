#include <iostream>
#include <stdio.h>
#include "../qpsk_demod.h"
#include "../qpsk.h"
#include <fstream>
#include <cstdlib>

/************************************************************************************************
 *																								                                              *
 * Testbench used for testing the correctness of the qpsk design in both hardware and software  *
 *																								                                              *
 ************************************************************************************************/

int main () {
  int Demod_Cnt = 0;
  Fin I_in, Q_in;
  Fout I_out, Q_out;
  ap_uint<2> Out_Bits;
  FILE *rx_samples = fopen("0xDEADBEEF_Rx_Samps.dat", "r");
  float Iin_float, Qin_float;
  std::ofstream outputFile("demodulatedMessage.dat", std::ios::trunc);


  while(fscanf(rx_samples, "%f %f", &Iin_float, &Qin_float) == 2) {
    I_in = (Fin)Iin_float;
    Q_in = (Fin)Qin_float;
    //std::cout << "I_in = " << I_in  << ", Q_in = " << Q_in << std::endl;
    // Demod QPSK wait when valid
		if (qpsk_demod(I_in, Q_in, &I_out, &Q_out)) { 
      Demod_Cnt += 1;
      (Out_Bits)[0] = (I_out > 0.0 ? 1 : 0);
      (Out_Bits)[1] = (Q_out > 0.0 ? 1 : 0);
      if((Demod_Cnt > 12) && (Demod_Cnt < 13+8*16) ) {
        //std::cout << "Demod_Cnt = " << Demod_Cnt << ", I_out = " << I_out << ", Q_out = " << Q_out << ", Out_Bits = " << Out_Bits << std::endl;
        //std::cout << "Demod_Cnt = " << Demod_Cnt << ", Out_Bits = " << Out_Bits << std::endl;
        outputFile << Out_Bits << std::endl;
      }
    }
  }
  fclose(rx_samples);
  outputFile.close();
  
  if(system("diff -w demodulatedMessage.dat 0xDEADBEEF_bit_out.dat")) {
    fprintf(stdout, "***********************************\n");
    fprintf(stdout, "       FIAL: File Missmatches\n");
    fprintf(stdout, "***********************************\n");
    return 1;
  }
  else {
    fprintf(stdout, "***********************************\n");
    fprintf(stdout, "       PASS: File Matches\n");
    fprintf(stdout, "***********************************\n");
    return 0;
  }
}
