module TOP_UART_FIFO (
    input clk,
    input rst,
    input rx,
    output tx
);
    wire rx_done;
    wire tx_empty, rx_empty, tx_full, tx_done;
    wire [7:0] rx_data, tx_data;

    reg [7:0] tx_data_in;

    uart U_UART (
        .clk(clk),
        .rst(rst),
        .btn_start(!tx_empty),
        .tx_data(tx_data_in),
        .tx_done(tx_done),
        .tx(tx),
        .rx(rx),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );

    fifo #(.ADDR_WIDTH(4), .DATA_WIDTH(8)) U_FIFO_TX (
    .clk(clk),
    .rst(rst),
    .wr(!rx_empty),
    .rd(!tx_done),
    .wdata(rdata),
    .rdata(tx_data),
    .empty(tx_empty),
    .full(tx_full)
    );

    fifo #(.ADDR_WIDTH(4), .DATA_WIDTH(8)) U_FIFO_RX (
        .clk(clk),
        .rst(rst),
        .wr(rx_done),
        .rd(!tx_full),
        .wdata(rx_data),
        .rdata(rdata),
        .empty(rx_empty),
        .full()
    );

    always @(tx_data) begin
        if(tx_data) tx_data_in = tx_data;
        else tx_data_in = tx_data_in;
    end

endmodule