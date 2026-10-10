implementing an OLED controller for the ZedBoard (Zynq-7000, XC7Z020-CLG484-1) using Verilog in Vivado. My design consists of three modules: "oled_ctrl" (the main FSM), "spi_ctrl" (SPI communication), and "delay_gen" (delay generation).

The main FSM has 18 states to initialize the OLED, including sending commands such as "0xAE", "0x8D", "0x14", "0xD9", "0x81", "0xA1", "0xC8", "0xDA", "0xAF", and "0xA5". The goal is to initialize the OLED and turn all its pixels on.

The problem:

- Behavioral simulation works correctly, and the FSM transitions through all 18 states as expected.
- However, post-synthesis functional simulation does not behave as expected.
- The "oled_spi_clk" and "oled_spi_data" output ports appear to be stuck at their default values instead of toggling and transmitting data.
- The synthesized design schematic shows these output ports connected through output buffers ("OBUF"), but I am unsure why the expected SPI activity is missing.
- I have attached screenshots of the synthesized schematic and post-synthesis simulation waveforms and git repository for reference.

What I have tried: I inspected the synthesized schematic and monitored the FSM state and output signals in the post-synthesis simulation. The behavior still differs from the behavioral simulation.

My questions:

1. What are the common reasons why a design works in behavioral simulation but fails in post-synthesis functional simulation?
2. Could the issue be related to clock generation, multiple procedural drivers, reset handling, or optimization during synthesis?
3. How can I debug why "oled_spi_clk" and "oled_spi_data" remain constant in the post-synthesis simulation?
4. Are there any specific Vivado settings, timing considerations, or RTL coding practices I should check?

Any suggestions, debugging steps, or similar experiences would be greatly appreciated. Thank you!
