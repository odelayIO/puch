from pynq import allocate
from pynq import MMIO
import pynq.lib.dma
import time

import fpga.lib.HLS_QPSK_Demod.sw.qpsk_regmap as qpsk_regmap



def get_fin():
  f = base.read(reg)
  tBits = f&0xFFFF
  fBits = (f&0xFFFF0000)>>16
  return(tBits,fBits)
