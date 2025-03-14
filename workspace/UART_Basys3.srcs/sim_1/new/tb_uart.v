module tb_uart();
    reg clk, rst, btn_start;
    wire tx;

send_tx_btn DUT(
    .clk(clk),
    .rst(rst),
    .btn_start(btn_start),
    .tx(tx)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    btn_start = 0;
    #5 rst = 0;
    #30 btn_start = 1;
    #3000000 btn_start = 0;
    #3000000 btn_start = 1;
    #3000000 btn_start = 0;
    
    #100000000
    $finish;
end




endmodule
