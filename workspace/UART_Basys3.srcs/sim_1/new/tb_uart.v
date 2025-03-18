module tb_uart();
    reg clk, rst, btn_start;
    wire tx;

Top_Uart DUT(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .tx(tx)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    btn_start = 0;
    #5 rst = 0;
    #30 btn_start = 1;
    #10000 btn_start = 0;
    
    #4000000 btn_start = 1;
    #10000 btn_start = 0;
    #1000000000
    $finish;
end




endmodule
