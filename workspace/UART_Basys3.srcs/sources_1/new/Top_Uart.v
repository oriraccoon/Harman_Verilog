module Top_Uart(
    input clk,
    input rst,
    input rx,
    output tx
);

    wire w_rx_done;
    wire [7:0] w_rx_data;

    uart U_uart (
        .clk(clk),
        .rst(rst),
        .btn_start(w_rx_done),
        .rx(rx),
        .tx_data_in(w_rx_data),
        .tx(tx),
        .rx_done(w_rx_done),
        .rx_data_in(w_rx_data)
    );


endmodule
