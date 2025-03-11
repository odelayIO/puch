//#############################################################################################
//#############################################################################################
//#
//#   The MIT License (MIT)
//#   
//#   Copyright (c) 2023 http://odelay.io 
//#   
//#   Permission is hereby granted, free of charge, to any person obtaining a copy
//#   of this software and associated documentation files (the "Software"), to deal
//#   in the Software without restriction, including without limitation the rights
//#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//#   copies of the Software, and to permit persons to whom the Software is
//#   furnished to do so, subject to the following conditions:
//#   
//#   The above copyright notice and this permission notice shall be included in all
//#   copies or substantial portions of the Software.
//#   
//#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//#   SOFTWARE.
//#   
//#   Contact : <everett@odelay.io>
//#  
//#   Description : QPSK Demodulator
//#
//#   Version History:
//#   
//#       Date        Description
//#     -----------   -----------------------------------------------------------------------
//#      2025-02-22    Original Creation
//#
//###########################################################################################
//###########################################################################################





#include <iostream>
#include <stdio.h>
#include "../src/qpsk_demod.h"
#include "../src/qpsk.h"
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
  std::ofstream out_constellation("out_constellation.csv", std::ios::trunc);


  while(fscanf(rx_samples, "%f %f", &Iin_float, &Qin_float) == 2) {
    I_in = (Fin)Iin_float;
    Q_in = (Fin)Qin_float;
    //std::cout << "I_in = " << I_in  << ", Q_in = " << Q_in << std::endl;
    // Demod QPSK wait when valid
		if (qpsk_demod(I_in, Q_in, &I_out, &Q_out, &Out_Bits)) { 
      Demod_Cnt += 1;
      //(Out_Bits)[0] = (I_out > 0.0 ? 1 : 0);
      //(Out_Bits)[1] = (Q_out > 0.0 ? 1 : 0);
      // TODO: Need to update Number_Sym based on gen_test_vectors.py, currently:  13 + (Syncword+Number_Sym)*SampPerSym
      //if((Demod_Cnt > 12) && (Demod_Cnt < 13+33*16) ) {
      if((Demod_Cnt > 12) && (Demod_Cnt < 13+1025*16) ) {
        //std::cout << "Demod_Cnt = " << Demod_Cnt << ", I_out = " << I_out << ", Q_out = " << Q_out << ", Out_Bits = " << Out_Bits << std::endl;
        std::cout << "Demod_Cnt = " << Demod_Cnt << ", Out_Bits = " << Out_Bits << std::endl;
        outputFile << Out_Bits << std::endl;
        out_constellation << I_out << ", " << Q_out << std::endl;
      }
    }
  }
  fclose(rx_samples);
  outputFile.close();
  out_constellation.close();
  
  if(system("diff -w demodulatedMessage.dat 0xDEADBEEF_bit_out.dat")) {
    fprintf(stdout, "***********************************\n");
    fprintf(stdout, "       FIAL: File Missmatches\n");
    fprintf(stdout, "***********************************\n");
    return 0;
  }
  else {
    fprintf(stdout, "***********************************\n");
    fprintf(stdout, "       PASS: File Matches\n");
    fprintf(stdout, "***********************************\n");
    return 0;
  }
}
