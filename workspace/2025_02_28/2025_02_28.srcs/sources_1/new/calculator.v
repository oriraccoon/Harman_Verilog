`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/28 15:19:49
// Design Name: 
// Module Name: calculator
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


module calculator(
                    input [3:0] a,
                    input [3:0] b,
                    input [1:0] btn,
                    input cin,
                    //input clk,
                    output overflow,
                    output [7:0] seg,
                    output [3:0] an
                );

    wire [3:0] sum_in;

    Four_bits_adder fba(
                        .a(a),
                        .b(b),
                        .cin(cin),
                        .result(sum_in),
                        .overflow(overflow)
                    );

    fnd_ctrl fc(
                .sum_in(sum_in),
                .btn(btn),
                //.clk(clk),
                .seg_out(seg),
                .an(an)
            );

endmodule
