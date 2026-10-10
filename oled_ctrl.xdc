## ==============================================================================
## Clock Constraint (ZedBoard 100 MHz Oscillator on Pin Y9)
## ==============================================================================
#set_property PACKAGE_PIN Y9 [get_ports clock]
#set_property IOSTANDARD LVCMOS33 [get_ports clock]

## Define 100 MHz clock (10 ns period)
##create_clock -period 10.000 -name clock -waveform(0.000 5.000) clock
##create_clock -period 10.000 -name sys_clk_pin [get_ports clock]
#create_clock -period 10.000 -name sys_clk_pin \
#    -waveform {0.000 5.000} [get_ports clock]
## ==============================================================================
## Reset Constraint (ZedBoard Center Push Button - BTNC)
## ==============================================================================
#set_property PACKAGE_PIN P16 [get_ports reset]
#set_property IOSTANDARD LVCMOS33 [get_ports reset]

## ==============================================================================
## ZedBoard On-Board OLED Physical Interface Pins (128x32 SSD1306)
## ==============================================================================

## OLED SPI Clock (SCLK) -> Pin U10
#set_property PACKAGE_PIN U10 [get_ports oled_dc_n]
#set_property IOSTANDARD LVCMOS33 [get_ports oled_dc_n]

## OLED SPI Data (SDIN) -> Pin U9
#set_property PACKAGE_PIN U9 [get_ports oled_reset_n]
#set_property IOSTANDARD LVCMOS33 [get_ports oled_reset_n]

## OLED VDD Power Enable (Active LOW) -> Pin U12
#set_property PACKAGE_PIN U12 [get_ports oled_vdd]
#set_property IOSTANDARD LVCMOS33 [get_ports oled_vdd]

## OLED VBAT Power Enable (Active LOW) -> Pin U11
#set_property PACKAGE_PIN U11 [get_ports oled_vbat]
#set_property IOSTANDARD LVCMOS33 [get_ports oled_vbat]

## OLED Reset (Active LOW - RES#) -> Pin AB12
#set_property PACKAGE_PIN AB12 [get_ports oled_spi_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_clk]

## OLED Data/Command Select (D/C#) -> Pin U10... Wait: Pin U10 is SCLK. D/C# is Pin U11?
## Let's verify standard ZedBoard Pinout:
## Pin U10 -> OLED-RES
## Pin U9  -> OLED-SDIN
## Pin U12 -> OLED-VDD
## Pin U11 -> OLED-VBAT
## Pin AB12 -> oled_spi_clk
## Pin U10 is NOT D/C. D/C is Pin U10/U9? Pin U10 is SCLK, Pin U9 SDIN.
## Pin AA12 -> OLED-D/C
#set_property PACKAGE_PIN AA12 [get_ports oled_spi_data]
#set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_data]

## ==============================================================================
## Output Drive Strength and Slew Rate (Recommended for SPI Integrity)
## ==============================================================================
#set_property DRIVE 8 [get_ports {oled_spi_clk oled_spi_data oled_vdd oled_vbat oled_reset_n oled_dc_n}]
#set_property SLEW SLOW [get_ports {oled_spi_clk oled_spi_data oled_vdd oled_vbat oled_reset_n oled_dc_n}]

##set_input_delay -clock [get_clocks sys_clk_pin] -max 3.000 [get_ports reset] 
##set_input_delay -clock [get_clocks sys_clk_pin] -min 3.000 [get_ports reset] 
##set_output_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {oled_dc_n oled_reset_n oled_vdd oled_vbat}] 
##set_output_delay -clock [get_clocks sys_clk_pin] -min -0.500 [get_ports {oled_dc_n oled_reset_n oled_vdd oled_vbat}]

##set_false_path -from [get_ports reset]
##set_false_path -to [get_ports {oled_dc_n oled_reset_n oled_vbat oled_vdd}]



##################################################################################################################################

###     Final  Constraints 

set_property PACKAGE_PIN Y9 [get_ports clock]
set_property IOSTANDARD LVCMOS18 [get_ports clock]
set_property PACKAGE_PIN U10 [get_ports oled_dc_n]
set_property PACKAGE_PIN U9 [get_ports oled_reset_n]
set_property PACKAGE_PIN AB12 [get_ports oled_spi_clk]
set_property PACKAGE_PIN AA12 [get_ports oled_spi_data]
set_property PACKAGE_PIN U11 [get_ports oled_vbat]
set_property PACKAGE_PIN U12 [get_ports oled_vdd]
set_property PACKAGE_PIN P16 [get_ports reset]
set_property IOSTANDARD LVCMOS18 [get_ports oled_dc_n]
set_property IOSTANDARD LVCMOS18 [get_ports oled_reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports oled_spi_clk]
set_property IOSTANDARD LVCMOS18 [get_ports oled_spi_data]
set_property IOSTANDARD LVCMOS18 [get_ports oled_vbat]
set_property IOSTANDARD LVCMOS18 [get_ports oled_vdd]
set_property IOSTANDARD LVCMOS18 [get_ports reset]
create_clock -period 10.000 -name clock -waveform {0.000 5.000} clock
