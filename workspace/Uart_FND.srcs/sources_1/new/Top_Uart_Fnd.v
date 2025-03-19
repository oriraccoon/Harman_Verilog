module Top_Uart_Fnd (
    input clk,
    input rst,
    input rx,
    output tx,
    output [7:0] seg,
    output [3:0] an
);
    wire w_rx_done;
    wire [7:0] w_rx_data;

    uart U_UART (
        .clk(clk),
        .rst(rst),
        .btn_start(w_rx_done),
        .tx_data_in(w_rx_data),
        .tx_done(),
        .tx(tx),
        .rx(rx),
        .rx_done(w_rx_done),
        .rx_data(w_rx_data)
    );

    fnd_ctrl U_FND (
        .clk(clk),
        .rst(rst),
        .data(w_rx_data),
        .seg_out(seg),
        .an(an)
    );

endmodule
