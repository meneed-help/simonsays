## ================= CLOCK =================
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ================= RESET =================
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## ================= TOUCH INPUTS =================
## (connected to your TTP223-B sensors)

set_property PACKAGE_PIN J1 [get_ports {touch[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[0]}]

set_property PACKAGE_PIN H1 [get_ports {touch[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[1]}]

set_property PACKAGE_PIN H2 [get_ports {touch[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[2]}]

set_property PACKAGE_PIN J2 [get_ports {touch[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[3]}]

## ================= LED OUTPUTS =================

set_property PACKAGE_PIN L2 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN K2 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN G3 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN G2 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]