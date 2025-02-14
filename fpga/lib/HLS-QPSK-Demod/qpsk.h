#ifndef QPSK_H
#define QPSK_H

#include "ap_int.h"
#include "ap_fixed.h"

typedef ap_uint<2> Symbol;
typedef ap_uint<2> TwoBitCounter;
typedef ap_uint<3> DownsampleCounter;
typedef ap_int<2> Sign;//
typedef ap_fixed<32,28> din_t;

/***************************
*		Constants          *
****************************/
//QPSK Variables
#define SAMPLES_PER_SYMBOL 16
#define FILTER_TAPS 193
#define TIMING_PHASE_SPS 8
#define TWO_PI 6.2831853071795862
#define SQRT_2 1.414213562

//Phase locked loop constants
#define K1_PHASE 0.004975000621875
#define K2_PHASE 4.97500062187508e-05

//Timing sync loop constants
#define K1_TIMING -.002939400726737
#define K2_TIMING -1.17576029069497e-05

/* The In-phase channel LUT*/
const double Icarrier[] = {
	SQRT_2,
	0.00000000,
   -SQRT_2,
    0.00000000,
};

/* The Quadrature Channel LUT*/
const double Qcarrier[] = {
	0.00000000,
   -SQRT_2,
	0.00000000,
    SQRT_2,
};

/******************************************************************
*		Function Declarations for complete demodulator			  *
*******************************************************************/
void simple_fir_filterI(double *y, double x);
void simple_fir_filterQ(double *y, double x);
void timingPhaseCorrection(double MF_I, double MF_Q, double *ICorrected, double *QCorrected, bool *strobe);

//Phase locked loop functions
void ccwRotation(double I, double Q, double C, double S, double *Iprime, double *Qprime);
void PED(double I, double Q, bool strobe, double *out);
void ddsFrequency(double F, double *cosine, double *sine);
void phaseLoop(double e, double *v);

//Timing Synchronization functions
void farrowInterpolationQuadraticI(double in, double mu, double *out); //need 4 of these because they each use their own static variables
void farrowInterpolationQuadraticI2(double in, double mu, double *out);
void farrowInterpolationQuadraticQ(double in, double mu, double *out);
void farrowInterpolationQuadraticQ2(double in, double mu, double *out);
void TED(double x, double xd1, double xd2, double y, double yd1, double yd2, bool strobe, double *e);
void timingLoop(double e, double *v);
void interpolationControl(double w, double *reg, bool *underflow);

