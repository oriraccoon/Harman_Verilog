`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/27 15:27:17
// Design Name: 
// Module Name: tb_adder
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


module tb_4bits_adder();
    reg [0:3] a, b;
    wire [0:4] s;
    integer i;
    
    four_bits_adder dut(
                         .a(a),
                         .b(b),
                         .result(s)
                        );

    initial
        begin
            a = 0;
            b = 0;
            
        for (i = 0; i < 8; i = i + 1)
        begin
            #100;
            a = a + 4'b0001;
            #100;
            b = b + 4'b0001;
        end

            #100
            $finish;
        end
        
endmodule
