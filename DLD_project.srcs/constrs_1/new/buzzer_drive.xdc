## Clock signal (standard Basys 3 clock)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Pmod Header JA - Pin 1 (Buzzer Signal)
set_property PACKAGE_PIN J3 [get_ports {buzzer}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {buzzer}]

## Switch 0 (To turn the sound on and off)
set_property PACKAGE_PIN V17 [get_ports {enable}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enable}]