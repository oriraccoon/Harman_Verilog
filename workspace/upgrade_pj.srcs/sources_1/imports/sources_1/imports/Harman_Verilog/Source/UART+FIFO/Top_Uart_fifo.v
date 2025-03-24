module TOP_UART_FIFO #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input rx,
    input [3:0] w_sec_digit_1, w_sec_digit_10, w_min_digit_1, w_min_digit_10, w_hour_digit_1, w_hour_digit_10,
    input [3:0] o_command,
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
    wire [7:0] time_data [0:11];
    reg out_com;
    reg i;
    reg [DATA_WIDTH-1:0] time_data_reg;

    assign time_data[0] = "/r";
    assign time_data[1] = "/n";
    assign time_data[2] = w_sec_digit_1 + 8'h30;
    assign time_data[3] = w_sec_digit_10 + 8'h30;
    assign time_data[4] = ":";
    assign time_data[5] = w_min_digit_1 + 8'h30;
    assign time_data[6] = w_min_digit_10 + 8'h30;
    assign time_data[7] = ":";
    assign time_data[8] = w_hour_digit_1 + 8'h30;
    assign time_data[9] = w_hour_digit_10 + 8'h30;
    assign time_data[10] = "/r";
    assign time_data[11] = "/n";

assign s_trigger = !tx_empty & ~tx_done;
always @(*) begin
    out_com = o_command == 7 & !tx_done & tx_empty ? 1:0;
    if(out_com) begin
        time_data_reg = time_data[i];
        if(i == 11) begin
            i = 0;
            out_com = 0;
        end
        else i = i + 1;
    end
end
//assign rx_data = time_data_reg & rx_data;

    btn_edge_trigger #(.SET_HZ(3000)) U_TX_DEBOUNCE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(!tx_done),
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