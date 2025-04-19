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
import fir_coef


#-- ------------------------------------------------
#--     System Parameters
#-- ------------------------------------------------
C_SAVE_WF       = True
C_PLOT_COEF     = False 
C_PLOT_TX_SAMPS = False 
C_PLOT_RX_SAMPS = False 
C_SampsPerSym   = 16
C_NUM_DWORD     = 8
C_FREQ_OFF      = 0 #1e3
C_SAMP_RATE     = 100e6
C_SYNCWORD      = "6D75521E"  # openssl rand -hex 4




#-- -------------------------------------------------------------------------
#--     Functions
#-- -------------------------------------------------------------------------
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
#--     Plot Coef
#-- ------------------------------------------------
if(C_PLOT_COEF):
    plt.figure()
    plt.plot(fir_coef.firCoef)
    plt.grid()
    plt.show()
print("Number of Coef         : " + str(len(fir_coef.firCoef)))


#-- ------------------------------------------------
#--     Create 0xDEADBEEF Message w/ SyncWord
#-- ------------------------------------------------
hex_msg = "DEADBEEF"
print("Message (HEX)          : " + str(hex_msg))
bin_msg = bin(int(hex_msg,16))[2:].zfill(32) # Hex String to Binary
bin_msg = bin_msg[::-1] # LSB transmitted first
print("Message (BIN)          : " + str(bin_msg))

print("Syncword (HEX)         : " + str(C_SYNCWORD))
syncword = bin(int(C_SYNCWORD,16))[2:].zfill(32) # Hex String to Binary
syncword = syncword[::-1] # LSB transmitted first
print("Syncword (BIN)         : " + str(syncword))


#-- ------------------------------------------------
#--     Convert bit to 2-bit number array 
#-- ------------------------------------------------
sync_msg = []
for i in range(0,len(syncword)-1,2):
    if(int(syncword[i+1]) == 1):
        sync_msg.append(2+int(syncword[i]))
    else:
        sync_msg.append(0+int(syncword[i]))
#print(sync_msg)

sym_msg = []
for i in range(0,len(bin_msg)-1,2):
    if(int(bin_msg[i+1]) == 1):
        sym_msg.append(2+int(bin_msg[i]))
    else:
        sym_msg.append(0+int(bin_msg[i]))
#print(sym_msg)


#-- ------------------------------------------------
#--     Repeat Message and add syncword
#-- ------------------------------------------------
m = np.tile(sync_msg,1)
n = np.tile(sym_msg,C_NUM_DWORD)
sym_msg = np.append(m,n)
print("Full Message           : " + str(sym_msg))
print("Number of Symbols      : " + str(len(sym_msg)))






#-- ------------------------------------------------
#--     Save Output Files
#-- ------------------------------------------------
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
iq_sym = np.zeros((len(sym_msg)),dtype=np.complex64)
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
#--     Upsample Signal before PSF & Matched Filter
#-- ------------------------------------------------
iq_upsamp = np.array([])
for sym in iq_sym:
    #pulse = np.zeros(C_SampsPerSym,dtype=np.complex_)
    pulse = np.zeros(C_SampsPerSym,dtype=np.complex64)
    pulse[0] = sym
    iq_upsamp = np.concatenate((iq_upsamp,pulse))
#print(iq_upsamp)
print("Samples Per Symbol     : " + str(C_SampsPerSym))


#-- ------------------------------------------------
#--     Pass Signal through PSF and Matched filters
#-- ------------------------------------------------
tx_iq_samps = np.convolve(iq_upsamp,fir_coef.firCoef)
rx_iq_samps = np.convolve(tx_iq_samps,fir_coef.firCoef)
print("Samples in Tx Signals  : " + str(len(tx_iq_samps)))
print("Samples in Rx Signals  : " + str(len(rx_iq_samps)))

#-- ------------------------------------------------
#--     Add frequency offset
#-- ------------------------------------------------
rx_iq_samps = add_frequency_offset(rx_iq_samps, C_SAMP_RATE, C_FREQ_OFF)



#-- ------------------------------------------------
#--     Plot Output
#-- ------------------------------------------------
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

#-- ------------------------------------------------
#--     Save Output to File
#-- ------------------------------------------------

# Used with Xilinx Vitis CSIM
if(C_SAVE_WF):
    # Rx samples after Matched Filter
    f = open("0xDEADBEEF_Rx_Samps.dat","w")
    for sample in rx_iq_samps:
        f.write(str(sample.real) + "\n" + str(sample.imag) + "\n")
    f.close()
    # Tx samples after Pulse Shape Filter
    f = open("0xDEADBEEF_Tx_Samps.dat","w")
    for sample in tx_iq_samps:
        f.write(str(sample.real) + "\n" + str(sample.imag) + "\n")
    f.close()


# Used with GNU Radio
if(C_SAVE_WF):
    # Rx samples after Matched Filter
    rx_iq_samps = rx_iq_samps.astype(np.complex64)
    rx_iq_samps.tofile('0xDEADBEEF_Rx_Samps.bin')
    # Tx samples after Pulse Shape Filter
    tx_iq_samps = tx_iq_samps.astype(np.complex64)
    tx_iq_samps.tofile('0xDEADBEEF_Tx_Samps.bin')



