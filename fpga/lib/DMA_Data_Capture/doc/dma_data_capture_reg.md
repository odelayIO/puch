# Register map

Created with [Corsair](https://github.com/esynr3z/corsair) vgit-latest.

## Conventions

| Access mode | Description               |
| :---------- | :------------------------ |
| rw          | Read and Write            |
| rw1c        | Read and Write 1 to Clear |
| rw1s        | Read and Write 1 to Set   |
| ro          | Read Only                 |
| roc         | Read Only to Clear        |
| roll        | Read Only / Latch Low     |
| rolh        | Read Only / Latch High    |
| wo          | Write only                |
| wosc        | Write Only / Self Clear   |

## Register map summary

Base address: 0x00000000

| Name                     | Address    | Description |
| :---                     | :---       | :---        |
| [Max_Depth](#max_depth)  | 0x00       | The depth of the capture FIFO |
| [Capture_Length](#capture_length) | 0x04       | The number of samples to capture in buffer |
| [Capture_Stb](#capture_stb) | 0x08       | Capture Strobe, self clearing 1cc strobe |
| [FIFO_Flush](#fifo_flush) | 0x0c       | Flush the FIFO for a new capture trigger |
| [FIFO_WR_Ptr](#fifo_wr_ptr) | 0x10       | FIFO Write Pointer |
| [FIFO_RD_Ptr](#fifo_rd_ptr) | 0x14       | FIFO Read Pointer |

## Max_Depth

The depth of the capture FIFO

Address offset: 0x00

Reset value: 0x00000000

![max_depth](md_img/max_depth.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| len              | 31:0   | ro              | 0x00000000 | The depth of the capture FIFO |

Back to [Register map](#register-map-summary).

## Capture_Length

The number of samples to capture in buffer

Address offset: 0x04

Reset value: 0x00000000

![capture_length](md_img/capture_length.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| len              | 15:0   | rw              | 0x0000     | The start of HLS processor |

Back to [Register map](#register-map-summary).

## Capture_Stb

Capture Strobe, self clearing 1cc strobe

Address offset: 0x08

Reset value: 0x00000000

![capture_stb](md_img/capture_stb.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:1   | -               | 0x0000000  | Reserved |
| cap_stb          | 0      | wosc            | 0x0        | Capture Strobe, self clearing 1cc strobe |

Back to [Register map](#register-map-summary).

## FIFO_Flush

Flush the FIFO for a new capture trigger

Address offset: 0x0c

Reset value: 0x00000000

![fifo_flush](md_img/fifo_flush.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:1   | -               | 0x0000000  | Reserved |
| flush            | 0      | rw              | 0x0        | Flush the FIFO for a new capture trigger |

Back to [Register map](#register-map-summary).

## FIFO_WR_Ptr

FIFO Write Pointer

Address offset: 0x10

Reset value: 0x00000000

![fifo_wr_ptr](md_img/fifo_wr_ptr.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| wr_ptr           | 31:0   | ro              | 0x00000000 | FIFO Write Pointer |

Back to [Register map](#register-map-summary).

## FIFO_RD_Ptr

FIFO Read Pointer

Address offset: 0x14

Reset value: 0x00000000

![fifo_rd_ptr](md_img/fifo_rd_ptr.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| rd_ptr           | 31:0   | ro              | 0x00000000 | FIFO Read Pointer |

Back to [Register map](#register-map-summary).
