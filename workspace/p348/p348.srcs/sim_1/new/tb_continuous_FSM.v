`timescale 1ns / 1ps
module tb_continuous_FSM();
    reg clk, rst, sw;
    wire o_sign;

continuous_FSM cF(
                    .clk(clk),
                    .rst(rst),
                    .sw(sw),
                    .o_sign(o_sign)
);

    initial begin
        clk = 0;
        rst = 0;
        sw = 0;

        #40
        sw = 1;
        #60
        sw = 0;
        #20
        sw = 1;
        #40
        sw = 0;
        #80
        sw = 1;
        #20
        sw = 0;
        #50
        sw = 1;
        #80
        sw = 0;
        #50
        $finish;
    end

    always #10 clk = ~clk;

endmodule
