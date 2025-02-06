import pandas as pd
import matplotlib.pyplot as plt

# Read the CSV file
df = pd.read_csv("gng_data_out.csv")

# Plot the data
df.plot(label=["I","Q"])
plt.grid()
plt.title("AWGN Generator Output")
plt.xlabel("Sample Index")
plt.ylabel("Mag (lin)")
plt.legend(["I","Q"], loc='upper right')
plt.show()


#   import numpy
#   print("NumPy version:", numpy.__version__)
#   
#   import matplotlib
#   print("Matplotlib version:", matplotlib.__version__)
