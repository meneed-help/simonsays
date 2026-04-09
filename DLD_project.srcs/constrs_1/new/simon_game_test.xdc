## CLOCK 
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## RESET
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

## TOUCH INPUTS

set_property PACKAGE_PIN J1 [get_ports {touch[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[0]}]

set_property PACKAGE_PIN H1 [get_ports {touch[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[1]}]

set_property PACKAGE_PIN H2 [get_ports {touch[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[2]}]

set_property PACKAGE_PIN J2 [get_ports {touch[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[3]}]

set_property PACKAGE_PIN A14 [get_ports {touch[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[4]}]

set_property PACKAGE_PIN A16 [get_ports {touch[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[5]}]

set_property PACKAGE_PIN B15 [get_ports {touch[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[6]}]

set_property PACKAGE_PIN B16 [get_ports {touch[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[7]}]

set_property PACKAGE_PIN K17 [get_ports {touch[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {touch[8]}]

## LED OUTPUTS

set_property PACKAGE_PIN L2 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN K2 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN G3 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN G2 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

set_property PACKAGE_PIN A15 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]

set_property PACKAGE_PIN A17 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]

set_property PACKAGE_PIN C15 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]

set_property PACKAGE_PIN C16 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]

set_property PACKAGE_PIN L17 [get_ports {led[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]

## SEVEN SEGMENT PINS
#a
set_property PACKAGE_PIN W7 [get_ports {seg[0]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

#b
set_property PACKAGE_PIN W6 [get_ports {seg[1]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]

#c
set_property PACKAGE_PIN U8 [get_ports {seg[2]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]

#d
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]

#e
set_property PACKAGE_PIN U5 [get_ports {seg[4]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]

#f
set_property PACKAGE_PIN V5 [get_ports {seg[5]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]

#g
set_property PACKAGE_PIN U7 [get_ports {seg[6]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]



set_property PACKAGE_PIN U2 [get_ports {anode[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {anode[1]}]

set_property PACKAGE_PIN U4 [get_ports {anode[0]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {anode[0]}]

set_property PACKAGE_PIN V4 [get_ports {anode[3]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {anode[3]}]

set_property PACKAGE_PIN W4 [get_ports {anode[2]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {anode[2]}]
