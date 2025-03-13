#############################################################################################
#############################################################################################
#
#   The MIT License (MIT)
#   
#   Copyright (c) 2023 http://odelay.io 
#   
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be included in all
#   copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#   
#   Contact : <everett@odelay.io>
#  
#   Description : QPSK Demodulator
#
#   Version History:
#   
#       Date        Description
#     -----------   -----------------------------------------------------------------------
#      2025-02-22    Original Creation
#
###########################################################################################
###########################################################################################




import numpy as np
import matplotlib.pyplot as plt

def add_frequency_offset(signal, sample_rate, frequency_offset):
  """
  Adds a frequency offset to a signal.

  Args:
      signal (np.ndarray): The input signal array.
      sample_rate (float): The sampling rate of the signal in Hz.
      frequency_offset (float): The desired frequency offset in Hz.

  Returns:
      np.ndarray: The signal with the frequency offset applied.
  """
  time = np.arange(len(signal)) / sample_rate
  offset_signal = signal * np.exp(1j * 2 * np.pi * frequency_offset * time)
  return offset_signal


#-- ------------------------------------------------
#--     System Parameters
#-- ------------------------------------------------
C_SAVE_WF       = True
C_PLOT_COEF     = False
C_PLOT_TX_SAMPS = False
C_PLOT_RX_SAMPS = False
C_SampsPerSym   = 16
C_NUM_DWORD     = 1024
C_FREQ_OFF      = 1e3
C_SAMP_RATE     = 100e6



#-- ------------------------------------------------
#--     RRC Filter Coef
#-- ------------------------------------------------
firCoef = [
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
  1.1129927921996379e-03]

#-- Plot Coef
if(C_PLOT_COEF):
    plt.figure()
    plt.plot(firCoef)
    plt.grid()
    plt.show()
print("Number of Coef         : " + str(len(firCoef)))

#-- ------------------------------------------------
#--     Create 0xDEADBEEF Message
#-- ------------------------------------------------
hex_msg = "DEADBEEF"
print("Message: " + str(hex_msg))
bin_msg = bin(int(hex_msg,16))[2:].zfill(32)
bin_msg = bin_msg[::-1] # LSB transmitted first

# openssl rand -hex 4
syncword = "6D75521E"
print("Syncword: " + str(syncword))
syncword = bin(int(syncword,16))[2:].zfill(32)
syncword = syncword[::-1] # LSB transmitted first
print("Syncword: " + str(syncword))

#-- Create Bit Symbol 
sync_msg = []
for i in range(0,len(syncword)-1,2):
    if(int(syncword[i+1]) == 1):
        sync_msg.append(2+int(syncword[i]))
    else:
        sync_msg.append(0+int(syncword[i]))

sym_msg = []
for i in range(0,len(bin_msg)-1,2):
    if(int(bin_msg[i+1]) == 1):
        sym_msg.append(2+int(bin_msg[i]))
    else:
        sym_msg.append(0+int(bin_msg[i]))

#print(sym_msg)
# Repeat Message and add syncword
m = np.tile(sync_msg,1)
n = np.tile(sym_msg,C_NUM_DWORD)
#n = np.tile(sync_msg,C_NUM_DWORD)
sym_msg = np.append(m,n)
print(sym_msg)

#print(sym_msg)
print("Number of Symbols      : " + str(len(sym_msg)))

if(C_SAVE_WF):
    f = open("0xDEADBEEF_bit_out.dat","w")
    for s in sym_msg:
        f.write(str(s) + "\n")
    f.close()

#-- ------------------------------------------------
#--
#--     Create I/Q Symbols
#--
#-- Mapping:
#--
#--                 |
#--             01  |   11
#--                 |
#--           -------------
#--                 |
#--             00  |   10
#--                 |
#--
#--
#-- ------------------------------------------------
#iq_sym = np.zeros((len(sym_msg)),dtype=np.complex_)
iq_sym = np.zeros((len(sym_msg)),dtype=np.complex128)
for i in range(len(sym_msg)):
    if(sym_msg[i] == 3):
        iq_sym[i] = 1+1j
    elif(sym_msg[i] == 2):
        iq_sym[i] = -1+1j
    elif(sym_msg[i] == 1):
        iq_sym[i] = 1-1j
    else:
        iq_sym[i] = -1-1j
#print(iq_sym)
print("Bits Per Symbol (QPSK) : " + str(2))





#-- ------------------------------------------------
#--     Pass Symbols through Pulse Shape Filter 
#-- ------------------------------------------------
iq_upsamp = np.array([])
for sym in iq_sym:
    #pulse = np.zeros(C_SampsPerSym,dtype=np.complex_)
    pulse = np.zeros(C_SampsPerSym,dtype=np.complex128)
    pulse[0] = sym
    iq_upsamp = np.concatenate((iq_upsamp,pulse))
#print(iq_upsamp)
print("Samples Per Symbol     : " + str(C_SampsPerSym))

# Filter symbols
tx_iq_samps = np.convolve(iq_upsamp,firCoef)
rx_iq_samps = np.convolve(tx_iq_samps,firCoef)
print("Samples in Tx Signals  : " + str(len(tx_iq_samps)))
print("Samples in Rx Signals  : " + str(len(rx_iq_samps)))

# Add frequency offset
rx_iq_samps = add_frequency_offset(rx_iq_samps, C_SAMP_RATE, C_FREQ_OFF)

if(C_PLOT_TX_SAMPS):
    plt.figure()
    plt.plot(tx_iq_samps.real, label='real')
    plt.plot(tx_iq_samps.imag, label='imag')
    plt.title("Tx I/Q Samples")
    plt.grid()
    plt.legend()
    plt.show()

if(C_PLOT_RX_SAMPS):
    plt.figure()
    plt.plot(rx_iq_samps.real, label='real')
    plt.plot(rx_iq_samps.imag, label='imag')
    plt.title("Rx I/Q Samples")
    plt.grid()
    plt.legend()
    plt.show()

if(C_SAVE_WF):
    f = open("0xDEADBEEF_Rx_Samps.dat","w")
    for sample in rx_iq_samps:
        f.write(str(sample.real) + "\n" + str(sample.imag) + "\n")
    f.close()




