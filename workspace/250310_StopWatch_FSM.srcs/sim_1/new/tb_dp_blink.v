`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/11 12:58:54
// Design Name: 
// Module Name: tb_dp_blink
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


module tb_dp_blink();
    reg clk, rst;
    wire dp;

    clock_divider_1hz db(
        .clk(clk),
        .rst(rst),
        .o_clk(dp)
    );

    always#1 clk=~clk;

    initial begin
        clk = 0;
        rst = 1;
        #1
        rst = 0;

    end


endmodule
