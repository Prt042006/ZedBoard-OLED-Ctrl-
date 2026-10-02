`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Prashant
// 
// Create Date: 21.09.2026 21:43:45
// Design Name: 
// Module Name: oled_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module oled_ctrl(
    input clock,
    input reset,
    // oled interface
    output wire oled_spi_clk,
    output wire oled_spi_data,
    output reg oled_vdd,
    output reg oled_vbat,
    output reg oled_reset_n,
    output reg oled_dc_n
    );

reg [4:0] state;
reg startDelay;
//reg spiLoadData;
//reg [7:0] spiData;
reg [4:0]nextState;
wire delayDone;  
//wire spiDone;  
 wire spiDone;
 reg spiLoadData;
 reg [7:0] spiData; 
localparam  IDLE = 'd0,
            DELAY = 'd1,
            INIT = 'd2,
            RESET = 'd3,
            CHARG_PUMP = 'd4,
            CHARG_PUMP1 = 'd5,
            WAIT_SPI = 'd6,
            PRE_CHARG = 'd7,
            PRE_CHARG1 = 'd8,
            VBAT0 = 'd9,
            SET_CONTRAST = 'd10,
            SET_CONTRAST1 = 'd11,
            SEGMENT_REMAP = 'd12,
            SCAN_DIRC = 'd13,
            COM_PIN = 'd14,
            COM_PIN1 = 'd15,
            DISPLAY_ON = 'd16,
            FULL_DISPLAY_ON = 'd17,
            FULL_DISPLAY_ONN = 'd18;
                        
always @(posedge clock)
begin 
    if (reset)
    begin 
        state <= IDLE; 
        nextState <= IDLE;
        oled_vdd <= 1'b1;  
        oled_reset_n <= 1'b1;
        oled_vbat <= 1'b1;
        oled_dc_n <= 1'b1;
        startDelay <= 1'b0;
        spiData <= 8'b0;
        spiLoadData <= 1'b0;
    end
    else 
    begin
        case(state)
            IDLE: begin
                oled_vbat <= 1'b1;
                oled_reset_n <= 1'b1;
                oled_dc_n <= 1'b0;
                oled_vdd <= 1'b0;
                state <= DELAY; 
                nextState <= INIT;
            end
            DELAY: begin
                startDelay <= 1'b1;
                if(delayDone)
                begin 
                    state <= nextState;
                    startDelay <= 1'b0;
                end
            end
            INIT:begin
                spiData <= 'hAE;
                spiLoadData <= 1'b1;
                if (spiDone)
                begin
                    spiLoadData <= 1'b0;
                    oled_reset_n <= 1'b0;
                    state <= DELAY;
                    nextState <= RESET;
                end    
            end
            RESET: begin 
                oled_reset_n <= 1'b1;
                nextState <= CHARG_PUMP;
                state <= DELAY;
            end
            CHARG_PUMP: begin
                spiData <= 8'h8D;
                spiLoadData <= 1'b1;
                if (spiDone)
                begin
                    spiLoadData <= 1'b0;
                    nextState <= CHARG_PUMP1;
                    state <= WAIT_SPI;
                end
            end
            WAIT_SPI: begin
                if (!spiDone)
                begin
                    state <= nextState;
                end      
            end 
            CHARG_PUMP1: begin
                spiData <= 8'h14;
                spiLoadData <= 1'b1;
                if (spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= PRE_CHARG; 
                end
            end
            PRE_CHARG: begin
                spiData <= 8'hD9;
                spiLoadData <= 1'b1;
                if (spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= PRE_CHARG1; 
                end
            end
            PRE_CHARG1: begin
                spiData <= 8'hF1;
                spiLoadData <= 1'b1;
                if (spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= VBAT0; 
                end
            end
            VBAT0: begin 
                oled_vbat <= 1'b0;
                state <= DELAY;
                nextState <= SET_CONTRAST;
            end
            SET_CONTRAST: begin 
                spiData <= 8'h81;
                spiLoadData <= 1'b1;
                if (spiDone)
                begin 
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= SET_CONTRAST1;
                end
            end
            SET_CONTRAST1: begin 
                spiData <= 8'hFF;
                spiLoadData <= 1'b1;
                if (spiDone)
                begin
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= SEGMENT_REMAP;
                end
            end
            SEGMENT_REMAP: begin 
                spiData <= 8'hA1;    //A0
                spiLoadData <= 1'b1;
                if (spiDone)
                begin 
                    spiLoadData <= 1'b0;
                    state <= WAIT_SPI;
                    nextState <= SCAN_DIRC;
                end 
            end
            SCAN_DIRC:  begin 
                spiData <= 8'hC8;    //C0
                spiLoadData <= 1;
                if (spiDone)
                begin 
                    spiLoadData <= 0;
                    state <= WAIT_SPI;
                    nextState <= COM_PIN;
                end
            end
            COM_PIN: begin 
                spiData <= 8'hDA;    
                spiLoadData <= 1;
                if (spiDone)
                begin
                    spiLoadData <= 0;
                    state <= WAIT_SPI;
                    nextState <= COM_PIN1;
                end
            end 
            COM_PIN1: begin
                spiData <= 8'h12;    //00
                spiLoadData <= 1;
                if (spiDone)
                begin
                    spiLoadData <= 0;
                    state <= WAIT_SPI;
                    nextState <= DISPLAY_ON;
                end
            end
            DISPLAY_ON: begin
                spiData <= 8'hAF;
                spiLoadData <= 1;
                if (spiDone)
                begin
                    spiLoadData <= 0;
                    state <= WAIT_SPI;
                    nextState <= FULL_DISPLAY_ONN;
                end
            end
//            FULL_DISPLAY_ON: begin 
//                spiData <= 8'hAF;
//                spiLoadData <= 1;
//                if (spiDone)
//                begin
//                    spiLoadData <= 0;
//                    state <= WAIT_SPI;
//                    nextState <= FULL_DISPLAY_ONN;
//                end
//            end
            FULL_DISPLAY_ONN: begin 
                spiData <= 8'hA5;
                spiLoadData <= 1;
                if (spiDone)
                begin
                    spiLoadData <= 0;
                    state <= WAIT_SPI;
                    nextState <= WAIT_SPI;
                end
            end
        endcase     
    end
end        

delay_gen DG(
    .clock(clock),
    .delayEn(startDelay) ,
    .delayDone(delayDone)
    );
        
spi_ctrl sc (
    .clk(clock), 
    .rst(reset),
    .data_in(spiData),
    .load_data(spiLoadData),
    .done_send(spiDone),
    .spi_clk(oled_spi_clk),
    .spi_data(oled_spi_data )
    );
    
ila_0 ila_inst (
    .clk(clock),

    .probe0(state),
    .probe1(spiData),
    .probe2(spiLoadData),
    .probe3(spiDone),
    .probe4(oled_spi_clk),
    .probe5(oled_spi_data),
    .probe6(oled_dc_n),
    .probe7(oled_reset_n),
    .probe8(oled_vdd),
    .probe9(oled_vbat)
);
    
    
endmodule
