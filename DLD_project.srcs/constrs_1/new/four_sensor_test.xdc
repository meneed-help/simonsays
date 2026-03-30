## Clock
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset (BTNC)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Touch Inputs
set_property PACKAGE_PIN J1 [get_ports touch_in[0]]
set_property IOSTANDARD LVCMOS33 [get_ports touch_in[0]]

set_property PACKAGE_PIN H1 [get_ports touch_in[1]]
set_property IOSTANDARD LVCMOS33 [get_ports touch_in[1]]

set_property PACKAGE_PIN H2 [get_ports touch_in[2]]
set_property IOSTANDARD LVCMOS33 [get_ports touch_in[2]]

set_property PACKAGE_PIN J2 [get_ports touch_in[3]]
set_property IOSTANDARD LVCMOS33 [get_ports touch_in[3]]

## LEDs
set_property PACKAGE_PIN L2 [get_ports led[0]]
set_property IOSTANDARD LVCMOS33 [get_ports led[0]]

set_property PACKAGE_PIN K2 [get_ports led[1]]
set_property IOSTANDARD LVCMOS33 [get_ports led[1]]

set_property PACKAGE_PIN G3 [get_ports led[2]]
set_property IOSTANDARD LVCMOS33 [get_ports led[2]]

set_property PACKAGE_PIN G2 [get_ports led[3]]
set_property IOSTANDARD LVCMOS33 [get_ports led[3]]