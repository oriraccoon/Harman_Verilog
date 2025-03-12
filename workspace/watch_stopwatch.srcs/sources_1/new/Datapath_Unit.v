module Datapath_Unit (
    input clk,
    input rst,
    input o_run,
    input o_clear,
    input o_sec_mod,
    input o_min_mod,
    input o_hour_mod,
    input o_pm_mod,
    input [6:0] ms_counter,
    input [5:0] s_counter, m_counter,
    input [4:0] h_counter,
    input [6:0] w_ms_counter,
    input [5:0] w_s_counter, w_m_counter,
    input [4:0] w_h_counter
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
                    .sec_mod(o_sec_mod),
                    .min_mod(o_min_mod),
                    .hour_mod(o_hour_mod),
                    .pm_mod(o_pm_mod),
                    .ms_counter(w_ms_counter),
                    .s_counter(w_s_counter),
                    .m_counter(w_m_counter),
                    .h_counter(w_h_counter)
);


endmodule