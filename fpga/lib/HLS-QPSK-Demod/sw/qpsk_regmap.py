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


class _RegWr_cap_ctrl:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def wr_addr(self):
        """The write address pointer.  Value is the number of samples written to BRAM and can reset the pointer"""
        rdata = self._rmap._if.read(self._rmap.WR_CAP_CTRL_ADDR)
        return (rdata >> self._rmap.WR_CAP_CTRL_WR_ADDR_POS) & self._rmap.WR_CAP_CTRL_WR_ADDR_MSK

    @wr_addr.setter
    def wr_addr(self, val):
        rdata = self._rmap._if.read(self._rmap.WR_CAP_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.WR_CAP_CTRL_WR_ADDR_MSK << self._rmap.WR_CAP_CTRL_WR_ADDR_POS))
        rdata = rdata | (val << self._rmap.WR_CAP_CTRL_WR_ADDR_POS)
        self._rmap._if.write(self._rmap.WR_CAP_CTRL_ADDR, rdata)

    @property
    def wr_enable(self):
        """The write enable to capture output of the QPSK Demodulator"""
        rdata = self._rmap._if.read(self._rmap.WR_CAP_CTRL_ADDR)
        return (rdata >> self._rmap.WR_CAP_CTRL_WR_ENABLE_POS) & self._rmap.WR_CAP_CTRL_WR_ENABLE_MSK

    @wr_enable.setter
    def wr_enable(self, val):
        rdata = self._rmap._if.read(self._rmap.WR_CAP_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.WR_CAP_CTRL_WR_ENABLE_MSK << self._rmap.WR_CAP_CTRL_WR_ENABLE_POS))
        rdata = rdata | (val << self._rmap.WR_CAP_CTRL_WR_ENABLE_POS)
        self._rmap._if.write(self._rmap.WR_CAP_CTRL_ADDR, rdata)

    @property
    def wr_addr_clr(self):
        """The write address pointer clear.  Strobed for 1 cc, self cleared"""
        return 0

    @wr_addr_clr.setter
    def wr_addr_clr(self, val):
        rdata = self._rmap._if.read(self._rmap.WR_CAP_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.WR_CAP_CTRL_WR_ADDR_CLR_MSK << self._rmap.WR_CAP_CTRL_WR_ADDR_CLR_POS))
        rdata = rdata | (val << self._rmap.WR_CAP_CTRL_WR_ADDR_CLR_POS)
        self._rmap._if.write(self._rmap.WR_CAP_CTRL_ADDR, rdata)


class _RegRd_cap_ctrl:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def rd_addr(self):
        """The read address pointer."""
        rdata = self._rmap._if.read(self._rmap.RD_CAP_CTRL_ADDR)
        return (rdata >> self._rmap.RD_CAP_CTRL_RD_ADDR_POS) & self._rmap.RD_CAP_CTRL_RD_ADDR_MSK

    @rd_addr.setter
    def rd_addr(self, val):
        rdata = self._rmap._if.read(self._rmap.RD_CAP_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.RD_CAP_CTRL_RD_ADDR_MSK << self._rmap.RD_CAP_CTRL_RD_ADDR_POS))
        rdata = rdata | (val << self._rmap.RD_CAP_CTRL_RD_ADDR_POS)
        self._rmap._if.write(self._rmap.RD_CAP_CTRL_ADDR, rdata)

    @property
    def rd_enable(self):
        """The read enable. Strobed for 1cc, self cleared"""
        return 0

    @rd_enable.setter
    def rd_enable(self, val):
        rdata = self._rmap._if.read(self._rmap.RD_CAP_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.RD_CAP_CTRL_RD_ENABLE_MSK << self._rmap.RD_CAP_CTRL_RD_ENABLE_POS))
        rdata = rdata | (val << self._rmap.RD_CAP_CTRL_RD_ENABLE_POS)
        self._rmap._if.write(self._rmap.RD_CAP_CTRL_ADDR, rdata)


class _RegRd_cap_data:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def rd_data(self):
        """The read data"""
        rdata = self._rmap._if.read(self._rmap.RD_CAP_DATA_ADDR)
        return (rdata >> self._rmap.RD_CAP_DATA_RD_DATA_POS) & self._rmap.RD_CAP_DATA_RD_DATA_MSK

    @rd_data.setter
    def rd_data(self, val):
        rdata = self._rmap._if.read(self._rmap.RD_CAP_DATA_ADDR)
        rdata = rdata & (~(self._rmap.RD_CAP_DATA_RD_DATA_MSK << self._rmap.RD_CAP_DATA_RD_DATA_POS))
        rdata = rdata | (val << self._rmap.RD_CAP_DATA_RD_DATA_POS)
        self._rmap._if.write(self._rmap.RD_CAP_DATA_ADDR, rdata)


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

    # WR_CAP_CTRL - QPSK Demodulator write buffer control registers
    WR_CAP_CTRL_ADDR = 0x0c
    WR_CAP_CTRL_WR_ADDR_POS = 0
    WR_CAP_CTRL_WR_ADDR_MSK = 0xffff
    WR_CAP_CTRL_WR_ENABLE_POS = 16
    WR_CAP_CTRL_WR_ENABLE_MSK = 0x1
    WR_CAP_CTRL_WR_ADDR_CLR_POS = 17
    WR_CAP_CTRL_WR_ADDR_CLR_MSK = 0x1

    # RD_CAP_CTRL - QPSK Demodulator read buffer control registers
    RD_CAP_CTRL_ADDR = 0x10
    RD_CAP_CTRL_RD_ADDR_POS = 0
    RD_CAP_CTRL_RD_ADDR_MSK = 0xffff
    RD_CAP_CTRL_RD_ENABLE_POS = 16
    RD_CAP_CTRL_RD_ENABLE_MSK = 0x1

    # RD_CAP_DATA - QPSK Demodulator read buffer data register
    RD_CAP_DATA_ADDR = 0x14
    RD_CAP_DATA_RD_DATA_POS = 0
    RD_CAP_DATA_RD_DATA_MSK = 0xffffffff

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
    def wr_cap_ctrl(self):
        """QPSK Demodulator write buffer control registers"""
        return self._if.read(self.WR_CAP_CTRL_ADDR)

    @wr_cap_ctrl.setter
    def wr_cap_ctrl(self, val):
        self._if.write(self.WR_CAP_CTRL_ADDR, val)

    @property
    def wr_cap_ctrl_bf(self):
        return _RegWr_cap_ctrl(self)

    @property
    def rd_cap_ctrl(self):
        """QPSK Demodulator read buffer control registers"""
        return self._if.read(self.RD_CAP_CTRL_ADDR)

    @rd_cap_ctrl.setter
    def rd_cap_ctrl(self, val):
        self._if.write(self.RD_CAP_CTRL_ADDR, val)

    @property
    def rd_cap_ctrl_bf(self):
        return _RegRd_cap_ctrl(self)

    @property
    def rd_cap_data(self):
        """QPSK Demodulator read buffer data register"""
        return self._if.read(self.RD_CAP_DATA_ADDR)

    @rd_cap_data.setter
    def rd_cap_data(self, val):
        self._if.write(self.RD_CAP_DATA_ADDR, val)

    @property
    def rd_cap_data_bf(self):
        return _RegRd_cap_data(self)
