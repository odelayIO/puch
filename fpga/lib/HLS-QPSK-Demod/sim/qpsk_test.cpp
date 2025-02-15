#include <iostream>
#include <stdio.h>
#include "../qpskTop.h"
#include "../qpsk.h"
#include <fstream>
#include <cstdlib>

/************************************************************************************************
 *																								                                              *
 * Testbench used for testing the correctness of the qpsk design in both hardware and software  *
 *																								                                              *
 ************************************************************************************************/

int main () {

	//Open the file with the simulated modulation data
	std::ifstream input("modulatedData_short.dat", std::ios::in);
	//Create the result file
	std::ofstream outputFile("demodulatedMessage.dat", std::ios::trunc); // out.golden.dat

	if (!input.is_open()){ //make sure file is valid
		std::cout << "Error Opening File!" << std::endl;
	}

  // Create input/output HLS Streams
	double nextSample = 0.0;
  hls::stream<pkt32> A_in;
  hls::stream<pkt2> B_out;
  pkt32 A_tmp;
  pkt2 B_tmp;

  // Debug Signal
	int fillFilter = 0;
	int Sample_Cnt = 0;
	int Demod_Cnt = 0;
	Symbol recievedSymbol;

	//Pass each sample from the input file into the demodulator
	std::cout << "Demodulating input signal..." << std::endl;
	while (input >> nextSample){
    Sample_Cnt += 1;

    // Write sample from file to AXI Stream input port
    A_tmp.data = nextSample;
    A_in.write(A_tmp);

    // Demod QPSK wait when valid
		if (qpskElementDemodulatorTimingPhase(A_in, B_out)) { 
      // Read data from AXI Stream output port
      B_out.read(B_tmp);
      recievedSymbol = B_tmp.data;

      // Debug Print Statement
      Demod_Cnt += 1;
      std::cout << "Output = " << recievedSymbol << ", Demod_Cnt = " << Demod_Cnt << ", Sample_Cnt = " << Sample_Cnt << std::endl;

      // Ignore the first few samples that we obtain, since we are waiting for the filter taps to fill up
			if (fillFilter > 11){ 
				outputFile << recievedSymbol << std::endl;
			}
			else{
				fillFilter += 1;
			}
		}
	}

	//For some reason, we don't get the last symbol of the message in the previous loop.
	//So, we include this code so the last symbol is included and the file differencing will work
  //A_tmp.data = 0;
  //A_in.write(A_tmp);
	while (true){
		if (qpskElementDemodulatorTimingPhase(A_in, B_out)) {
			//Convert the symbol to a number from 0-3
			//recv = (recievedSymbol[0] << 1) | recievedSymbol[1];
      B_out.read(B_tmp);
      recievedSymbol = B_tmp.data;
			outputFile << recievedSymbol << std::endl;
      std::cout << "Read the last demod symbol: " << recievedSymbol << std::endl;

			break;
		}
	}

	input.close();
	outputFile.close();

	//Compare the generated message file with the golden file...FC is only valid in windows
	if (system("diff -w demodulatedMessage.dat golden_short.dat")){

		fprintf(stdout, "*******************************************\n");
		fprintf(stdout, "FAIL: Output DOES NOT match the golden output\n");
		fprintf(stdout, "*******************************************\n");

		return 1; //test failed
	}
	else {
		fprintf(stdout, "*******************************************\n");
		fprintf(stdout, "PASS: The output matches the golden output!\n");
		fprintf(stdout, "*******************************************\n");

		return 0; //test passed

	}
}
