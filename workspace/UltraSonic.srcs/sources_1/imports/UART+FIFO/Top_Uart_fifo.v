module TOP_UART_FIFO #(
    parameter ADDR_WIDTH = 10, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input rx,
    input [3:0] w_sec_digit_1, w_sec_digit_10, w_min_digit_1, w_min_digit_10, w_hour_digit_1, w_hour_digit_10,
    input [3:0] o_command,
    input [$clog2(400)-1:0] distance,
    output tx,
    output s_trigger,
    output tick,
    output [DATA_WIDTH-1:0] tx_data
);
    wire rx_done;
    wire rx_empty;
    wire tx_empty, tx_full, tx_done;
    wire [DATA_WIDTH-1:0] rx_data;
    wire [DATA_WIDTH-1:0] rdata;
    reg [DATA_WIDTH-1:0] tx_data_in;
    wire end_flag;
    reg out_centi = 0;
    wire [7:0] time_data [0:11];
    wire [7:0] Ultra_data [0:3];
    reg out_com;

    reg [3:0] i;
    reg [$clog2(161)-1:0] tick_cont;

initial begin
    i = 0;
    out_com = 0;
    tick_cont = 0;
end
    assign time_data[0] = "\r";
    assign time_data[1] = "\n";
    assign time_data[2] = w_hour_digit_10 + 8'h30;
    assign time_data[3] = w_hour_digit_1 + 8'h30;
    assign time_data[4] = ":";
    assign time_data[5] = w_min_digit_10 + 8'h30;
    assign time_data[6] = w_min_digit_1 + 8'h30;
    assign time_data[7] = ":";
    assign time_data[8] = w_sec_digit_10 + 8'h30;
    assign time_data[9] = w_sec_digit_1 + 8'h30;
    assign time_data[10] = "\r";
    assign time_data[11] = "\n";

    
assign s_trigger = !tx_empty & ~tx_done;

    digit_spliter2 #(.WIDTH(16)) s_split(
        .bcd(distance),
        .digit({Ultra_data[0], Ultra_data[1], Ultra_data[2], Ultra_data[3]})
    );

    btn_edge_trigger #(.SET_HZ(3000)) U_TX_DEBOUNCE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(!tx_done),
        .o_btn(end_flag)
    );


    uart U_UART (
        .clk(clk),
        .rst(rst),
        .btn_start((!tx_empty & ~tx_done)|out_com),
        .tx_data(tx_data_in),
        .tx_done(tx_done),
        .tx(tx),
        .rx(rx),
        .rx_done(rx_done),
        .rx_data(rx_data),
        .tick(tick)
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
            out_com = o_command == 7 & !tx_done & tx_empty ? 1:out_com;
            //out_centi = o_command == 8 & !tx_done & tx_empty ? 1:out_centi;
            if(out_com) begin
                if(tick) tick_cont = tick_cont + 1;

                if(tick_cont == 161) begin
                    if(!tx_done) begin
                        tx_data_in = time_data[i];
                        tick_cont = 0;
                        if(i == 11) begin
                            i = 0;
                            out_com = 0;
                        end
                        else i = i + 1;
                    end
                end
            end else if(out_centi) begin
                if(tick) tick_cont = tick_cont + 1;

                if(tick_cont == 161) begin

                    if(!tx_done) begin
                        tx_data_in = Ultra_data[i];
                        tick_cont = 0;
                        if(i == 3) begin
                            i = 0;
                            out_com = 0;
                        end
                        else i = i + 1;
                    end
                end
            end
            else if(!tx_empty) tx_data_in = tx_data;
            else tx_data_in = tx_data_in;
        end
    end


endmodule