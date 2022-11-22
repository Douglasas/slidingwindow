# sys clock
set_property PACKAGE_PIN Y9 [get_ports i_CLK]

# PMOD A pins
# uart_tx_o -> JA2
set_property PACKAGE_PIN AA11 [get_ports o_UART_TX]
# uart_rx_i -> JA3
set_property PACKAGE_PIN Y10 [get_ports i_UART_RX]

# btn reset
set_property PACKAGE_PIN R16 [get_ports i_BTN_RST]

# set bank voltage
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]]
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]]
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]]
