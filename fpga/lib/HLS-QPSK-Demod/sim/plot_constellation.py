import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.signal import welch

def plot_constellation_from_file(filename):
  """
  Reads a file containing signal data and plots the Constellation.
  
  Parameters:
      filename (str): Path to the file containing the signal data.
  """
  # Load data from file
  data = pd.read_csv(filename, header=None, names=['I','Q'])

  plt.figure()
  plt.scatter(data['I'],data['Q'])
  plt.grid()
  plt.title('Output Constellation')
  plt.show()


plot_constellation_from_file("./out_constellation.csv")
