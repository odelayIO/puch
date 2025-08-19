#!/usr/bin/env python3
# -*- coding: utf-8 -*-

""" Created with Corsair vgit-latest

Control/status register map.
"""


class _RegMax_depth:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def len(self):
        """The depth of the capture FIFO"""
        rdata = self._rmap._if.read(self._rmap.MAX_DEPTH_ADDR)
        return (rdata >> self._rmap.MAX_DEPTH_LEN_POS) & self._rmap.MAX_DEPTH_LEN_MSK


class _RegCapture_length:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def len(self):
        """The start of HLS processor"""
        rdata = self._rmap._if.read(self._rmap.CAPTURE_LENGTH_ADDR)
        return (rdata >> self._rmap.CAPTURE_LENGTH_LEN_POS) & self._rmap.CAPTURE_LENGTH_LEN_MSK

    @len.setter
    def len(self, val):
        rdata = self._rmap._if.read(self._rmap.CAPTURE_LENGTH_ADDR)
        rdata = rdata & (~(self._rmap.CAPTURE_LENGTH_LEN_MSK << self._rmap.CAPTURE_LENGTH_LEN_POS))
        rdata = rdata | (val << self._rmap.CAPTURE_LENGTH_LEN_POS)
        self._rmap._if.write(self._rmap.CAPTURE_LENGTH_ADDR, rdata)


class _RegCapture_stb:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def cap_stb(self):
        """Capture Strobe, self clearing 1cc strobe"""
        return 0

    @cap_stb.setter
    def cap_stb(self, val):
        rdata = self._rmap._if.read(self._rmap.CAPTURE_STB_ADDR)
        rdata = rdata & (~(self._rmap.CAPTURE_STB_CAP_STB_MSK << self._rmap.CAPTURE_STB_CAP_STB_POS))
        rdata = rdata | (val << self._rmap.CAPTURE_STB_CAP_STB_POS)
        self._rmap._if.write(self._rmap.CAPTURE_STB_ADDR, rdata)


class _RegFifo_flush:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def flush(self):
        """Flush the FIFO for a new capture trigger"""
        rdata = self._rmap._if.read(self._rmap.FIFO_FLUSH_ADDR)
        return (rdata >> self._rmap.FIFO_FLUSH_FLUSH_POS) & self._rmap.FIFO_FLUSH_FLUSH_MSK

    @flush.setter
    def flush(self, val):
        rdata = self._rmap._if.read(self._rmap.FIFO_FLUSH_ADDR)
        rdata = rdata & (~(self._rmap.FIFO_FLUSH_FLUSH_MSK << self._rmap.FIFO_FLUSH_FLUSH_POS))
        rdata = rdata | (val << self._rmap.FIFO_FLUSH_FLUSH_POS)
        self._rmap._if.write(self._rmap.FIFO_FLUSH_ADDR, rdata)


class _RegFifo_wr_ptr:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def wr_ptr(self):
        """FIFO Write Pointer"""
        rdata = self._rmap._if.read(self._rmap.FIFO_WR_PTR_ADDR)
        return (rdata >> self._rmap.FIFO_WR_PTR_WR_PTR_POS) & self._rmap.FIFO_WR_PTR_WR_PTR_MSK


class _RegFifo_rd_ptr:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def rd_ptr(self):
        """FIFO Read Pointer"""
        rdata = self._rmap._if.read(self._rmap.FIFO_RD_PTR_ADDR)
        return (rdata >> self._rmap.FIFO_RD_PTR_RD_PTR_POS) & self._rmap.FIFO_RD_PTR_RD_PTR_MSK


class _RegEnable_debug_cnt:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def en_debug_cnt(self):
        """Enable the debug counter on DMA data output port"""
        rdata = self._rmap._if.read(self._rmap.ENABLE_DEBUG_CNT_ADDR)
        return (rdata >> self._rmap.ENABLE_DEBUG_CNT_EN_DEBUG_CNT_POS) & self._rmap.ENABLE_DEBUG_CNT_EN_DEBUG_CNT_MSK

    @en_debug_cnt.setter
    def en_debug_cnt(self, val):
        rdata = self._rmap._if.read(self._rmap.ENABLE_DEBUG_CNT_ADDR)
        rdata = rdata & (~(self._rmap.ENABLE_DEBUG_CNT_EN_DEBUG_CNT_MSK << self._rmap.ENABLE_DEBUG_CNT_EN_DEBUG_CNT_POS))
        rdata = rdata | (val << self._rmap.ENABLE_DEBUG_CNT_EN_DEBUG_CNT_POS)
        self._rmap._if.write(self._rmap.ENABLE_DEBUG_CNT_ADDR, rdata)


