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
