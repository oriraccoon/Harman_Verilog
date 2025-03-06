`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/05 14:36:16
// Design Name: 
// Module Name: FSM
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


module FSM(
            input clk,
            input rst,
            input [2:0] sw,
            output [1:0] led
    );

    parameter [1:0] IDLE = 2'b00, LED01 = 2'b01, LED02 = 2'b10;

    reg [1:0] state, next_state;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            state <= 0;
        end else begin
            state <= next_state;
        end
    end
    always @(*) begin
        case(sw)
            3'b001: begin
                if(state == IDLE) next_state = LED01;
                else next_state = state;
            end
            3'b011: begin
                if(state == LED01) next_state = LED02;
                else next_state = state;
            end
            3'b111: begin
                if(state == LED02) next_state = IDLE;
                else next_state = state;
            end
            3'b110: begin
                if(state == LED02) next_state = LED01;
                else next_state = state;
            end
            default: next_state = state;
        endcase
    end

    LED_onoff lo(
                 .state(next_state),
                 .led(led)
    );

endmodule

module LED_onoff(
                 input [1:0] state,
                 output reg [1:0] led
);
    always@(state) begin
        led = state;
    end
    

endmodule
