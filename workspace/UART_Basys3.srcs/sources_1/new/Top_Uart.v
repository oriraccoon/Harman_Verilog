module Top_Uart (
    input  clk,
    input  rst,
    input  btn_start,
    output tx
);

    wire w_tick;
    baud_tick_gen U_BAUD_TICK_GEN (
        .clk(clk),
        .rst(rst),
        .baud_tick(w_tick)
    );

    uart_tx U_UART_TX (
        .clk(clk),
        .rst(rst),
        .tick(w_tick),
        .start_trigger(btn_start),
        .data_in(8'h30),
        .o_tx(tx)
    );


endmodule
