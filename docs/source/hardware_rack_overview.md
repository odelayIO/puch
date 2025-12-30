# Overview

I wanted a clean way to store 3 SDRs, 2 FPGA Boards, and a development computer while enabling easy access to interconnect all the devices together.  The solution is a 10" mini rack from GeekPi.  This way I can connect the SDR to the development computer USB port or the FPGA board (KR260 or PYNQ-Z1).  All ports of the devices are cabled to Keystone patch panel.

<img src="./_static/completed-rack-front.png" alt="image-20251230121444797" style="zoom:75%;" />

## Device Mounting Drawings

All drawings are to size to that were created to help determine if this would be a good solution to my problem.  Below is how all the devices are mounted in the GeekPi 10" mini-rack and how the devices are connected to the front panel.



### Front Panel

Currently I have the bottom half of the rack open to access the computer ports.  Based on how the devices are mounted, the HackRF is showing.

<img src="./_static/drawing-front.png" alt="image-20251230121905721" style="zoom:80%;" />



### Device Mounting - Front View

The PlutoSDR 1 & 2 are zipped tied to the second shelf.  All devices are secured in the mini-rack with zip-ties.

<img src="./_static/drawing-front-device-view.png" alt="image-20251230122643660" style="zoom:80%;" />



### Device Mounting - Side View

I am using the GeekPi 10" Plus, then purchased the GeekPi 10" normal shelfs to provide space (about 1 inch) for routing cables to the Keystone patch panels.

<img src="./_static/drawing-size-device-view.png" alt="image-20251230123013452" style="zoom:80%;" />



## Patch Panel Connection Drawings

### Row 1 Patch Panel Device Connections

<img src="./_static/drawing-patch-panel-1.png" alt="image-20251230123412723" style="zoom:80%;" />



### Row 2 Patch Panel Device Connections

<img src="./_static/drawing-patch-panel-2.png" alt="image-20251230123648208" style="zoom:80%;" />



### Row 3 Patch Panel Device Connections

<img src="./_static/drawing-patch-panel-3.png" alt="image-20251230123801953" style="zoom:80%;" />





## Constructing the *puch* 10" Mini-Rack

Installed the SDRs (3) with development computer and secured the devices using zip-ties.

<img src="./_static/assembly-1.png" alt="image-20251230124157998" style="zoom:67%;" />



More devices installed with some cables:

<img src="./_static/assembly-2.png" alt="image-20251230124416948" style="zoom:67%;" />



Side view:

<img src="./_static/assembly-3.png" alt="image-20251230124526324" style="zoom:67%;" />



Rear view:

<img src="./_static/assembly-4.png" alt="image-20251230124624093" style="zoom:67%;" />



Installed a fan in the computer to ensure the NVMe drive stays cool while in the rack:

<img src="./_static/computer-fan.png" alt="image-20251230123956986" style="zoom:67%;" />



### Keystone Patch Panel Modification

The GeekPi 10 inch Keystone patch panel opening needed to be filed down about 2mm for the Ethernet and USB Keystone jacks to fit.  I didn't think this would take that long, but it took about 4 hours to modify all 36 Keystone openings for the three patch panels.  Though the final product turned out to fit the Ethernet and USB Keystone jacks:

<img src="./_static/front-panel-filing.png" alt="image-20251230120434419" style="zoom:80%;" />

