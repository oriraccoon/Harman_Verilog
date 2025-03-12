`timescale 1ns / 1ps

module blocktest();
    reg clk, a, b, c, d;

    initial begin
        clk = 0;
        a = 0;
        b = 1;
        c = 0;
        d = 1;
    end

    always #1 clk = ~clk;

    // nonblocking
    always@(posedge clk) begin
        a <= 1;
        b <= a;
    end

    // blocking
    always @(posedge clk) begin
        c = 1;
        d = c;
        
    end




endmodule
