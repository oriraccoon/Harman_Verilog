`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/10 14:30:16
// Design Name: 
// Module Name: tb_stopwatch_dp
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


module tb_stopwatch_dp();
    reg clk, rst, w_run, w_clear;
    wire [6:0] ms;
    wire [5:0] s, m;
    wire [4:0] h;


stopwatch_dp sd(
                    .clk(clk),
                    .rst(rst),
                    .i_btn_run(w_run),
                    .i_btn_clear(w_clear),
                    .ms_counter(ms),
                    .s_counter(s),
                    .m_counter(m),
                    .h_counter(h)
);

always #1 clk=~clk;

initial begin
    clk = 0;
    rst = 1;
    w_run = 0;
    w_clear = 0;
    #1 rst = 0;
    #20 w_run = 1;
    #100000000 w_clear = 1;
    #10 w_clear = 0;
    #10 w_run = 0;
    #10
    $finish;

end


endmodule
