`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25 11:12:07
// Design Name: 
// Module Name: tb_HC_SR04
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


module tb_HC_SR04 ();
reg clk, echo;


myHC_SR04 dut(
    .clk(clk),
    .echo(echo),
    .trig(trig)
    // .distance(distance)
    );

    always #1 clk = ~clk;
endmodule
