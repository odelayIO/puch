######################## LEDs Pinout ########################

set_property PACKAGE_PIN F8 [get_ports {user_leds[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {user_leds[0]}]
set_output_delay -clock [get_clocks clk_pl_0] -min 0.364 [get_ports {user_leds[0]}]
set_output_delay -clock [get_clocks clk_pl_0] -max 0.445 [get_ports {user_leds[0]}]


set_property PACKAGE_PIN E8 [get_ports {user_leds[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {user_leds[1]}]
set_output_delay -clock [get_clocks clk_pl_0] -min 0.364 [get_ports {user_leds[1]}]
set_output_delay -clock [get_clocks clk_pl_0] -max 0.445 [get_ports {user_leds[1]}]

