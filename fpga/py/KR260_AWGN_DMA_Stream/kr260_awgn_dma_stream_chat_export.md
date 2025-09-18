# Chat Export: KR260 AWGN DMA Stream Notebook Edits (Detailed)

Date: 2025-09-18

This document is a detailed export of the interactive session that updated
`fpga/py/KR260_AWGN_DMA_Stream/kr260_awgn_dma_stream.ipynb` to add continuous DMA streaming
with readback and live plotting, plus offline tests and a hardware example.

## High-level goal

- Continuously write an ARM-side buffer to the FPGA AWGN block via DMA Tx, read back the processed
  buffer on the DMA Rx channel, and plot the readback data live inside the Jupyter notebook.

## What changed (concise list)

- Matplotlib-based streaming utilities:
  - `MatplotlibDMAStreamer`: background writer thread + main-thread-safe plotting API.
  - `use_pynq_buffers` option: allocate PYNQ DMA-safe buffers when running on hardware, copy to NumPy for plotting.

- Dummy and tests:
  - `DummyDMA` and `_run_dummy_demo()` for offline testing without hardware.
  - `_automated_dummy_test()` automated smoke test that asserts the streamer processed at least one buffer.

- Hardware example:
  - `hardware_stream_example(...)` demonstrates AWGN configuration, PYNQ buffer usage, and counter reads.

- Backwards compatibility:
  - Original Bokeh helper (`plot_time`) and `DMAStreamer` (Bokeh-based) were left in the notebook for users who prefer that backend.

## Design rationale and notes

- Plotting safety: GUI backends must be updated from the main thread. The writer runs in background and enqueues NumPy buffers.
  The notebook exposes `update_plot_once()` for safe main-thread redraws and an optional `start_auto_plot()` that uses
  the Matplotlib figure's timer (if the frontend supports it).

- PYNQ buffers: when interacting with real DMA on PYNQ, it's safer to allocate device-backed buffers via `pynq.allocate()`.
  `MatplotlibDMAStreamer` supports `use_pynq_buffers=True` to allocate send/recv buffers, copy `recv` to NumPy, and close
  the PYNQ buffers as soon as possible to avoid holding onto scarce device memory.

- Queue semantics: the writer enqueues numpy arrays into a bounded queue (maxsize 64). On overflow the oldest buffer is dropped.

## Files touched

- `fpga/py/KR260_AWGN_DMA_Stream/kr260_awgn_dma_stream.ipynb`:
  - Added cells: Matplotlib streamer, DummyDMA, demo, automated test, hardware example, and descriptive markdown.

## How to run (detailed)

Note: these steps assume you open the Jupyter notebook in a PYNQ-capable environment (or any Jupyter for dummy tests).

1) Run the overlay/load cells (top of the notebook) to set up `overlay`, `dma`, `awgn`, and helper regmaps.

2) Optional: check installed packages. In a terminal or notebook cell run:

```bash
pip install numpy==1.26.4 ipympl ipywidgets jupyter_bokeh
```

3) To run the offline automated dummy test (no hardware required):

- Execute the notebook cells that define `MatplotlibDMAStreamer`, `DummyDMA`, and the test cell.
- Run the automated test cell (it calls `_automated_dummy_test(run_seconds=3)`). You should see a printed success message.

4) Manual dummy demo (visual):

- In the notebook, run the Matplotlib streamer cell, then call `_run_dummy_demo()` in a new cell. It starts the demo for 5s,
  updates the plot via `update_plot_once()` in main thread, and stops cleanly.

5) Hardware example (PYNQ board):

- Make sure the overlay cell was executed and `dma` and `awgn` are available.
- Ensure `ipympl` is enabled in the notebook (%matplotlib ipympl) or that the notebook frontend supports Matplotlib GUI timers.
- Execute the Matplotlib streamer cell and then call the helper:

```python
# example: 10 second run
hardware_stream_example(duration_s=10, chunk_size=1024, plot_interval_ms=200)
```

The example configures AWGN, starts a MatplotlibDMAStreamer with `use_pynq_buffers=True`, and attempts to use
the figure's GUI timer to call `update_plot_once()` from the main thread; if that fails it falls back to a manual loop.

## Reproducible quick smoke commands

- Run the automated dummy test from a notebook cell (already present in the notebook):

```python
_automated_dummy_test(run_seconds=3)
```

- Manually run visual dummy demo:

```python
# run in a notebook cell
_run_dummy_demo()
```

## Checklist mapping (requirements → status)

- Implement continuous DMA writer/reader and live plotting: Done (MatplotlibDMAStreamer + queue + writer thread).
- Convert to Matplotlib/ipympl and add dummy test: Done (MatplotlibDMAStreamer + DummyDMA + automated test).
- Add automated smoke test that asserts queue processing: Done (`_automated_dummy_test`).
- Replace unsafe plotting thread with main-thread updates: Done (`update_plot_once()` + optional `start_auto_plot()`).
- Add `use_pynq_buffers` for hardware path: Done (writer copies off PYNQ buffers to NumPy and closes buffers).

## Known limitations & recommended follow-ups

- The notebook still contains the original Bokeh helper and the Bokeh-based `DMAStreamer`. If you want a single
  canonical implementation consider removing duplicates.

- The automated test relies on GUI-capable environments to draw; for CI/headless testing, refactor plotting out of the
  test path or mock the Matplotlib canvas.

- Consider adding an interrupt-safe wrapper that ensures `streamer.stop()` is always called on kernel interruption
  (use try/finally around demo loops or a context manager).

## Recent tool activity (edits & confirmations)

- A todo list entry was created and updated while producing this export.
- This file was created and updated in `docs/kr260_awgn_dma_stream_chat_export.md`.
- Notebook edits (cells added/updated) were applied earlier in the session and confirmed by the editor tool.

---

If you'd like I can also:

- produce a compact patch that removes the older Bokeh code and keeps only the Matplotlib-based implementation, or
- add a small context-manager wrapper `with MatplotlibDMAStreamer(...) as s:` that automatically calls `start()`/`stop()`.

If you want any of those follow-ups, tell me which to implement next.
