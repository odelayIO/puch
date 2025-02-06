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


class _RegF_awgn:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def f_awgn_total(self):
        """Output AWGN data stream format total bit width"""
        rdata = self._rmap._if.read(self._rmap.F_AWGN_ADDR)
        return (rdata >> self._rmap.F_AWGN_F_AWGN_TOTAL_POS) & self._rmap.F_AWGN_F_AWGN_TOTAL_MSK

    @property
    def f_awgn_fractional(self):
        """Output AWGN data stream format fractional bits"""
        rdata = self._rmap._if.read(self._rmap.F_AWGN_ADDR)
        return (rdata >> self._rmap.F_AWGN_F_AWGN_FRACTIONAL_POS) & self._rmap.F_AWGN_F_AWGN_FRACTIONAL_MSK


class _RegAwgn_noise_gain:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def awgn_noise_gain(self):
        """AWGN Noise Gain, same format as AWGN"""
        rdata = self._rmap._if.read(self._rmap.AWGN_NOISE_GAIN_ADDR)
        return (rdata >> self._rmap.AWGN_NOISE_GAIN_AWGN_NOISE_GAIN_POS) & self._rmap.AWGN_NOISE_GAIN_AWGN_NOISE_GAIN_MSK

    @awgn_noise_gain.setter
    def awgn_noise_gain(self, val):
        rdata = self._rmap._if.read(self._rmap.AWGN_NOISE_GAIN_ADDR)
        rdata = rdata & (~(self._rmap.AWGN_NOISE_GAIN_AWGN_NOISE_GAIN_MSK << self._rmap.AWGN_NOISE_GAIN_AWGN_NOISE_GAIN_POS))
        rdata = rdata | (val << self._rmap.AWGN_NOISE_GAIN_AWGN_NOISE_GAIN_POS)
        self._rmap._if.write(self._rmap.AWGN_NOISE_GAIN_ADDR, rdata)


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

    # F_AWGN - Output AWGN data stream format
    F_AWGN_ADDR = 0x08
    F_AWGN_F_AWGN_TOTAL_POS = 0
    F_AWGN_F_AWGN_TOTAL_MSK = 0xffff
    F_AWGN_F_AWGN_FRACTIONAL_POS = 16
    F_AWGN_F_AWGN_FRACTIONAL_MSK = 0xffff

    # AWGN_NOISE_GAIN - AWGN Noise Gain
    AWGN_NOISE_GAIN_ADDR = 0x0c
    AWGN_NOISE_GAIN_AWGN_NOISE_GAIN_POS = 0
    AWGN_NOISE_GAIN_AWGN_NOISE_GAIN_MSK = 0xffff

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
    def f_awgn(self):
        """Output AWGN data stream format"""
        return self._if.read(self.F_AWGN_ADDR)

    @property
    def f_awgn_bf(self):
        return _RegF_awgn(self)

    @property
    def awgn_noise_gain(self):
        """AWGN Noise Gain"""
        return self._if.read(self.AWGN_NOISE_GAIN_ADDR)

    @awgn_noise_gain.setter
    def awgn_noise_gain(self, val):
        self._if.write(self.AWGN_NOISE_GAIN_ADDR, val)

    @property
    def awgn_noise_gain_bf(self):
        return _RegAwgn_noise_gain(self)
