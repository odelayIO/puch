from pynq import allocate
from pynq import MMIO
import pynq.lib.dma
import time

import fpga.lib.timestamp.sw.timestamp_regmap as timestamp_regmap
#import fpga.lib.led_reg.sw.led_regmap



def get_timestamp_str(timestamp):
  yr      = str(hex(timestamp.mmio.read(timestamp_regmap.RegMap.TIME_STAMP_YEAR_ADDR)))[2:]
  mon     = str(hex(timestamp.mmio.read(timestamp_regmap.RegMap.TIME_STAMP_MONTH_ADDR)))[2:]
  day     = str(hex(timestamp.mmio.read(timestamp_regmap.RegMap.TIME_STAMP_DAY_ADDR)))[2:]
  hour    = str(hex(timestamp.mmio.read(timestamp_regmap.RegMap.TIME_STAMP_HOUR_ADDR)))[2:]
  minute  = str(hex(timestamp.mmio.read(timestamp_regmap.RegMap.TIME_STAMP_MINUTE_ADDR)))[2:]
  sec     = str(hex(timestamp.mmio.read(timestamp_regmap.RegMap.TIME_STAMP_SECONDS_ADDR)))[2:]

  
  return (yr+"/"+mon+"/"+day+" "+hour+":"+minute+":"+sec)


def get_format(base,reg):
  f = base.read(reg)
  tBits = f&0xFFFF
  fBits = (f&0xFFFF0000)>>16
  return(tBits,fBits)
