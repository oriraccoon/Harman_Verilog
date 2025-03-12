`timescale 1ns / 1ps
module tb_watch();
    reg clk, rst;
    wire o_clk;

t100_Hz_divider fs(
            .clk(clk),
            .rst(rst),
            .o_clk(o_clk)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    rst = 0;
    #1 rst = 1;
    #1 rst = 0;

    
    #1000000000
    $finish;
end


endmodule
