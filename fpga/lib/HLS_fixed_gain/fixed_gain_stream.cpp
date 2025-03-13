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
//#   Description : Xilinx Vitis HLS Fixed Gain Block for AXI Stream Interface
//#
//#   Version History:
//#   
//#       Date        Description
//#     -----------   -----------------------------------------------------------------------
//#      2023-04-18    Original Creation
//#
//###########################################################################################
#include "ap_axi_sdata.h"
#include "hls_stream.h"
#define DWIDTH 32
#define type ap_int<DWIDTH>

typedef hls::axis<type, 0, 0, 0> pkt;

void fixed_gain_stream(hls::stream<pkt> &A, hls::stream<pkt> &B, int *gain)
{
#pragma HLS INTERFACE axis port=A
#pragma HLS INTERFACE axis port=B
#pragma HLS INTERFACE s_axilite register port=gain bundle=CSR_BUS 
#pragma HLS INTERFACE s_axilite port=return bundle=CSR_BUS
//#pragma HLS pipeline II=1

  static int dout = 0;

  dout = *gain;

  pkt tmp;
  pkt t1;
  A.read(tmp);
  t1.data = tmp.data * dout;
  t1.keep = tmp.keep;
  t1.strb = tmp.strb;
  t1.last = tmp.last;
  B.write(t1);
  *gain = dout;
}
