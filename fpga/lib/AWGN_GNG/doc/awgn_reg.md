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
| [F_awgn](#f_awgn)        | 0x08       | Output AWGN data stream format |
| [awgn_noise_gain](#awgn_noise_gain) | 0x0c       | AWGN Noise Gain |

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

## F_awgn

Output AWGN data stream format

Address offset: 0x08

Reset value: 0x00000000

![f_awgn](md_img/f_awgn.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| F_awgn_fractional | 31:16  | ro              | 0x0000     | Output AWGN data stream format fractional bits |
| F_awgn_total     | 15:0   | ro              | 0x0000     | Output AWGN data stream format total bit width |

Back to [Register map](#register-map-summary).

## awgn_noise_gain

AWGN Noise Gain

Address offset: 0x0c

Reset value: 0x00000000

![awgn_noise_gain](md_img/awgn_noise_gain.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| awgn_noise_gain  | 15:0   | rw              | 0x0000     | AWGN Noise Gain, same format as AWGN |

Back to [Register map](#register-map-summary).
