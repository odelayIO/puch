# %%
# DMA Data Capture IP Dual-Channel Async Streaming with Scrolling Plot

import asyncio
import matplotlib.pyplot as plt
import numpy as np
from pynq import MMIO, Overlay, allocate
import threading

# %%
class DMA_Data_Capture:
    """
    Async-capable DMA_Data_Capture with:
      • Single-shot FIFO/DMA
      • Threaded streaming
      • Async streaming
      • Timeout, auto-restart
      • Optional live scrolling plot
      • Dual-channel support
    """

    def __init__(self, overlay, ip_name, dma_name=None, dma_name2=None):
        self.base_addr = overlay.ip_dict[ip_name]["phys_addr"]
        self.regs = RegMap(self.base_addr)
        self.dma = overlay.axi_dma_0 if dma_name is None else getattr(overlay, dma_name)
        self.dma2 = None if dma_name2 is None else getattr(overlay, dma_name2)

        self._stream_thread = None
        self._stream_running = False

    def reset_fifo(self):
        self.regs.fifo_flush_bf.flush = 1

    def set_capture_length(self, n_samples: int):
        self.regs.capture_length_bf.len = n_samples

    def start_capture(self, n_samples: int):
        self.reset_fifo()
        self.set_capture_length(n_samples)
        self.regs.capture_stb_bf.cap_stb = 1

    # ---------------- Async Streaming ---------------- #

    async def stream_blocks(self, bufsize, dtype=np.uint32, num_blocks=None, timeout=None,
                            auto_restart=False, live_plot=False, history_size=None,
                            dual_channel=False):
        """
        Async generator with optional live dual-channel scrolling plot.

        Args:
            bufsize (int): number of samples per block
            dtype: numpy dtype
            num_blocks (int or None): None = infinite, N = finite
            timeout (float or None): per-block timeout
            auto_restart (bool): automatically resume on timeout
            live_plot (bool): display live plot
            history_size (int or None): number of samples for scrolling history
            dual_channel (bool): enable second channel
        """

        # Allocate buffers
        bufA = allocate(shape=(bufsize,), dtype=dtype)
        bufB = allocate(shape=(bufsize,), dtype=dtype)
        active, standby = bufA, bufB

        if dual_channel:
            if self.dma2 is None:
                raise ValueError("Dual channel requested but dma_name2 not provided")
            bufA2 = allocate(shape=(bufsize,), dtype=dtype)
            bufB2 = allocate(shape=(bufsize,), dtype=dtype)
            active2, standby2 = bufA2, bufB2

        # Setup live plot
        if live_plot:
            plt.ion()
            fig, ax = plt.subplots()
            if history_size is None:
                history_size = bufsize
            history_buffer = np.zeros(history_size, dtype=dtype)
            if dual_channel:
                history_buffer2 = np.zeros(history_size, dtype=dtype)
                line2, = ax.plot(history_buffer2, color='red', label='Channel 2')
            line, = ax.plot(history_buffer, color='blue', label='Channel 1')
            ax.set_ylim(0, np.iinfo(dtype).max)
            ax.legend()
            plt.show()

        async def _block_iter():
            nonlocal active, standby, history_buffer
            if dual_channel:
                nonlocal active2, standby2, history_buffer2

            while True:
                try:
                    # Start capture
                    self.start_capture(bufsize)
                    self.dma.recvchannel.transfer(active)
                    if dual_channel:
                        self.dma2.recvchannel.transfer(active2)

                    # Wait for DMA completion with timeout
                    loop = asyncio.get_running_loop()
                    await asyncio.wait_for(
                        loop.run_in_executor(None, self.dma.recvchannel.wait),
                        timeout=timeout
                    )
                    if dual_channel:
                        await asyncio.wait_for(
                            loop.run_in_executor(None, self.dma2.recvchannel.wait),
                            timeout=timeout
                        )

                    # Copy blocks
                    block = np.copy(active)
                    if dual_channel:
                        block2 = np.copy(active2)

                    # Update live plot
                    if live_plot:
                        # Channel 1
                        if len(block) >= history_size:
                            history_buffer = block[-history_size:]
                        else:
                            history_buffer = np.roll(history_buffer, -len(block))
                            history_buffer[-len(block):] = block
                        line.set_ydata(history_buffer)
                        line.set_xdata(np.arange(len(history_buffer)))

                        if dual_channel:
                            if len(block2) >= history_size:
                                history_buffer2 = block2[-history_size:]
                            else:
                                history_buffer2 = np.roll(history_buffer2, -len(block2))
                                history_buffer2[-len(block2):] = block2
                            line2.set_ydata(history_buffer2)
                            line2.set_xdata(np.arange(len(history_buffer2)))

                        fig.canvas.draw()
                        fig.canvas.flush_events()

                    # Yield blocks
                    if dual_channel:
                        yield block, block2
                    else:
                        yield block

                    # Swap buffers
                    active, standby = standby, active
                    if dual_channel:
                        active2, standby2 = standby2, active2

                except asyncio.TimeoutError:
                    # Graceful stop
                    try:
                        self.dma.recvchannel.stop()
                        if dual_channel:
                            self.dma2.recvchannel.stop()
                    except Exception:
                        pass
                    self.reset_fifo()
                    if auto_restart:
                        await asyncio.sleep(0.01)
                        continue
                    else:
                        raise

        if num_blocks is None:
            async for block in _block_iter():
                yield block
        else:
            blocks = []
            async for block in _block_iter():
                blocks.append(block)
                if len(blocks) >= num_blocks:
                    break
            return blocks

# %%
# Example usage
# overlay = Overlay("your_bitstream.bit")
# capture = DMA_Data_Capture(overlay, ip_name="your_ip", dma_name="axi_dma_0", dma_name2="axi_dma_1")

# async def main():
#     async for ch1, ch2 in capture.stream_blocks(bufsize=4096, timeout=1.0, auto_restart=True,
#                                                 live_plot=True, history_size=16384, dual_channel=True):
#         print("Received block sizes:", len(ch1), len(ch2))
#         if np.random.rand() < 0.05:
#             break
# 
# asyncio.run(main())
