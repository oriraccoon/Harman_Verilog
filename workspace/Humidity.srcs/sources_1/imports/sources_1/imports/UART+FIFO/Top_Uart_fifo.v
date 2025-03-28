module TOP_UART_FIFO #(
    parameter ADDR_WIDTH = 10, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input rx,
    input [3:0] w_sec_digit_1, w_sec_digit_10, w_min_digit_1, w_min_digit_10, w_hour_digit_1, w_hour_digit_10,
    input [3:0] o_command,
    input [$clog2(400)-1:0] distance,
    input [15:0] humidity_data,
    input [15:0] temperature_data,
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
    reg out_centi;
    reg out_hum, out_temp;

    // ------------------------------------------------------------------------
    // 얘네들 이렇게 안하고 문자 배열 만들어서 하면 더 편하고 예쁜 코드가 될 듯
    // ------------------------------------------------------------------------
 

    // ------------------------------------------------------------------------
    // Ultra data
    // ------------------------------------------------------------------------
    wire [7:0] ultra_shoot [0:8];
    wire [3:0] Ultra_data [0:2];

    assign ultra_shoot[0] = "\r";
    assign ultra_shoot[1] = "\n";
    assign ultra_shoot[2] = Ultra_data[0] + 8'h30;
    assign ultra_shoot[3] = Ultra_data[1] + 8'h30;
    assign ultra_shoot[4] = Ultra_data[2] + 8'h30;
    assign ultra_shoot[5] = "c";
    assign ultra_shoot[6] = "m";
    assign ultra_shoot[7] = "\r";
    assign ultra_shoot[8] = "\n";


    digit_spliter2 #(.WIDTH(9)) s_split(
        .bcd(distance),
        .digit({Ultra_data[0], Ultra_data[1], Ultra_data[2]})
    );
    
    // ------------------------------------------------------------------------
    // Humidity & Temperature data
    // ------------------------------------------------------------------------

    wire [7:0] hum_integral, hum_decimal, temp_integral, temp_decimal;
    wire [7:0] humtemp_data [0:24];

    assign humtemp_data[0] = "\r";
    assign humtemp_data[1] = "\n";
    assign humtemp_data[2] = "h";
    assign humtemp_data[3] = "u";
    assign humtemp_data[4] = "m";
    assign humtemp_data[5] = ":";
    assign humtemp_data[6] = hum_decimal[7:4] + 8'h30;
    assign humtemp_data[7] = hum_decimal[3:0] + 8'h30;
    assign humtemp_data[8] = ".";
    assign humtemp_data[9] = hum_integral[7:4] + 8'h30;
    assign humtemp_data[10] = hum_integral[3:0] + 8'h30;
    assign humtemp_data[11] = "\r";
    assign humtemp_data[12] = "\n";
    assign humtemp_data[13] = "t";
    assign humtemp_data[14] = "e";
    assign humtemp_data[15] = "m";
    assign humtemp_data[16] = "p";
    assign humtemp_data[17] = ":";
    assign humtemp_data[18] = temp_decimal[7:4] + 8'h30;
    assign humtemp_data[19] = temp_decimal[3:0] + 8'h30;
    assign humtemp_data[20] = ".";
    assign humtemp_data[21] = temp_integral[7:4] + 8'h30;
    assign humtemp_data[22] = temp_integral[3:0] + 8'h30;
    assign humtemp_data[23] = "\r";
    assign humtemp_data[24] = "\n";

    digit_spliter h_integral(
        .bcd(humidity_data[15:8]),
        .digit(hum_integral)
    );
    digit_spliter h_decimal(
        .bcd(temperature_data[7:0]),
        .digit(hum_decimal)
    );
    digit_spliter t_integral(
        .bcd(temperature_data[15:8]),
        .digit(temp_integral)
    );
    digit_spliter t_decimal(
        .bcd(temperature_data[7:0]),
        .digit(temp_decimal)
    );
    // ------------------------------------------------------------------------

    reg out_com;

    reg [3:0] i;
    reg [4:0] j;
    reg [$clog2(161)-1:0] tick_cont;

initial begin
    i = 0;
    out_com = 0;
    tick_cont = 0;
    out_centi = 0;
    out_hum = 0;
    out_temp = 0;
    j = 11;
end

    // ------------------------------------------------------------------------
    // Time data
    // ------------------------------------------------------------------------
    wire [7:0] time_data [0:11];

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

    // ------------------------------------------------------------------------
    
assign s_trigger = !tx_empty & ~tx_done;


    btn_edge_trigger #(.SET_HZ(3000)) U_TX_DEBOUNCE (
        .clk  (clk),
        .rst  (rst),
        .i_btn(!tx_done),
        .o_btn(end_flag)
    );


    uart U_UART (
        .clk(clk),
        .rst(rst),
        .btn_start((!tx_empty & ~tx_done)|out_com|out_centi|out_hum|out_temp),
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


// 여기가 버퍼 코드
    always @(posedge clk or posedge rst) begin
        if(rst) tx_data_in = 0;
        else begin
            out_com = o_command == 7 & !tx_done & tx_empty ? 1:out_com;
            out_centi = o_command == 8 & !tx_done & tx_empty ? 1:out_centi;
            out_hum = o_command == 9 & !tx_done & tx_empty ? 1:out_hum;
            out_temp = o_command == 10 & !tx_done & tx_empty ? 1:out_temp;
            // --------------------------------------------------------------------
            // Time Value print
            // --------------------------------------------------------------------
            if(out_com) begin
                if(tick) tick_cont = tick_cont + 1;

                if(tick_cont >= 161) begin
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
            // --------------------------------------------------------------------
            // Ultra Value print
            // --------------------------------------------------------------------
            end else if(out_centi) begin
                if(tick) tick_cont = tick_cont + 1;

                if(tick_cont >= 161) begin

                    if(!tx_done) begin
                        tx_data_in = ultra_shoot[i];
                        tick_cont = 0;
                        if(i == 8) begin
                            i = 0;
                            out_centi = 0;
                        end
                        else i = i + 1;
                    end
                end
            // --------------------------------------------------------------------
            // Humidity Value print
            // --------------------------------------------------------------------
            end else if(out_hum) begin
                if(tick) tick_cont = tick_cont + 1;

                if(tick_cont >= 161) begin

                    if(!tx_done) begin
                        tx_data_in = humtemp_data[i];
                        tick_cont = 0;
                        if(i == 12) begin
                            i = 0;
                            out_hum = 0;
                        end
                        else i = i + 1;
                    end
                end
            // --------------------------------------------------------------------
            // Temperature Vaule print
            // --------------------------------------------------------------------
            end else if(out_temp) begin
                if(tick) tick_cont = tick_cont + 1;

                if(tick_cont >= 161) begin

                    if(!tx_done) begin
                        tx_data_in = humtemp_data[j];
                        tick_cont = 0;
                        if(j == 24) begin
                            j = 11;
                            out_temp = 0;
                        end
                        else j = j + 1;
                    end
                end
            end
            // --------------------------------------------------------------------
            // Just Buffer
            // --------------------------------------------------------------------
            else if(!tx_empty) tx_data_in = tx_data;
            else tx_data_in = tx_data_in;
        end
    end


endmodule