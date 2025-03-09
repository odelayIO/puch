#!/usr/bin/env python3
# -*- coding: utf-8 -*-

""" Created with Corsair vgit-latest

Control/status register map.
"""


class _RegF_in:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def f_in_total(self):
        """Input data stream format total bit width"""
        rdata = self._rmap._if.read(self._rmap.F_IN_ADDR)
        return (rdata >> self._rmap.F_IN_F_IN_TOTAL_POS) & self._rmap.F_IN_F_IN_TOTAL_MSK

    @property
    def f_in_fractional(self):
        """Input data stream format fractional bits"""
        rdata = self._rmap._if.read(self._rmap.F_IN_ADDR)
        return (rdata >> self._rmap.F_IN_F_IN_FRACTIONAL_POS) & self._rmap.F_IN_F_IN_FRACTIONAL_MSK


class _RegF_out:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def f_out_total(self):
        """Output data stream format total bit width"""
        rdata = self._rmap._if.read(self._rmap.F_OUT_ADDR)
        return (rdata >> self._rmap.F_OUT_F_OUT_TOTAL_POS) & self._rmap.F_OUT_F_OUT_TOTAL_MSK

    @property
    def f_out_fractional(self):
        """Output data stream format fractional bits"""
        rdata = self._rmap._if.read(self._rmap.F_OUT_ADDR)
        return (rdata >> self._rmap.F_OUT_F_OUT_FRACTIONAL_POS) & self._rmap.F_OUT_F_OUT_FRACTIONAL_MSK


class _RegAp_control:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ap_start(self):
        """The start of HLS processor"""
        rdata = self._rmap._if.read(self._rmap.AP_CONTROL_ADDR)
        return (rdata >> self._rmap.AP_CONTROL_AP_START_POS) & self._rmap.AP_CONTROL_AP_START_MSK

    @ap_start.setter
    def ap_start(self, val):
        rdata = self._rmap._if.read(self._rmap.AP_CONTROL_ADDR)
        rdata = rdata & (~(self._rmap.AP_CONTROL_AP_START_MSK << self._rmap.AP_CONTROL_AP_START_POS))
        rdata = rdata | (val << self._rmap.AP_CONTROL_AP_START_POS)
        self._rmap._if.write(self._rmap.AP_CONTROL_ADDR, rdata)

    @property
    def ap_done(self):
        """HLS ap_done"""
        rdata = self._rmap._if.read(self._rmap.AP_CONTROL_ADDR)
        return (rdata >> self._rmap.AP_CONTROL_AP_DONE_POS) & self._rmap.AP_CONTROL_AP_DONE_MSK

    @property
    def ap_idle(self):
        """HLS ap_idle"""
        rdata = self._rmap._if.read(self._rmap.AP_CONTROL_ADDR)
        return (rdata >> self._rmap.AP_CONTROL_AP_IDLE_POS) & self._rmap.AP_CONTROL_AP_IDLE_MSK


class _RegWr_ram:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def addr(self):
        """The write address pointer.  Value is the number of samples written to BRAM and can reset the pointer"""
        rdata = self._rmap._if.read(self._rmap.WR_RAM_ADDR)
        return (rdata >> self._rmap.WR_RAM_ADDR_POS) & self._rmap.WR_RAM_ADDR_MSK


class _RegWr_ram_addr_ctrl:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def clr(self):
        """The write address pointer clear.  Strobed for 1 cc, self cleared"""
        return 0

    @clr.setter
    def clr(self, val):
        rdata = self._rmap._if.read(self._rmap.WR_RAM_ADDR_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.WR_RAM_ADDR_CTRL_CLR_MSK << self._rmap.WR_RAM_ADDR_CTRL_CLR_POS))
        rdata = rdata | (val << self._rmap.WR_RAM_ADDR_CTRL_CLR_POS)
        self._rmap._if.write(self._rmap.WR_RAM_ADDR_CTRL_ADDR, rdata)


class _RegRd_ram_addr:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def value(self):
        """The read address pointer."""
        rdata = self._rmap._if.read(self._rmap.RD_RAM_ADDR_ADDR)
        return (rdata >> self._rmap.RD_RAM_ADDR_VALUE_POS) & self._rmap.RD_RAM_ADDR_VALUE_MSK

    @value.setter
    def value(self, val):
        rdata = self._rmap._if.read(self._rmap.RD_RAM_ADDR_ADDR)
        rdata = rdata & (~(self._rmap.RD_RAM_ADDR_VALUE_MSK << self._rmap.RD_RAM_ADDR_VALUE_POS))
        rdata = rdata | (val << self._rmap.RD_RAM_ADDR_VALUE_POS)
        self._rmap._if.write(self._rmap.RD_RAM_ADDR_ADDR, rdata)


