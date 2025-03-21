module TOP_UART_FIFO #(
    parameter ADDR_WIDTH = 2, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input rx,
    output tx,
    output s_trigger,
    output [DATA_WIDTH-1:0] tx_data
);
    wire rx_done;
    wire rx_empty;
    wire tx_empty, tx_full, tx_done;
    wire [DATA_WIDTH-1:0] rx_data;
    wire [DATA_WIDTH-1:0] rdata;
    reg [DATA_WIDTH-1:0] tx_data_in;
    wire end_flag;

assign s_trigger = !tx_empty & ~tx_done;

    btn_edge_trigger #(.SET_HZ(3000)) U_TX_DEBOUNCE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(tx),
        .o_btn(end_flag)
    );


    uart U_UART (
        .clk(clk),
        .rst(rst),
        .btn_start(!tx_empty & ~tx_done),
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
    .w_en(!rx_empty),
    .r_en(!tx_done),
    .w_data(rdata),
    .r_data(tx_data),
    .empty(tx_empty),
    .full(tx_full)
    );

    fifo #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) U_FIFO_RX (
        .clk(clk),
        .rst(rst),
        .w_en(rx_done),
        .r_en(!tx_full),
        .w_data(rx_data),
        .r_data(rdata),
        .empty(rx_empty),
        .full()
    );

    always @(posedge clk or posedge rst) begin
        if(rst) tx_data_in = 0;
        else begin
            if(!tx_empty) tx_data_in = tx_data;
            else tx_data_in = tx_data_in;
        end
    end

endmodule