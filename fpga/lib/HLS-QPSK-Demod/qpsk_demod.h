#ifndef QPSKTOP_H
#define QPSKTOP_H

#include "qpsk.h"

bool qpsk_demod(Fin I_in, Fin Q_in, Fout *I_out, Fout *Q_out, ap_uint<2> *demod_bits);


#endif
