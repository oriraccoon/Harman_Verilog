`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/04 14:44:36
// Design Name: 
// Module Name: tb_clkbcd
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


module tb_clkbcd();
    reg cin, clk, rst;
    reg [7:0] a, b;
    wire [7:0] seg;
    wire [3:0] an;

    calculator DUT(
                .a(a),
                .b(b),
                .cin(cin),
                .clk(clk),
                .rst(rst),
                .seg(seg),
                .an(an)
                );

    initial begin
        clk = 0;
        rst = 0;

        #999988
        a = 255;
        b = 255;
        #999988
        b = 128;
        #999988
        b = 1;
        #999988
        a = 32;
        #999988
        $finish;


    end

    always #1 clk = ~clk;



endmodule