class _RegRd_ram_data:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def value(self):
        """The read data"""
        rdata = self._rmap._if.read(self._rmap.RD_RAM_DATA_ADDR)
        return (rdata >> self._rmap.RD_RAM_DATA_VALUE_POS) & self._rmap.RD_RAM_DATA_VALUE_MSK


class RegMap:
    """Control/Status register map"""

    # F_IN - Input data stream format
    F_IN_ADDR = 0x00
    F_IN_F_IN_TOTAL_POS = 0
    F_IN_F_IN_TOTAL_MSK = 0xffff
    F_IN_F_IN_FRACTIONAL_POS = 16
    F_IN_F_IN_FRACTIONAL_MSK = 0xffff

    # F_OUT - Output data stream format
    F_OUT_ADDR = 0x04
    F_OUT_F_OUT_TOTAL_POS = 0
    F_OUT_F_OUT_TOTAL_MSK = 0xffff
    F_OUT_F_OUT_FRACTIONAL_POS = 16
    F_OUT_F_OUT_FRACTIONAL_MSK = 0xffff

    # AP_CONTROL - HLS block level control protocol signals
    AP_CONTROL_ADDR = 0x08
    AP_CONTROL_AP_START_POS = 0
    AP_CONTROL_AP_START_MSK = 0x1
    AP_CONTROL_AP_DONE_POS = 1
    AP_CONTROL_AP_DONE_MSK = 0x1
    AP_CONTROL_AP_IDLE_POS = 2
    AP_CONTROL_AP_IDLE_MSK = 0x1

    # WR_RAM - QPSK Demodulator write buffer address register
    WR_RAM_ADDR = 0x0c
    WR_RAM_ADDR_POS = 0
    WR_RAM_ADDR_MSK = 0xffff

    # WR_RAM_ADDR_CTRL - QPSK Demodulator write address clear
    WR_RAM_ADDR_CTRL_ADDR = 0x10
    WR_RAM_ADDR_CTRL_CLR_POS = 0
    WR_RAM_ADDR_CTRL_CLR_MSK = 0x1

    # RD_RAM_ADDR - QPSK Demodulator read buffer address register
    RD_RAM_ADDR_ADDR = 0x14
    RD_RAM_ADDR_VALUE_POS = 0
    RD_RAM_ADDR_VALUE_MSK = 0xffff

    # RD_RAM_DATA - QPSK Demodulator read buffer data register
    RD_RAM_DATA_ADDR = 0x18
    RD_RAM_DATA_VALUE_POS = 0
    RD_RAM_DATA_VALUE_MSK = 0xffffffff

    def __init__(self, interface):
        self._if = interface

    @property
    def f_in(self):
        """Input data stream format"""
        return self._if.read(self.F_IN_ADDR)

    @property
    def f_in_bf(self):
        return _RegF_in(self)

    @property
    def f_out(self):
        """Output data stream format"""
        return self._if.read(self.F_OUT_ADDR)

    @property
    def f_out_bf(self):
        return _RegF_out(self)

    @property
    def ap_control(self):
        """HLS block level control protocol signals"""
        return self._if.read(self.AP_CONTROL_ADDR)

    @ap_control.setter
    def ap_control(self, val):
        self._if.write(self.AP_CONTROL_ADDR, val)

    @property
    def ap_control_bf(self):
        return _RegAp_control(self)

    @property
    def wr_ram(self):
        """QPSK Demodulator write buffer address register"""
        return self._if.read(self.WR_RAM_ADDR)

    @property
    def wr_ram_bf(self):
        return _RegWr_ram(self)

    @property
    def wr_ram_addr_ctrl(self):
        """QPSK Demodulator write address clear"""
        return 0

    @wr_ram_addr_ctrl.setter
    def wr_ram_addr_ctrl(self, val):
        self._if.write(self.WR_RAM_ADDR_CTRL_ADDR, val)

    @property
    def wr_ram_addr_ctrl_bf(self):
        return _RegWr_ram_addr_ctrl(self)

    @property
    def rd_ram_addr(self):
        """QPSK Demodulator read buffer address register"""
        return self._if.read(self.RD_RAM_ADDR_ADDR)

    @rd_ram_addr.setter
    def rd_ram_addr(self, val):
        self._if.write(self.RD_RAM_ADDR_ADDR, val)

    @property
    def rd_ram_addr_bf(self):
        return _RegRd_ram_addr(self)

    @property
    def rd_ram_data(self):
        """QPSK Demodulator read buffer data register"""
        return self._if.read(self.RD_RAM_DATA_ADDR)

    @property
    def rd_ram_data_bf(self):
        return _RegRd_ram_data(self)
