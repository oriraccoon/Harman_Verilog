`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/07 11:03:33
// Design Name: 
// Module Name: test_hz
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


module test_hz();
    reg clk, rst;
    wire [$clog2(10000):0] counter_reg, counter_next;
    wire tick;

    top_module tm(
        .clk(clk),
        .rst(rst),
        .tick(tick),
        .counter_reg(counter_reg),
        .counter_next(counter_next)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        #1 rst = 1;
        #1 rst = 0;
        #42430000 rst = 1;
        #2 rst = 0;

    end

endmodule
