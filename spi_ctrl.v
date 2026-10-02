`timescale 1ns / 1ps

module spi_ctrl(
    input clk, rst,
    input [7:0] data_in,
    input load_data,
    output reg done_send,
    output spi_clk,
    output reg spi_data
    );
    reg [2:0]count;
    reg [2:0]datacount;
    reg [7:0]shift_reg;
    reg clk_10;
    reg CE;
 //   (* KEEP = "TRUE"*)
    reg [1:0]STATE;
    localparam  IDLE ='d0,
                SEND ='d1,
                DONE ='d3;
    assign spi_clk = (CE == 1) ? clk_10 : 1'b1; 
    
    always @(posedge clk)
    begin 
        if (count!=4)
            count<=count+1;
        else 
            count<=0;
    end 
    
    
    initial 
        clk_10<=0;
        
        
    always @(posedge clk)
    begin 
        if (count==4)
            clk_10<=~clk_10;            
    end 
    always @(negedge clk_10)begin
        if (rst)begin 
            STATE <= IDLE;
            count <= 0;
            clk_10 <= 0;
            datacount <=0;
            done_send<=1'b0;
            CE<=0;
            spi_data<=0;
            shift_reg<=0; 
        end
        else begin
            case(STATE)
            IDLE: begin
                if (load_data) begin
                    shift_reg <= data_in;
                    STATE <= SEND;
                    datacount <=0;
                end
            end
                
            SEND: begin
                spi_data <=shift_reg[7];
                shift_reg <={shift_reg[6:0],1'b0};
                CE<=1;
                if(datacount!=7) begin
                    datacount<=datacount+1;
                end
                else
                    STATE<=DONE;
            end
            DONE:begin
                done_send<=1'b1;
                CE<=0; 
                if(!load_data)
                begin
                    done_send<=1'b0;
                    STATE<=IDLE;
                end
            end
            endcase
        end
    end
endmodule
