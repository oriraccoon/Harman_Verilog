`timescale 1ns / 1ps

module gates(
             input a,
             input b,
             output wire [0:6] y
            );
            
    assign y[0] = a & b;
    assign y[1] = ~(a & b);
    assign y[2] = a | b;
    assign y[3] = ~(a | b);
    assign y[4] = a ^ b;
    assign y[5] = ~(a ^ b);
    assign y[6] = ~a;
            
endmodule
