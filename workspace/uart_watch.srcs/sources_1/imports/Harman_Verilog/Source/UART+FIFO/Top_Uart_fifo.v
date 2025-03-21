module TOP_UART_FIFO #(
    parameter ADDR_WIDTH = 2, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input rx,
    output tx,
    output [DATA_WIDTH-1:0] tx_data
);
    reg [DATA_WIDTH-1:0] tx_data_in;
    wire rx_done;
    wire tx_empty, rx_empty, tx_full, tx_done;
    wire [DATA_WIDTH-1:0] rx_data;
    wire [DATA_WIDTH-1:0] rdata;
    wire end_flag;

    btn_edge_trigger #(.SET_HZ(52085/8)) U_TX_DEBOUNCE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(tx),
        .o_btn(end_flag)
    );


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

    fifo #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) U_FIFO_TX (
    .clk(clk),
    .rst(rst),
    .wr(!rx_empty),
    .rd(!tx_done),
    .wdata(rdata),
    .rdata(tx_data),
    .empty(tx_empty),
    .full(tx_full)
    );

    fifo #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) U_FIFO_RX (
        .clk(clk),
        .rst(rst),
        .wr(rx_done),
        .rd(!tx_full),
        .wdata(rx_data),
        .rdata(rdata),
        .empty(rx_empty),
        .full()
    );

    always @(posedge clk or posedge rst) begin
        if(rst) tx_data_in = 0;
        else begin
            if(tx_data) tx_data_in = tx_data;
            else tx_data_in = tx_data_in;
        end
    end

endmodule