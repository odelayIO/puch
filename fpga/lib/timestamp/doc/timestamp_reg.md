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
| [Time_Stamp_Year](#time_stamp_year) | 0x0010     | Time Stamp Year (Hex Value) |
| [Time_Stamp_Month](#time_stamp_month) | 0x0014     | Time Stamp Month (Hex Value) |
| [Time_Stamp_Day](#time_stamp_day) | 0x0018     | Time Stamp Day (Hex Value) |
| [Time_Stamp_Hour](#time_stamp_hour) | 0x001c     | Time Stamp Hour (Hex Value) |
| [Time_Stamp_Minute](#time_stamp_minute) | 0x0020     | Time Stamp Minute (Hex Value) |
| [Time_Stamp_Seconds](#time_stamp_seconds) | 0x0024     | Time Stamp Seconds (Hex Value) |

## Time_Stamp_Year

Time Stamp Year (Hex Value)

Address offset: 0x0010

Reset value: 0x00000000

![time_stamp_year](md_img/time_stamp_year.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| ts_year          | 15:0   | ro              | 0x0000     | Time Stamp Year (Hex Value) |

Back to [Register map](#register-map-summary).

## Time_Stamp_Month

Time Stamp Month (Hex Value)

Address offset: 0x0014

Reset value: 0x00000000

![time_stamp_month](md_img/time_stamp_month.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| ts_month         | 7:0    | ro              | 0x00       | Time Stamp Month (Hex Value) |

Back to [Register map](#register-map-summary).

## Time_Stamp_Day

Time Stamp Day (Hex Value)

Address offset: 0x0018

Reset value: 0x00000000

![time_stamp_day](md_img/time_stamp_day.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| ts_day           | 7:0    | ro              | 0x00       | Time Stamp Day (Hex Value) |

Back to [Register map](#register-map-summary).

## Time_Stamp_Hour

Time Stamp Hour (Hex Value)

Address offset: 0x001c

Reset value: 0x00000000

![time_stamp_hour](md_img/time_stamp_hour.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| ts_hour          | 7:0    | ro              | 0x00       | Time Stamp Hour (Hex Value) |

Back to [Register map](#register-map-summary).

## Time_Stamp_Minute

Time Stamp Minute (Hex Value)

Address offset: 0x0020

Reset value: 0x00000000

![time_stamp_minute](md_img/time_stamp_minute.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| ts_min           | 7:0    | ro              | 0x00       | Time Stamp Minute (Hex Value) |

Back to [Register map](#register-map-summary).

## Time_Stamp_Seconds

Time Stamp Seconds (Hex Value)

Address offset: 0x0024

Reset value: 0x00000000

![time_stamp_seconds](md_img/time_stamp_seconds.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| ts_sec           | 7:0    | ro              | 0x00       | Time Stamp Seconds (Hex Value) |

Back to [Register map](#register-map-summary).
