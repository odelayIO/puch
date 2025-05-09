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


class _RegAwgn_enable:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def awgn_enable(self):
        """AWGN Noise Enable Control, '1' - Enabled, '0' - Bypassed (Default '0')"""
        rdata = self._rmap._if.read(self._rmap.AWGN_ENABLE_ADDR)
        return (rdata >> self._rmap.AWGN_ENABLE_AWGN_ENABLE_POS) & self._rmap.AWGN_ENABLE_AWGN_ENABLE_MSK

    @awgn_enable.setter
    def awgn_enable(self, val):
        rdata = self._rmap._if.read(self._rmap.AWGN_ENABLE_ADDR)
        rdata = rdata & (~(self._rmap.AWGN_ENABLE_AWGN_ENABLE_MSK << self._rmap.AWGN_ENABLE_AWGN_ENABLE_POS))
        rdata = rdata | (val << self._rmap.AWGN_ENABLE_AWGN_ENABLE_POS)
        self._rmap._if.write(self._rmap.AWGN_ENABLE_ADDR, rdata)

    @property
    def sat_i_ch(self):
        """A '1' means I-Channel was Saturated since last read.  Read clear bit field"""
        rdata = self._rmap._if.read(self._rmap.AWGN_ENABLE_ADDR)
        return (rdata >> self._rmap.AWGN_ENABLE_SAT_I_CH_POS) & self._rmap.AWGN_ENABLE_SAT_I_CH_MSK

    @property
    def sat_q_ch(self):
        """A '1' means Q-Channel was Saturated since last read.  Read clear bit field"""
        rdata = self._rmap._if.read(self._rmap.AWGN_ENABLE_ADDR)
        return (rdata >> self._rmap.AWGN_ENABLE_SAT_Q_CH_POS) & self._rmap.AWGN_ENABLE_SAT_Q_CH_MSK


class _RegTvalid_cnt:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def tvalid_cnt(self):
        """Counter of tvalids"""
        rdata = self._rmap._if.read(self._rmap.TVALID_CNT_ADDR)
        return (rdata >> self._rmap.TVALID_CNT_TVALID_CNT_POS) & self._rmap.TVALID_CNT_TVALID_CNT_MSK


class _RegTlast_cnt:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def tlast_cnt(self):
        """Counter of tlast"""
        rdata = self._rmap._if.read(self._rmap.TLAST_CNT_ADDR)
        return (rdata >> self._rmap.TLAST_CNT_TLAST_CNT_POS) & self._rmap.TLAST_CNT_TLAST_CNT_MSK


class _RegCnt_ctrl:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def clear_cnt(self):
        """A '1' clears all counters"""
        return 0

    @clear_cnt.setter
    def clear_cnt(self, val):
        rdata = self._rmap._if.read(self._rmap.CNT_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.CNT_CTRL_CLEAR_CNT_MSK << self._rmap.CNT_CTRL_CLEAR_CNT_POS))
        rdata = rdata | (val << self._rmap.CNT_CTRL_CLEAR_CNT_POS)
        self._rmap._if.write(self._rmap.CNT_CTRL_ADDR, rdata)

    @property
    def capture_cnt(self):
        """A '1' captures all counter"""
        return 0

    @capture_cnt.setter
    def capture_cnt(self, val):
        rdata = self._rmap._if.read(self._rmap.CNT_CTRL_ADDR)
        rdata = rdata & (~(self._rmap.CNT_CTRL_CAPTURE_CNT_MSK << self._rmap.CNT_CTRL_CAPTURE_CNT_POS))
        rdata = rdata | (val << self._rmap.CNT_CTRL_CAPTURE_CNT_POS)
        self._rmap._if.write(self._rmap.CNT_CTRL_ADDR, rdata)


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

    # AWGN_ENABLE - AWGN Noise Enable
    AWGN_ENABLE_ADDR = 0x10
    AWGN_ENABLE_AWGN_ENABLE_POS = 0
    AWGN_ENABLE_AWGN_ENABLE_MSK = 0x1
    AWGN_ENABLE_SAT_I_CH_POS = 1
    AWGN_ENABLE_SAT_I_CH_MSK = 0x1
    AWGN_ENABLE_SAT_Q_CH_POS = 2
    AWGN_ENABLE_SAT_Q_CH_MSK = 0x1

    # TVALID_CNT - Counter for TValid
    TVALID_CNT_ADDR = 0x14
    TVALID_CNT_TVALID_CNT_POS = 0
    TVALID_CNT_TVALID_CNT_MSK = 0xffffffff

    # TLAST_CNT - Counter for TLast
    TLAST_CNT_ADDR = 0x18
    TLAST_CNT_TLAST_CNT_POS = 0
    TLAST_CNT_TLAST_CNT_MSK = 0xffffffff

    # CNT_CTRL - Control Signals for the Strobe Counters
    CNT_CTRL_ADDR = 0x1c
    CNT_CTRL_CLEAR_CNT_POS = 0
    CNT_CTRL_CLEAR_CNT_MSK = 0x1
    CNT_CTRL_CAPTURE_CNT_POS = 1
    CNT_CTRL_CAPTURE_CNT_MSK = 0x1

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

    @property
    def awgn_enable(self):
        """AWGN Noise Enable"""
        return self._if.read(self.AWGN_ENABLE_ADDR)

    @awgn_enable.setter
    def awgn_enable(self, val):
        self._if.write(self.AWGN_ENABLE_ADDR, val)

    @property
    def awgn_enable_bf(self):
        return _RegAwgn_enable(self)

    @property
    def tvalid_cnt(self):
        """Counter for TValid"""
        return self._if.read(self.TVALID_CNT_ADDR)

    @property
    def tvalid_cnt_bf(self):
        return _RegTvalid_cnt(self)

    @property
    def tlast_cnt(self):
        """Counter for TLast"""
        return self._if.read(self.TLAST_CNT_ADDR)

    @property
    def tlast_cnt_bf(self):
        return _RegTlast_cnt(self)

    @property
    def cnt_ctrl(self):
        """Control Signals for the Strobe Counters"""
        return 0

    @cnt_ctrl.setter
    def cnt_ctrl(self, val):
        self._if.write(self.CNT_CTRL_ADDR, val)

    @property
    def cnt_ctrl_bf(self):
        return _RegCnt_ctrl(self)
