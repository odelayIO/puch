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
#   Description : Generates Xilinx COE file for FIR (Matched Filter)
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

C_PLOT_COEF   = False # Plot coef



def create_coe_file(filename, data, data_width=8, memory_type="RAM", radix=16):
    """
    Generates a Xilinx COE file.

    Args:
        filename (str): The name of the COE file to create.
        data (list): A list of integers representing the data to be stored in memory.
        data_width (int, optional): The width of the data in bits. Defaults to 8.
        memory_type (str, optional): The type of memory ("RAM" or "ROM"). Defaults to "RAM".
        radix (int, optional): The radix of the data (2, 10, or 16). Defaults to 16.
    """

    with open(filename, "w") as f:
        f.write(f"; Sample Xilinx {memory_type} Initialization File\n")
        f.write(f"; Radix = {radix}\n")
        f.write(f"; Data Width = {data_width};\n\n")
        f.write(f"radix = {radix};\n\n")
        f.write("CoefData =\n")

        for i, value in enumerate(data):
            if radix == 16:
                f.write(f"{value:02X}")  # Format as hexadecimal
            elif radix == 2:
                f.write(f"{value:0{data_width}b}") # Format as binary
            else:
                f.write(str(int(value*2**15)))
            if i < len(data) - 1:
                f.write(",\n")
            else:
                f.write(";")

#-- ------------------------------------------------
#--     Plot Coef
#-- ------------------------------------------------
if(C_PLOT_COEF):
    plt.figure()
    plt.plot(fir_coef.firCoef)
    plt.grid()
    plt.show()
print("Number of Coef         : " + str(len(fir_coef.firCoef)))

# Example usage:
create_coe_file("MF_FIR.coe", fir_coef.firCoef, radix=10)
print("Done creating COE file.")

