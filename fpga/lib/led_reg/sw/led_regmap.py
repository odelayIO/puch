#!/usr/bin/env python3
# -*- coding: utf-8 -*-

""" Created with Corsair vgit-latest

Control/status register map.
"""


class _RegUser_leds:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def user_leds(self):
        """User LEDs"""
        rdata = self._rmap._if.read(self._rmap.USER_LEDS_ADDR)
        return (rdata >> self._rmap.USER_LEDS_USER_LEDS_POS) & self._rmap.USER_LEDS_USER_LEDS_MSK

    @user_leds.setter
    def user_leds(self, val):
        rdata = self._rmap._if.read(self._rmap.USER_LEDS_ADDR)
        rdata = rdata & (~(self._rmap.USER_LEDS_USER_LEDS_MSK << self._rmap.USER_LEDS_USER_LEDS_POS))
        rdata = rdata | (val << self._rmap.USER_LEDS_USER_LEDS_POS)
        self._rmap._if.write(self._rmap.USER_LEDS_ADDR, rdata)


class RegMap:
    """Control/Status register map"""

    # USER_LEDS - User Leds on KR260 (user_leds[1:0])
    USER_LEDS_ADDR = 0x0010
    USER_LEDS_USER_LEDS_POS = 0
    USER_LEDS_USER_LEDS_MSK = 0x3

    def __init__(self, interface):
        self._if = interface

    @property
    def user_leds(self):
        """User Leds on KR260 (user_leds[1:0])"""
        return self._if.read(self.USER_LEDS_ADDR)

    @user_leds.setter
    def user_leds(self, val):
        self._if.write(self.USER_LEDS_ADDR, val)

    @property
    def user_leds_bf(self):
        return _RegUser_leds(self)
