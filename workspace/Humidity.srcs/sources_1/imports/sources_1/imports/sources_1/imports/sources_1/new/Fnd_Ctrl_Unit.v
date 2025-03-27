module Fnd_Ctrl_Unit(
    input clk,
    input rst,
    input o_mod_stopwatch,
    input o_mod_watch,
    input o_run,
    input w_mod,
    input ultra_mod,
    input hum_mod,
    input temp_mod,
    input [$clog2(400)-1:0] distance,
    input [15:0] humidity_data,
    input [15:0] temperature_data,
    input [6:0] ms_counter,
    input [5:0] s_counter, m_counter,
    input [4:0] h_counter,
    input [6:0] w_ms_counter,
    input [5:0] w_s_counter, w_m_counter,
    input [4:0] w_h_counter,
    output [7:0] fnd_font,
    output [3:0] fnd_comm
);
    wire o_clk;
    wire [7:0] stopwatch_fnd_font, watch_fnd_font, ultra_fnd_font, hum_fnd_font, temp_fnd_font;
    wire [3:0] stopwatch_fnd_comm, watch_fnd_comm, ultra_fnd_comm, hum_fnd_comm, temp_fnd_comm;

    stopwatch_fnd_ctrl U_stopwatch_fnd_ctrl(
                        .ms_counter(ms_counter),
                        .s_counter(s_counter),
                        .m_counter(m_counter),
                        .h_counter(h_counter),
                        .clk(clk),
                        .rst(rst),
                        .state(o_mod_stopwatch),
                        .stop_state(o_run),
                        .seg_out(stopwatch_fnd_font),
                        .an(stopwatch_fnd_comm)
    );


    watch_fnd_ctrl U_watch_fnd_ctrl(
                        .ms_counter(w_ms_counter),
                        .s_counter(w_s_counter),
                        .m_counter(w_m_counter),
                        .h_counter(w_h_counter),
                        .clk(clk),
                        .rst(rst),
                        .state(o_mod_watch),
                        .seg_out(watch_fnd_font),
                        .an(watch_fnd_comm)
    );

    ultra_fnd_ctrl U_ultra_fnd_ctrl(
                        .cen1000(0),
                        .cen1(Ultra_data[2]),
                        .cen10(Ultra_data[1]),
                        .cen100(Ultra_data[0]),
                        .clk(clk),
                        .rst(rst),
                        .seg_out(ultra_fnd_font),
                        .an(ultra_fnd_comm)
    );

    HT_fnd_ctrl U_hum_fnd_ctrl(
                        .cen1(Humidity_data[3]),
                        .cen10(Humidity_data[2]),
                        .cen100(Humidity_data[1]),
                        .cen1000(Humidity_data[0]),
                        .clk(clk),
                        .rst(rst),
                        .seg_out(hum_fnd_font),
                        .an(hum_fnd_comm)
    );

    HT_fnd_ctrl U_temp_fnd_ctrl(
                        .cen1(Temperature_data[3]),
                        .cen10(Temperature_data[2]),
                        .cen100(Temperature_data[1]),
                        .cen1000(Temperature_data[0]),
                        .clk(clk),
                        .rst(rst),
                        .seg_out(temp_fnd_font),
                        .an(temp_fnd_comm)
    );

    assign fnd_font = hum_mod ? hum_fnd_font : temp_mod ? temp_fnd_font : ultra_mod ? ultra_fnd_font : w_mod ? watch_fnd_font : stopwatch_fnd_font;
    assign fnd_comm = hum_mod ? hum_fnd_comm : temp_mod ? temp_fnd_comm : ultra_mod ? ultra_fnd_comm : w_mod ? watch_fnd_comm : stopwatch_fnd_comm;

    wire [3:0] Ultra_data [0:2];
    digit_spliter2 #(.WIDTH(9)) s_split(
        .bcd(distance),
        .digit({Ultra_data[0], Ultra_data[1], Ultra_data[2]})
    );

    wire [3:0] Humidity_data [0:3];
    wire [3:0] Temperature_data [0:3];

    digit_spliter h_integral(
        .bcd(humidity_data[15:8]),
        .digit({Humidity_data[3], Humidity_data[2]})
    );
    digit_spliter h_decimal(
        .bcd(temperature_data[7:0]),
        .digit({Humidity_data[1], Humidity_data[0]})
    );
    digit_spliter t_integral(
        .bcd(temperature_data[15:8]),
        .digit({Temperature_data[3], Temperature_data[2]})
    );
    digit_spliter t_decimal(
        .bcd(temperature_data[7:0]),
        .digit({Temperature_data[1], Temperature_data[0]})
    );

endmodule