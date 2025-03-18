module tb_uart_fnd();
reg clk, rst, rx;
wire [7:0] seg;


Top_Uart_Fnd dut(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .seg(seg)
);

initial begin
    clk = 0;
    rst = 1;
    rx = 0;
    #10 rst = 0;
    
end


endmodule
