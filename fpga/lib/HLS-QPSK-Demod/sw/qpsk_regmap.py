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
