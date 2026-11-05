#!/usr/bin/env python3
"""Plot the AWGN gain -> SNR calibration sweep written by tb_gng_snr_cal.vhd.

Top:    measured SNR vs awgn_gain register code, with the ideal curve
        SNR = 10*log10(A^2 / (2*g^2)),  g = code / 2**awgn_fbits
Bottom: measured - ideal (dB)

Usage:
    python3 plot_snr_cal.py                          # sim/gng_snr_cal.csv, opens a window
    python3 plot_snr_cal.py my.csv --save cal.png    # write an image instead
    python3 plot_snr_cal.py --tone-amp 0.5           # if the sweep used TONE_AMP=0.5
"""

import argparse
import csv
import math
from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import FixedLocator, FuncFormatter, MultipleLocator, NullLocator


# Colors: one data series (palette slot 1) + neutral inks for text, reference and grid
SURFACE  = "#fcfcfb"
INK      = "#0b0b0b"
INK_2    = "#52514e"
GRID     = "#e4e3df"
SERIES_1 = "#2a78d6"


def read_csv(path):
    gain, snr = [], []
    with open(path, newline="") as f:
        for row in csv.DictReader(f):
            gain.append(int(row["awgn_gain"]))
            snr.append(float(row["snr_db"]))
    return np.array(gain), np.array(snr)


def style_axes(ax):
    ax.set_facecolor(SURFACE)
    ax.grid(True, which="major", color=GRID, linewidth=0.75)
    ax.set_axisbelow(True)
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(GRID)
    ax.tick_params(colors=INK_2, labelsize=9, length=0)
    ax.yaxis.label.set_color(INK_2)
    ax.xaxis.label.set_color(INK_2)


def main():
    p = argparse.ArgumentParser(description="Plot the gng_top AWGN gain -> SNR calibration CSV.")
    p.add_argument("csv", nargs="?", type=Path,
                   default=Path(__file__).with_name("gng_snr_cal.csv"),
                   help="calibration CSV (default: gng_snr_cal.csv next to this script)")
    p.add_argument("--tone-amp", type=float, default=1.0,
                   help="TONE_AMP generic used for the sweep (default 1.0)")
    p.add_argument("--awgn-fbits", type=int, default=11,
                   help="F_AWGN fractional bits of the awgn_gain register (default 11)")
    p.add_argument("--save", metavar="FILE",
                   help="write the figure to FILE (png/pdf/svg) instead of opening a window")
    args = p.parse_args()

    gain, snr = read_csv(args.csv)

    # gain = 0 has no noise (testbench writes 999 dB); it can't sit on a log axis
    keep = gain > 0
    if not keep.all():
        print(f"Skipping {np.count_nonzero(~keep)} row(s) with awgn_gain = 0")
    gain, snr = gain[keep], snr[keep]

    g = gain / 2.0 ** args.awgn_fbits
    ideal = 10.0 * np.log10(args.tone_amp ** 2 / (2.0 * g ** 2))
    err = snr - ideal

    print(f"{args.csv}: {len(gain)} points, awgn_gain {gain.min()}..{gain.max()}, "
          f"SNR {snr.max():.2f}..{snr.min():.2f} dB, "
          f"measured - ideal: mean {err.mean():+.3f} dB, max |{np.abs(err).max():.3f}| dB")

    # ------------------------------------------------------------------
    # Figure: SNR on top, deviation from ideal below, shared x
    # ------------------------------------------------------------------
    fig, (ax1, ax2) = plt.subplots(
        2, 1, sharex=True, figsize=(9, 6.5), facecolor=SURFACE,
        gridspec_kw={"height_ratios": [3, 1.2], "hspace": 0.08})
    style_axes(ax1)
    style_axes(ax2)

    ax1.plot(gain, ideal, color=INK_2, linewidth=1.0, linestyle=(0, (4, 3)),
             label="Ideal  10·log10(A² / 2g²)", zorder=2)
    ax1.plot(gain, snr, color=SERIES_1, linewidth=1.5,
             solid_capstyle="round", solid_joinstyle="round",
             label="Measured (xsim)", zorder=3)
    ax1.set_ylabel("SNR (dB)")
    ax1.yaxis.set_major_locator(MultipleLocator(10))
    ax1.legend(frameon=False, loc="upper right", fontsize=9, labelcolor=INK)

    ax2.axhline(0.0, color=INK_2, linewidth=0.75, zorder=2)
    ax2.plot(gain, err, color=SERIES_1, linewidth=1.5,
             solid_capstyle="round", solid_joinstyle="round", zorder=3)
    lim = max(0.5, math.ceil(np.abs(err).max() * 4) / 4)
    ax2.set_ylim(-lim, lim)
    ax2.set_ylabel("Measured − ideal (dB)")

    # x: log2 axis with power-of-two register codes as ticks
    ax2.set_xscale("log", base=2)
    k_lo = int(math.floor(math.log2(gain.min())))
    k_hi = int(math.ceil(math.log2(gain.max())))
    ax2.xaxis.set_major_locator(FixedLocator([2 ** k for k in range(k_lo, k_hi + 1)]))
    ax2.xaxis.set_minor_locator(NullLocator())
    ax2.xaxis.set_major_formatter(FuncFormatter(lambda v, _: f"{int(v):,}"))
    ax2.set_xlim(2 ** k_lo, 2 ** k_hi)
    ax2.set_xlabel(f"awgn_gain register code   (gain = code / 2^{args.awgn_fbits})")

    ax1.set_title("AWGN calibration: SNR vs awgn_gain", loc="left",
                  color=INK, fontsize=13, fontweight="semibold", pad=22)
    ax1.text(0.0, 1.02,
             f"{args.csv.name} · {len(gain)} points · tone amplitude A = {args.tone_amp:g}",
             transform=ax1.transAxes, color=INK_2, fontsize=9, va="bottom")

    if args.save:
        fig.savefig(args.save, dpi=150, facecolor=SURFACE, bbox_inches="tight")
        print(f"Wrote {args.save}")
    else:
        plt.show()


if __name__ == "__main__":
    main()
