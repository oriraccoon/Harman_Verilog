`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/27 15:04:37
// Design Name: 
// Module Name: Full_adder
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


module Full_adder(
                  input a,
                  input b,
                  input cin,
                  output cout,
                  output sum
                );
                
    wire half_s1, half_s2, half_c1, half_c2;
    
    half_adder ha1(
                   .a(a),
                   .b(b),
                   .s(half_s1),
                   .c(half_c1)
                  );
    half_adder ha2(
                   .a(half_s1),
                   .b(cin),
                   .s(half_s2),
                   .c(half_c2)
                  );
    
    assign sum = half_s2;
    assign cout = half_c2 | half_c1;
    
endmodule
