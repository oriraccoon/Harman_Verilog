module Top_Uart_Watch(
    input clk,
    input rst,
    // UART_FIFO
    input rx,
    output tx,

    // STOP_AND_WATCH
    input btn_run,
    input btn_clear,
    input btn_sec_cal,
    input btn_min_cal,
    input sw_mod,
    input switch_mod,
    input pm_mod,
    output [5:0] led_mod,
    output [3:0] fnd_comm,
    output [7:0] fnd_font
    );

wire [7:0] w_tx_data;
wire [3:0] w_command;
wire s_trigger;

TOP_UART_FIFO U_UART_FIFO(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .tx(tx),
    .s_trigger(s_trigger),
    .tx_data(w_tx_data)
);

Top_Module U_STOP_AND_WATCH(
    .clk(clk),
    .rst(rst),
    .btn_run(btn_run),
    .btn_clear(btn_clear),
    .btn_sec_cal(btn_sec_cal),
    .btn_min_cal(btn_min_cal),
    .sw_mod(sw_mod),
    .switch_mod(switch_mod),
    .pm_mod(pm_mod),
    .t_command(w_command),
    .led_mod(led_mod),
    .fnd_comm(fnd_comm),
    .fnd_font(fnd_font)
);

detect_command U_COMMAND(
    .clk(clk),
    .rst(rst),
    .tx_data(w_tx_data),
    .s_trigger(s_trigger),
    .o_command(w_command)
);



endmodule

module detect_command(
    input clk,
    input rst,
    input [7:0] tx_data,
    input s_trigger,
    output [3:0] o_command
);

parameter IDLE = 0, WAIT = 1, RUN = 2, CLEAR = 3, SEC = 4, MIN = 5, HOUR = 6;

reg [3:0] r_command, n_command;
assign o_command = r_command;

always @(posedge clk or posedge rst) begin
    if(rst) r_command <= 0;
    else r_command <= n_command;
end
    always @(*) begin
        n_command = 0;
        if(s_trigger) begin
            case(tx_data)
                "w", "W": begin
                    n_command = WAIT;
                end
                "r", "R": begin
                    n_command = RUN;
                end
                "c", "C": begin
                    n_command = CLEAR;
                end
                "s", "S": begin
                    n_command = SEC;
                end
                "m", "M": begin
                    n_command = MIN;
                end
                "h", "H": begin
                    n_command = HOUR;
                end
                default: n_command = IDLE;
            endcase
        end
    end

endmodule
/*
module Time_data(
    input clk,
    input rst,
    input [5:0] s_counter,
    input [5:0] m_counter,
    input [4:0] h_counter,
    output [5:0] s_data,
    output [5:0] m_data,
    output [5:0] h_data
);
watch_dp U_watch_dp(
    input clk,
    input rst
    output [6:0] ms_counter,
    output [5:0] s_counter,
    output [5:0] m_counter,
    output [4:0] h_counter
);
    wire [3:0] w_msec_digit_1, w_msec_digit_10, w_sec_digit_1, w_sec_digit_10, w_min_digit_1, w_min_digit_10, w_hour_digit_1, w_hour_digit_10;


    time_digit_spliter tds(
        .s_counter(s_counter),
        .m_counter(m_counter),
        .h_counter(h_counter),
        .digit({w_hour_digit_10, w_hour_digit_1, w_min_digit_10, w_min_digit_1,
            w_sec_digit_10, w_sec_digit_1})
    );

endmodule*/