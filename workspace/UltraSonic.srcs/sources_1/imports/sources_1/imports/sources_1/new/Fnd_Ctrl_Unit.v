module Fnd_Ctrl_Unit(
    input clk,
    input rst,
    input o_mod_stopwatch,
    input o_mod_watch,
    input o_run,
    input w_mod,
    input ultra_mod,
    input [$clog2(400)-1:0] distance,
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
    wire [7:0] stopwatch_fnd_font, watch_fnd_font, ultra_fnd_font;
    wire [3:0] stopwatch_fnd_comm, watch_fnd_comm, ultra_fnd_comm;

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
                        .cen1(Ultra_data[3]),
                        .cen10(Ultra_data[2]),
                        .cen100(Ultra_data[1]),
                        .cen1000(Ultra_data[0]),
                        .clk(clk),
                        .rst(rst),
                        .seg_out(ultra_fnd_font),
                        .an(ultra_fnd_comm)
    );

    clock_divider_1sec cd(
        .clk(clk),
        .rst(rst),
        .o_clk(o_clk)
    );

    assign fnd_font = ultra_mod ? ultra_fnd_font : w_mod ? watch_fnd_font : stopwatch_fnd_font;
    assign fnd_comm = ultra_mod ? ultra_fnd_comm : w_mod ? watch_fnd_comm : stopwatch_fnd_comm;

    wire [7:0] Ultra_data [0:3];
    reg [$clog2(400)-1:0] r_distance;
    wire [$clog2(400)-1:0] i_distance;
    always @(posedge o_clk) begin
        r_distance <= distance;
    end
    assign i_distance = r_distance;
    digit_spliter2 #(.WIDTH(16)) s_split(
        .bcd(i_distance),
        .digit({Ultra_data[0], Ultra_data[1], Ultra_data[2], Ultra_data[3]})
    );

endmodule
