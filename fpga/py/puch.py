from pynq import MMIO

#from pynq import allocate
#import pynq.lib.dma
#import time


#----------------------------------------------------------------------------------------
#  PYNQ Constructor for Consair RegMap
#----------------------------------------------------------------------------------------
class PynqInterface:
    """Adapter to provide `.read(addr)` and `.write(addr, val)` expected by RegMap.
    Addresses passed to these methods are *offsets* (same convention used in RegMap).
    """

    def __init__(self, base_addr, length):
        """
        base_addr: physical base address of the IP (e.g. 0x40000000)
        length: size in bytes to map (make sure it covers the highest register offset + 4)
        """
        self._base = base_addr
        self._mmio = MMIO(self._base, length)

    def read(self, offset):
        """Read a 32-bit value at offset (offset is in bytes)."""
        # MMIO.read takes offset relative to base
        return self._mmio.read(offset)

    def write(self, offset, val):
        """Write a 32-bit value at offset."""
        self._mmio.write(offset, val)

        
        
#----------------------------------------------------------------------------------------
#  Puch Helper Functions
#----------------------------------------------------------------------------------------
def get_timestamp_str(timestamp):
  yr      = str(hex(timestamp.time_stamp_year)[2:])
  mon     = str(hex(timestamp.time_stamp_month)[2:])
  day     = str(hex(timestamp.time_stamp_day)[2:])
  hour    = str(hex(timestamp.time_stamp_hour)[2:])
  minute  = str(hex(timestamp.time_stamp_minute)[2:])
  sec     = str(hex(timestamp.time_stamp_seconds)[2:])

  
  return (yr+"/"+mon+"/"+day+" "+hour+":"+minute+":"+sec)



