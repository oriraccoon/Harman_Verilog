`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/05 15:09:08
// Design Name: 
// Module Name: FSM_LED
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


module FSM_LED(
                input clk,
                input rst,
                input [2:0] sw,
                output [1:0] led
    );

FSM FSM(
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .led(led)
);



endmodule
