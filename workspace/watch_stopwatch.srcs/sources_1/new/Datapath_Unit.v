module Datapath_Unit (
    input clk,
    input rst,
    input o_run,
    input o_clear,
    input signed [5:0] btn_sec_cal,
    input signed [5:0] btn_min_cal,
    input signed [5:0] btn_hour_cal,
    input o_pm_mod,
    output [6:0] ms_counter,
    output [5:0] s_counter, m_counter,
    output [4:0] h_counter,
    output [6:0] w_ms_counter,
    output [5:0] w_s_counter, w_m_counter,
    output [4:0] w_h_counter
);
    
stopwatch_dp U_stopwatch_dp(
                    .clk(clk),
                    .rst(rst),
                    .i_btn_run(o_run),
                    .i_btn_clear(o_clear),
                    .ms_counter(ms_counter),
                    .s_counter(s_counter),
                    .m_counter(m_counter),
                    .h_counter(h_counter)
);
watch_dp U_watch_dp(
                    .clk(clk),
                    .rst(rst),
                    .sec_mod(btn_sec_cal),
                    .min_mod(btn_min_cal),
                    .hour_mod(btn_hour_cal),
                    .pm_mod(o_pm_mod),
                    .ms_counter(w_ms_counter),
                    .s_counter(w_s_counter),
                    .m_counter(w_m_counter),
                    .h_counter(w_h_counter)
);


endmodule