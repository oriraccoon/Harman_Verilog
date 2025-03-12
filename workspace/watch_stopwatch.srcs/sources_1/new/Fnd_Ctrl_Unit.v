module Fnd_Ctrl_Unit(
    input clk,
    input rst,
    input o_mod_stopwatch,
    input o_mod_watch,
    input o_run,
    input w_mod,
    input [6:0] ms_counter,
    input [5:0] s_counter, m_counter,
    input [4:0] h_counter,
    input [6:0] w_ms_counter,
    input [5:0] w_s_counter, w_m_counter,
    input [4:0] w_h_counter,
    output [7:0] fnd_font,
    output [3:0] fnd_comm
);

wire [7:0] stopwatch_fnd_font, watch_fnd_font;
wire [3:0] stopwatch_fnd_comm, watch_fnd_comm;

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

reg w_mod_sync1, w_mod_sync2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        w_mod_sync1 <= 0;
        w_mod_sync2 <= 0;
    end else begin
        w_mod_sync1 <= w_mod;
        w_mod_sync2 <= w_mod_sync1;
    end
end

assign fnd_font = w_mod_sync2 ? watch_fnd_font : stopwatch_fnd_font;
assign fnd_comm = w_mod_sync2 ? watch_fnd_comm : stopwatch_fnd_comm;



endmodule
