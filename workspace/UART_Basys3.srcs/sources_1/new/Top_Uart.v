module Top_Uart (
    input clk,
    input rst,
    input btn_start,
    input [7:0] tx_data_in,
    output tx,
    output tx_done
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
        .data_in(tx_data_in),
        .o_tx(tx),
        .tx_done(tx_done)
    );


endmodule
