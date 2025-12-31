# Dual ADALM-PLUTO SDR Setup on Ubuntu

### Deterministic USB Ethernet Naming & Reliable Routing

## Overview

This document explains how to connect **two ADALM-PLUTO SDRs** to a single Ubuntu machine via USB and configure:

- Stable, human-readable interface names:
  - `PlutoSdr1`
  - `PlutoSdr2`
- Reliable IP routing to:
  - Pluto #1 → `192.168.2.1`
  - Pluto #2 → `192.168.2.2`
- A configuration that:
  - Survives reboots
  - Works regardless of USB plug order
  - Is compatible with **libiio, GNU Radio, SoapySDR**

------

## Prerequisites

- Ubuntu (20.04+ recommended)

- Two ADALM-PLUTO SDRs

- Both Plutos configured with:

  ```
  
  ```

- ```
  enable_rndis=y
  enable_ecm=y
  ```

- Unique Pluto IP addresses:

  - Pluto #1 → `192.168.2.1`
  - Pluto #2 → `192.168.2.2`

------

## Step 1 — Identify Pluto USB MAC Addresses

Plug in both Plutos and run:

```

ip link
```

or

```

ifconfig
```

Example output (yours may differ):

```

enx00e022a8479f  ether 00:e0:22:a8:47:9f
enx00e022e4f6c9  ether 00:e0:22:e4:f6:c9
```

Record each MAC address and decide which Pluto is #1 and #2.

Example used below:

| Pluto        | MAC Address       |
| ------------ | ----------------- |
| Pluto SDR #1 | 00:e0:22:a8:47:9f |
| Pluto SDR #2 | 00:e0:22:e4:f6:c9 |

------

## Step 2 — Create Persistent Interface Names (udev)

Create a udev rules file:

```

sudo nano /etc/udev/rules.d/99-pluto-sdr-net.rules
```

Add:

```

SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="00:e0:22:a8:47:9f", NAME="PlutoSdr1"
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="00:e0:22:e4:f6:c9", NAME="PlutoSdr2"
```

Save and exit.

Reload udev and re-enumerate devices:

```

sudo udevadm control --reload-rules
sudo udevadm trigger
```

Unplug and re-plug both Plutos.

Verify:

```

ip link
```

Expected:

```

PlutoSdr1
PlutoSdr2
```

------

## Step 3 — Clear Existing IP Configuration

Flush any automatically assigned IP addresses:

```

sudo ip addr flush dev PlutoSdr1
sudo ip addr flush dev PlutoSdr2
```

Bring interfaces up:

```

sudo ip link set PlutoSdr1 up
sudo ip link set PlutoSdr2 up
```

------

## Step 4 — Create NetworkManager Connections

List existing connections:

```

nmcli connection show
```

Delete any auto-generated “Wired connection” profiles associated with the Plutos:

```

nmcli connection delete "Wired connection 1"
nmcli connection delete "Wired connection 2"
```

(Create/delete only the ones tied to the Pluto interfaces.)

Create new connections bound to the renamed interfaces:

```

nmcli connection add type ethernet ifname PlutoSdr1 con-name PlutoSdr1
nmcli connection add type ethernet ifname PlutoSdr2 con-name PlutoSdr2
```

------

## Step 5 — Configure Persistent Routing (CRITICAL)

Each Pluto is a **separate point-to-point USB link**.
 We must route traffic to each Pluto explicitly.

### Disable default routing

```

nmcli connection modify PlutoSdr1 ipv4.never-default yes
nmcli connection modify PlutoSdr2 ipv4.never-default yes
```

### Clear automatic IPv4 addresses

```

nmcli connection modify PlutoSdr1 ipv4.method manual ipv4.addresses ""
nmcli connection modify PlutoSdr2 ipv4.method manual ipv4.addresses ""
```

### Add host-specific routes

```

nmcli connection modify PlutoSdr1 +ipv4.routes "192.168.2.1/32"
nmcli connection modify PlutoSdr2 +ipv4.routes "192.168.2.2/32"
```

Bring the connections up:

```

nmcli connection down PlutoSdr1
nmcli connection down PlutoSdr2
nmcli connection up PlutoSdr1
nmcli connection up PlutoSdr2
```

------

## Step 6 — Verify Routing and Connectivity

Check routes:

```

ip route
```

Expected output:

```

192.168.2.1 dev PlutoSdr1 scope link
192.168.2.2 dev PlutoSdr2 scope link
```

Ping both Plutos:

```

ping 192.168.2.1
ping 192.168.2.2
```

Both should respond.

------

## Step 7 — Use with libiio / GNU Radio

Nothing special is required — access each Pluto by IP:

```

iio_info -u ip:192.168.2.1
iio_info -u ip:192.168.2.2
```

GNU Radio and SoapySDR will work normally with these IPs.

------

## Final State Summary

| Component           | Result                       |
| ------------------- | ---------------------------- |
| Interface names     | `PlutoSdr1`, `PlutoSdr2`     |
| Pluto IPs           | `192.168.2.1`, `192.168.2.2` |
| Routing             | Host-specific, deterministic |
| Reboot safe         | Yes                          |
| USB order dependent | No                           |

------

## Notes & Best Practices

- Physically label each Pluto to match its IP
- Do **not** use a shared `/24` route for multiple Plutos
- Avoid bridging the USB interfaces
- This configuration is optimal for:
  - Dual-RX
  - Dual-TX
  - TX on one Pluto / RX on the other

------