class RegMap:
    """Control/Status register map"""

    # MAX_DEPTH - The depth of the capture FIFO
    MAX_DEPTH_ADDR = 0x00
    MAX_DEPTH_LEN_POS = 0
    MAX_DEPTH_LEN_MSK = 0xffffffff

    # CAPTURE_LENGTH - The number of samples to capture in buffer
    CAPTURE_LENGTH_ADDR = 0x04
    CAPTURE_LENGTH_LEN_POS = 0
    CAPTURE_LENGTH_LEN_MSK = 0xffffffff

    # CAPTURE_STB - Capture Strobe, self clearing 1cc strobe
    CAPTURE_STB_ADDR = 0x08
    CAPTURE_STB_CAP_STB_POS = 0
    CAPTURE_STB_CAP_STB_MSK = 0x1

    # FIFO_FLUSH - Flush the FIFO for a new capture trigger
    FIFO_FLUSH_ADDR = 0x0c
    FIFO_FLUSH_FLUSH_POS = 0
    FIFO_FLUSH_FLUSH_MSK = 0x1

    # FIFO_WR_PTR - FIFO Write Pointer
    FIFO_WR_PTR_ADDR = 0x10
    FIFO_WR_PTR_WR_PTR_POS = 0
    FIFO_WR_PTR_WR_PTR_MSK = 0xffffffff

    # FIFO_RD_PTR - FIFO Read Pointer
    FIFO_RD_PTR_ADDR = 0x14
    FIFO_RD_PTR_RD_PTR_POS = 0
    FIFO_RD_PTR_RD_PTR_MSK = 0xffffffff

    # ENABLE_DEBUG_CNT - Enable the debug counter on DMA data output port
    ENABLE_DEBUG_CNT_ADDR = 0x18
    ENABLE_DEBUG_CNT_EN_DEBUG_CNT_POS = 0
    ENABLE_DEBUG_CNT_EN_DEBUG_CNT_MSK = 0x1

    def __init__(self, interface):
        self._if = interface

    @property
    def max_depth(self):
        """The depth of the capture FIFO"""
        return self._if.read(self.MAX_DEPTH_ADDR)

    @property
    def max_depth_bf(self):
        return _RegMax_depth(self)

    @property
    def capture_length(self):
        """The number of samples to capture in buffer"""
        return self._if.read(self.CAPTURE_LENGTH_ADDR)

    @capture_length.setter
    def capture_length(self, val):
        self._if.write(self.CAPTURE_LENGTH_ADDR, val)

    @property
    def capture_length_bf(self):
        return _RegCapture_length(self)

    @property
    def capture_stb(self):
        """Capture Strobe, self clearing 1cc strobe"""
        return 0

    @capture_stb.setter
    def capture_stb(self, val):
        self._if.write(self.CAPTURE_STB_ADDR, val)

    @property
    def capture_stb_bf(self):
        return _RegCapture_stb(self)

    @property
    def fifo_flush(self):
        """Flush the FIFO for a new capture trigger"""
        return self._if.read(self.FIFO_FLUSH_ADDR)

    @fifo_flush.setter
    def fifo_flush(self, val):
        self._if.write(self.FIFO_FLUSH_ADDR, val)

    @property
    def fifo_flush_bf(self):
        return _RegFifo_flush(self)

    @property
    def fifo_wr_ptr(self):
        """FIFO Write Pointer"""
        return self._if.read(self.FIFO_WR_PTR_ADDR)

    @property
    def fifo_wr_ptr_bf(self):
        return _RegFifo_wr_ptr(self)

    @property
    def fifo_rd_ptr(self):
        """FIFO Read Pointer"""
        return self._if.read(self.FIFO_RD_PTR_ADDR)

    @property
    def fifo_rd_ptr_bf(self):
        return _RegFifo_rd_ptr(self)

    @property
    def enable_debug_cnt(self):
        """Enable the debug counter on DMA data output port"""
        return self._if.read(self.ENABLE_DEBUG_CNT_ADDR)

    @enable_debug_cnt.setter
    def enable_debug_cnt(self, val):
        self._if.write(self.ENABLE_DEBUG_CNT_ADDR, val)

    @property
    def enable_debug_cnt_bf(self):
        return _RegEnable_debug_cnt(self)