/****************************************
*		Matched Filter Coefficients		*
*****************************************/
const double firCoeff[] = {
	1.1129927921996379e-03,
	1.0783866354219360e-03,
	9.4622852019751844e-04,
	7.2308040136682375e-04,
	4.2370169025438844e-04,
	7.0133380709277188e-05,
	- 3.0988583319796698e-04,
	- 6.8506464877888292e-04,
	- 1.0231061760089483e-03,
	- 1.2934563911852785e-03,
	- 1.4700275176268006e-03,
	- 1.5336618651560201e-03,
	- 1.4741131855444030e-03,
	- 1.2913534893826694e-03,
	- 9.9606177279922188e-04,
	- 6.0921392742805509e-04,
	- 1.6076562553994335e-04,
	3.1250345277396974e-04,
	7.6984127413340657e-04,
	1.1698622862671329e-03,
	1.4741131855444043e-03,
	1.6505731785587557e-03,
	1.6767870560038917e-03,
	1.5423449703977068e-03,
	1.2504631040109342e-03,
	8.1848229412160645e-04,
	2.7718305525362602e-04,
	- 3.3109050561561072e-04,
	- 9.5540577214225258e-04,
	- 1.5401263504160197e-03,
	- 2.0294303542899412e-03,
	- 2.3721175684446854e-03,
	- 2.5263169727706065e-03,
	- 2.4636919090760133e-03,
	- 2.1727583533439924e-03,
	- 1.6609825949546820e-03,
	- 9.5540577214224911e-04,
	- 1.0164926599743242e-04,
	8.3872028437192352e-04,
	1.7923536486880410e-03,
	2.6795637943091491e-03,
	3.4206861532857231e-03,
	3.9428887729125372e-03,
	4.1868991045435275e-03,
	4.1130850421833313e-03,
	3.7063417712792277e-03,
	2.9792945037148827e-03,
	1.9734283493245764e-03,
	7.5789509183117945e-04,
	- 5.7408599072259489e-04,
	- 1.9111310690889411e-03,
	- 3.1316066933211569e-03,
	- 4.1130850421833322e-03,
	- 4.7427119051451474e-03,
	- 4.9277411390614353e-03,
	- 4.6054191345353962e-03,
	- 3.7513893120328036e-03,
	- 2.3858343246992418e-03,
	- 5.7668269052529061e-04,
	1.5606272586546335e-03,
	3.8671186015281616e-03,
	6.1480242702353976e-03,
	8.1840843721151333e-03,
	9.7458918657563863e-03,
	1.0610531285636549e-02,
	1.0579536779269733e-02,
	9.4970309783560213e-03,
	7.2668096044082968e-03,
	3.8671186015281568e-03,
	- 6.3806355218378656e-04,
	- 6.0922759461711079e-03,
	- 1.2245167497795721e-02,
	- 1.8756946560164054e-02,
	- 2.5208858177478519e-02,
	- 3.1119484521949542e-02,
	- 3.5966282689975766e-02,
	- 3.9211410735481095e-02,
	- 4.0330571969335781e-02,
	- 3.8843351654665445e-02,
	- 3.4343348320497805e-02,
	- 2.6526328214091358e-02,
	- 1.5214664217641057e-02,
	- 3.7646154501925041e-04,
	1.7861983527166048e-02,
	3.9211410735481116e-02,
	6.3223119794958316e-02,
	8.9300944925239795e-02,
	1.1672135344496908e-01,
	1.4466086795627373e-01,
	1.7222957297237970e-01,
	1.9850909096526162e-01,
	2.2259312375281709e-01,
	2.4362847189627376e-01,
	2.6085438001479727e-01,
	2.7363811512800634e-01,
	2.8150486617504894e-01,
	2.8416034605069990e-01,
	2.8150486617504894e-01,
	2.7363811512800634e-01,
	2.6085438001479727e-01,
	2.4362847189627376e-01,
	2.2259312375281709e-01,
	1.9850909096526162e-01,
	1.7222957297237970e-01,
	1.4466086795627373e-01,
	1.1672135344496908e-01,
	8.9300944925239795e-02,
	6.3223119794958316e-02,
	3.9211410735481116e-02,
	1.7861983527166048e-02,
	- 3.7646154501925041e-04,
	- 1.5214664217641057e-02,
	- 2.6526328214091358e-02,
	- 3.4343348320497805e-02,
	- 3.8843351654665445e-02,
	- 4.0330571969335781e-02,
	- 3.9211410735481095e-02,
	- 3.5966282689975766e-02,
	- 3.1119484521949542e-02,
	- 2.5208858177478519e-02,
	- 1.8756946560164054e-02,
	- 1.2245167497795721e-02,
	- 6.0922759461711079e-03,
	- 6.3806355218378656e-04,
	3.8671186015281568e-03,
	7.2668096044082968e-03,
	9.4970309783560213e-03,
	1.0579536779269733e-02,
	1.0610531285636549e-02,
	9.7458918657563863e-03,
	8.1840843721151333e-03,
	6.1480242702353976e-03,
	3.8671186015281616e-03,
	1.5606272586546335e-03,
	- 5.7668269052529061e-04,
	- 2.3858343246992418e-03,
	- 3.7513893120328036e-03,
	- 4.6054191345353962e-03,
	- 4.9277411390614353e-03,
	- 4.7427119051451474e-03,
	- 4.1130850421833322e-03,
	- 3.1316066933211569e-03,
	- 1.9111310690889411e-03,
	- 5.7408599072259489e-04,
	7.5789509183117945e-04,
	1.9734283493245764e-03,
	2.9792945037148827e-03,
	3.7063417712792277e-03,
	4.1130850421833313e-03,
	4.1868991045435275e-03,
	3.9428887729125372e-03,
	3.4206861532857231e-03,
	2.6795637943091491e-03,
	1.7923536486880410e-03,
	8.3872028437192352e-04,
	- 1.0164926599743242e-04,
	- 9.5540577214224911e-04,
	- 1.6609825949546820e-03,
	- 2.1727583533439924e-03,
	- 2.4636919090760133e-03,
	- 2.5263169727706065e-03,
	- 2.3721175684446854e-03,
	- 2.0294303542899412e-03,
	- 1.5401263504160197e-03,
	- 9.5540577214225258e-04,
	- 3.3109050561561072e-04,
	2.7718305525362602e-04,
	8.1848229412160645e-04,
	1.2504631040109342e-03,
	1.5423449703977068e-03,
	1.6767870560038917e-03,
	1.6505731785587557e-03,
	1.4741131855444043e-03,
	1.1698622862671329e-03,
	7.6984127413340657e-04,
	3.1250345277396974e-04,
	- 1.6076562553994335e-04,
	- 6.0921392742805509e-04,
	- 9.9606177279922188e-04,
	- 1.2913534893826694e-03,
	- 1.4741131855444030e-03,
	- 1.5336618651560201e-03,
	- 1.4700275176268006e-03,
	- 1.2934563911852785e-03,
	- 1.0231061760089483e-03,
	- 6.8506464877888292e-04,
	- 3.0988583319796698e-04,
	7.0133380709277188e-05,
	4.2370169025438844e-04,
	7.2308040136682375e-04,
	9.4622852019751844e-04,
	1.0783866354219360e-03,
	1.1129927921996379e-03
};


#endif
