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
| [User_LEDs](#user_leds)  | 0x0010     | User Leds on KR260 (user_leds[1:0]) |

## User_LEDs

User Leds on KR260 (user_leds[1:0])

Address offset: 0x0010

Reset value: 0x00000000

![user_leds](md_img/user_leds.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:2   | -               | 0x0000000  | Reserved |
| user_leds        | 1:0    | rw              | 0x0        | User LEDs |

Back to [Register map](#register-map-summary).
