module tb_rx();
    reg clk, rst, rx;
    wire [7:0] data_in;
    wire rx_done;
    wire w_tick;

baud_tick_gen U_BAUD_TICK_GEN (
    .clk(clk),
    .rst(rst),
    .baud_tick(w_tick)
);
uart_rx dut(
    .clk(clk),
    .rst(rst),
    .tick(w_tick),
    .rx(rx),
    .data_in(data_in),
    .rx_done(rx_done)
    );


initial begin
    clk = 0;
    rst = 1;
    rx = 0;
    #10 rst = 0;
    
end

endmodule
