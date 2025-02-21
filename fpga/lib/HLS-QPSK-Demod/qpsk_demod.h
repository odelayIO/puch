#ifndef QPSKTOP_H
#define QPSKTOP_H

#include "qpsk.h"

//bool qpskElementDemodulatorTimingPhase(double sampleIn, Symbol *out);
//bool qpskElementDemodulatorTimingPhase(din_t fp_din, Symbol *out);
//bool qpskElementDemodulatorTimingPhase(hls::stream<pkt32> &A, Symbol *out);
bool qpskElementDemodulatorTimingPhase(hls::stream<pkt32> &A, hls::stream<pkt2> &B);

#endif
//
