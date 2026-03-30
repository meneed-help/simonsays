## Clock (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Reset button (BTNC)
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## Touch sensor input (J1)
set_property PACKAGE_PIN J1 [get_ports touch_in]
set_property IOSTANDARD LVCMOS33 [get_ports touch_in]

## LED output (L2)
set_property PACKAGE_PIN L2 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]