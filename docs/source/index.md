# ReadTheDocs Sphinx + Markdown Template

Welcome — this documentation uses Sphinx with MyST so pages are written in Markdown.

## Contents

This site uses a Sphinx toctree so the ReadTheDocs theme can build a sidebar and
show "Previous/Next" links on pages.

```{toctree}
:maxdepth: 2
:caption: Contents

overview.md
KR260-New-Board-Bring-up.md
building_fpga.md
gnuradio_fpga_module.md
```

```{toctree}
:maxdepth: 2
:caption: Hardware Rack

hardware_rack_overview.md
hardware_rack_inventory.md
hardware_rack_future.md
```
