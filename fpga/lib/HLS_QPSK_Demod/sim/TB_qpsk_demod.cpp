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

//-----------------------------------------------------
// Number of Symbols to verify from Gold Vectors File
//-----------------------------------------------------
const int C_DEMOD_SYM_LEN = 32;


/************************************************************************************************
 *																								                                              *
 * Testbench used for testing the correctness of the qpsk design in both hardware and software  *
 *																								                                              *
 ************************************************************************************************/

int main () {
  int Demod_Cnt = 0;
  int Sym_Error_Cnt = 0;
  int Sym_Good_Cnt = 0;
  int GOLD_Out_Sym = 0;
  FILE *GOLD_Out_Bits = fopen("0xDEADBEEF_bit_out.dat", "r");

  Fin I_in, Q_in;
  Fout I_out, Q_out;
  ap_uint<2> Out_Bits;

  FILE *rx_samples = fopen("0xDEADBEEF_Rx_Samps.dat", "r");
  float Iin_float, Qin_float;

  std::ofstream out_constellation("out_constellation.csv", std::ios::trunc);


  while(fscanf(rx_samples, "%f %f", &Iin_float, &Qin_float) == 2) {
    I_in = (Fin)Iin_float;
    Q_in = (Fin)Qin_float;
    // Demod QPSK wait when valid
		if (qpsk_demod(I_in, Q_in, &I_out, &Q_out, &Out_Bits)) { 
      Demod_Cnt += 1;
      // Allow symbol to pass through filter
      if((Demod_Cnt > 12) && (Demod_Cnt < 13+(C_DEMOD_SYM_LEN)) ) {
        // Read GOLD Vector Output
        fscanf(GOLD_Out_Bits, "%d", &GOLD_Out_Sym);
        std::cout << "Demod_Cnt = " << Demod_Cnt << ", Out_Bits = " << Out_Bits << ", GOLD_Out_Sym = " << GOLD_Out_Sym << std::endl;
        out_constellation << I_out << ", " << Q_out << std::endl;
        // Determine Symbol Error
        if(Out_Bits == GOLD_Out_Sym) {
          ++Sym_Good_Cnt;
        } else {
          ++Sym_Error_Cnt;
        }
      }
    }
  }
  fclose(rx_samples);
  fclose(GOLD_Out_Bits);
  out_constellation.close();
  std::cout << "Good Symbols = " << Sym_Good_Cnt << ", Symbol Errors = " << Sym_Error_Cnt << std::endl;
 
  if(Sym_Error_Cnt == 0) {
    fprintf(stdout, "***********************************\n");
    fprintf(stdout, "             PASSED!\n");
    fprintf(stdout, "***********************************\n");
    return 0;
  }
  else {
    fprintf(stdout, "***********************************\n");
    fprintf(stdout, "          *** FAILED ***\n");
    fprintf(stdout, "***********************************\n");
    return 1;
  }
}
