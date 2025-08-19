#!/usr/bin/env python3
# -*- coding: utf-8 -*-

""" Created with Corsair vgit-latest

Control/status register map.
"""


class _RegTime_stamp_year:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ts_year(self):
        """Time Stamp Year (Hex Value)"""
        rdata = self._rmap._if.read(self._rmap.TIME_STAMP_YEAR_ADDR)
        return (rdata >> self._rmap.TIME_STAMP_YEAR_TS_YEAR_POS) & self._rmap.TIME_STAMP_YEAR_TS_YEAR_MSK


class _RegTime_stamp_month:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ts_month(self):
        """Time Stamp Month (Hex Value)"""
        rdata = self._rmap._if.read(self._rmap.TIME_STAMP_MONTH_ADDR)
        return (rdata >> self._rmap.TIME_STAMP_MONTH_TS_MONTH_POS) & self._rmap.TIME_STAMP_MONTH_TS_MONTH_MSK


class _RegTime_stamp_day:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ts_day(self):
        """Time Stamp Day (Hex Value)"""
        rdata = self._rmap._if.read(self._rmap.TIME_STAMP_DAY_ADDR)
        return (rdata >> self._rmap.TIME_STAMP_DAY_TS_DAY_POS) & self._rmap.TIME_STAMP_DAY_TS_DAY_MSK


class _RegTime_stamp_hour:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ts_hour(self):
        """Time Stamp Hour (Hex Value)"""
        rdata = self._rmap._if.read(self._rmap.TIME_STAMP_HOUR_ADDR)
        return (rdata >> self._rmap.TIME_STAMP_HOUR_TS_HOUR_POS) & self._rmap.TIME_STAMP_HOUR_TS_HOUR_MSK


class _RegTime_stamp_minute:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ts_min(self):
        """Time Stamp Minute (Hex Value)"""
        rdata = self._rmap._if.read(self._rmap.TIME_STAMP_MINUTE_ADDR)
        return (rdata >> self._rmap.TIME_STAMP_MINUTE_TS_MIN_POS) & self._rmap.TIME_STAMP_MINUTE_TS_MIN_MSK


class _RegTime_stamp_seconds:
    def __init__(self, rmap):
        self._rmap = rmap

    @property
    def ts_sec(self):
        """Time Stamp Seconds (Hex Value)"""
        rdata = self._rmap._if.read(self._rmap.TIME_STAMP_SECONDS_ADDR)
        return (rdata >> self._rmap.TIME_STAMP_SECONDS_TS_SEC_POS) & self._rmap.TIME_STAMP_SECONDS_TS_SEC_MSK


class RegMap:
    """Control/Status register map"""

    # TIME_STAMP_YEAR - Time Stamp Year (Hex Value)
    TIME_STAMP_YEAR_ADDR = 0x10
    TIME_STAMP_YEAR_TS_YEAR_POS = 0
    TIME_STAMP_YEAR_TS_YEAR_MSK = 0xffff

    # TIME_STAMP_MONTH - Time Stamp Month (Hex Value)
    TIME_STAMP_MONTH_ADDR = 0x14
    TIME_STAMP_MONTH_TS_MONTH_POS = 0
    TIME_STAMP_MONTH_TS_MONTH_MSK = 0xff

    # TIME_STAMP_DAY - Time Stamp Day (Hex Value)
    TIME_STAMP_DAY_ADDR = 0x18
    TIME_STAMP_DAY_TS_DAY_POS = 0
    TIME_STAMP_DAY_TS_DAY_MSK = 0xff

    # TIME_STAMP_HOUR - Time Stamp Hour (Hex Value)
    TIME_STAMP_HOUR_ADDR = 0x1c
    TIME_STAMP_HOUR_TS_HOUR_POS = 0
    TIME_STAMP_HOUR_TS_HOUR_MSK = 0xff

    # TIME_STAMP_MINUTE - Time Stamp Minute (Hex Value)
    TIME_STAMP_MINUTE_ADDR = 0x20
    TIME_STAMP_MINUTE_TS_MIN_POS = 0
    TIME_STAMP_MINUTE_TS_MIN_MSK = 0xff

    # TIME_STAMP_SECONDS - Time Stamp Seconds (Hex Value)
    TIME_STAMP_SECONDS_ADDR = 0x24
    TIME_STAMP_SECONDS_TS_SEC_POS = 0
    TIME_STAMP_SECONDS_TS_SEC_MSK = 0xff

    def __init__(self, interface):
        self._if = interface

    @property
    def time_stamp_year(self):
        """Time Stamp Year (Hex Value)"""
        return self._if.read(self.TIME_STAMP_YEAR_ADDR)

    @property
    def time_stamp_year_bf(self):
        return _RegTime_stamp_year(self)

    @property
    def time_stamp_month(self):
        """Time Stamp Month (Hex Value)"""
        return self._if.read(self.TIME_STAMP_MONTH_ADDR)

    @property
    def time_stamp_month_bf(self):
        return _RegTime_stamp_month(self)

    @property
    def time_stamp_day(self):
        """Time Stamp Day (Hex Value)"""
        return self._if.read(self.TIME_STAMP_DAY_ADDR)

    @property
    def time_stamp_day_bf(self):
        return _RegTime_stamp_day(self)

    @property
    def time_stamp_hour(self):
        """Time Stamp Hour (Hex Value)"""
        return self._if.read(self.TIME_STAMP_HOUR_ADDR)

    @property
    def time_stamp_hour_bf(self):
        return _RegTime_stamp_hour(self)

    @property
    def time_stamp_minute(self):
        """Time Stamp Minute (Hex Value)"""
        return self._if.read(self.TIME_STAMP_MINUTE_ADDR)

    @property
    def time_stamp_minute_bf(self):
        return _RegTime_stamp_minute(self)

    @property
    def time_stamp_seconds(self):
        """Time Stamp Seconds (Hex Value)"""
        return self._if.read(self.TIME_STAMP_SECONDS_ADDR)

    @property
    def time_stamp_seconds_bf(self):
        return _RegTime_stamp_seconds(self)
