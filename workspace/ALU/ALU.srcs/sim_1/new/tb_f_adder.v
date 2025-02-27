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


module tb_f_adder();
    reg a, b, cin;
    wire s, c;
    
    Full_adder u_f_adder(
                         .a(a),
                         .b(b),
                         .cin(cin),
                         .cout(c),
                         .sum(s)
                         
                        );
    
    initial
        begin
            a = 0;
            b = 0;
            
            #10
            a = 1;
            b = 1;
            #10
            a = 0;
            b = 1;
            #10
            a = 1;
            b = 0;
            #10
            $finish;
        end
        
endmodule
