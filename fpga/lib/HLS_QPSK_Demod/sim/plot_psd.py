
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
from scipy.signal import welch

def plot_psd_from_file(filename, fs):
    """
    Reads a file containing signal data and plots the Power Spectral Density (PSD).
    
    Parameters:
        filename (str): Path to the file containing the signal data.
        fs (float): Sampling frequency of the signal.
    """
    # Load data from file
    data = np.loadtxt(filename)
    
    # Compute the Power Spectral Density
    freqs, psd = welch(data, fs=fs, nperseg=1024)
   
    psd_dbm = 10 * np.log10(psd*1000)

    # Plot the PSD
    plt.figure(figsize=(8, 6))
    plt.plot(freqs, psd_dbm)
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Power Spectral Density (dBm)')
    plt.title('Power Spectral Density Plot')
    plt.grid()
    plt.show()


    # Plot the time-domain signal
    time = np.arange(len(data)) / fs
    plt.figure(figsize=(8, 6))
    plt.plot(time, data)
    plt.xlabel('Time (s)')
    plt.ylabel('Amplitude')
    plt.title('Time-Domain Signal')
    plt.grid()
    plt.show()

# Example usage
plot_psd_from_file('../modulatedData.dat', fs=1000000)
