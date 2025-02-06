#!/usr/bin/env python


import numpy as np
import scipy
import os
import signal

BLOCK_SIZE      = 8192
_FN_FPGA2ARM    = "/home/xilinx/jupyter_notebooks/puch/fifo_fpga2arm"
_FN_ARM2FPGA    = "/home/xilinx/jupyter_notebooks/puch/fifo_arm2fpga"
_TIMEOUT        = 1000
 
def handler(signum, frame):
  raise Exception("Opening Named Pipe Timeout Error")
 


class puch(object):
  '''Create drivers for puch framework'''
  def __init__(self,fn_arm2fpga=_FN_ARM2FPGA,fn_fpga2arm=_FN_FPGA2ARM,timeout=_TIMEOUT):
    '''Create the FIFO Files (aka Named Pipes)'''



    # Set the signal handler and a _TIMEOUT-second alarm
    signal.signal(signal.SIGALRM, handler)
    signal.alarm(timeout)

    # Check if Pipe exists, if true then unlink and create pipe
    try:
      #if(not os.path.exists(fn_fpga2arm)):
      #  os.mkfifo(fn_fpga2arm)

      #if(not os.path.exists(fn_arm2fpga)):
      #  os.mkfifo(fn_arm2fpga)

      print("opening fn_arm2fpga...")
      self.fifo_arm2fpga = open(fn_arm2fpga,"rb")
      print("opening fn_fpga2arm...")
      self.fifo_fpga2arm = open(fn_fpga2arm,"wb")
      self.data_arm2fpga = np.zeros(BLOCK_SIZE,dtype=np.complex64)
    except Exception as exc:
      print(exc)

    print("Created Read Pipe: "+str(fn_arm2fpga))
    print("Created Read Pipe: "+str(fn_fpga2arm))
    signal.alarm(0)

  def __exit__(self, exc_type, exc_value, exc_traceback):
    print('Releasing puch resouces...')
    os.unlink(self.fn_arm2fpga)
    os.unlink(self.fn_fpga2arm)
    print('Done.')


  def read_fifo(self, N=BLOCK_SIZE):
    '''Read I/Q samples from FIFO File'''
    N=N*8 # Convert Bytes to Samples
    data_arm2fpga = np.frombuffer(self.fifo_arm2fpga.read(N),dtype=np.complex64)
    return(data_arm2fpga)

  def write_fifo(self, cData):
    '''Write I/Q samples from FIFO File'''
    cData = np.array(cData).astype("complex64")
    self.fifo_fpga2arm.write(cData)




#def main():
#  hpi = hpi(SERIAL_PORT, SERIAL_PORT_BAUD)
#  #time.sleep(2.0)

#  hpi.write(0xA0101,0x81)

#  hpi.close()


#if __name__ == '__main__':
#  main()

