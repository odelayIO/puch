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
| [F_in](#f_in)            | 0x00       | Input data stream format |
| [F_out](#f_out)          | 0x04       | Output data stream format |
| [AP_Control](#ap_control) | 0x08       | HLS block level control protocol signals |
| [WR_Cap_CTRL](#wr_cap_ctrl) | 0x0c       | QPSK Demodulator write buffer control registers |
| [RD_Cap_CTRL](#rd_cap_ctrl) | 0x10       | QPSK Demodulator read buffer control registers |
| [RD_Cap_DATA](#rd_cap_data) | 0x14       | QPSK Demodulator read buffer data register |

## F_in

Input data stream format

Address offset: 0x00

Reset value: 0x00000000

![f_in](md_img/f_in.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| F_in_fractional  | 31:16  | ro              | 0x0000     | Input data stream format fractional bits |
| F_in_total       | 15:0   | ro              | 0x0000     | Input data stream format total bit width |

Back to [Register map](#register-map-summary).

## F_out

Output data stream format

Address offset: 0x04

Reset value: 0x00000000

![f_out](md_img/f_out.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| F_out_fractional | 31:16  | ro              | 0x0000     | Output data stream format fractional bits |
| F_out_total      | 15:0   | ro              | 0x0000     | Output data stream format total bit width |

Back to [Register map](#register-map-summary).

## AP_Control

HLS block level control protocol signals

Address offset: 0x08

Reset value: 0x00000000

![ap_control](md_img/ap_control.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| ap_idle          | 2      | ro              | 0x0        | HLS ap_idle |
| ap_done          | 1      | ro              | 0x0        | HLS ap_done |
| ap_start         | 0      | rw              | 0x0        | The start of HLS processor |

Back to [Register map](#register-map-summary).

## WR_Cap_CTRL

QPSK Demodulator write buffer control registers

Address offset: 0x0c

Reset value: 0x00000000

![wr_cap_ctrl](md_img/wr_cap_ctrl.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:18  | -               | 0x000      | Reserved |
| wr_addr_clr      | 17     | wosc            | 0x0        | The write address pointer clear.  Strobed for 1 cc, self cleared |
| wr_enable        | 16     | rw              | 0x0        | The write enable to capture output of the QPSK Demodulator |
| wr_addr          | 15:0   | rw              | 0x0000     | The write address pointer.  Value is the number of samples written to BRAM and can reset the pointer |

Back to [Register map](#register-map-summary).

## RD_Cap_CTRL

QPSK Demodulator read buffer control registers

Address offset: 0x10

Reset value: 0x00000000

![rd_cap_ctrl](md_img/rd_cap_ctrl.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:17  | -               | 0x000      | Reserved |
| rd_enable        | 16     | wosc            | 0x0        | The read enable. Strobed for 1cc, self cleared |
| rd_addr          | 15:0   | rw              | 0x0000     | The read address pointer. |

Back to [Register map](#register-map-summary).

## RD_Cap_DATA

QPSK Demodulator read buffer data register

Address offset: 0x14

Reset value: 0x00000000

![rd_cap_data](md_img/rd_cap_data.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| rd_data          | 31:0   | rw              | 0x00000000 | The read data |

Back to [Register map](#register-map-summary).
