module Control_Unit(
                    input clk,
                    input rst,
                    input btn_run,
                    input btn_clear,
                    input btn_sec_cal,
                    input btn_min_cal,
                    input sw_mod,
                    input w_mod,
                    input pm_mod,
                    output o_run,
                    output o_clear,
                    output o_mod_stopwatch,
                    output o_mod_watch,
                    output o_sec_mod,
                    output o_min_mod,
                    output o_hour_mod,
                    output o_pm_mod
    );
// pm mod 는 w_mod가 1일때만 -> 어차피 watch cu에서 조작하면 되니까 상관 없음
// w_mod가 1이면 -> 버튼은 초분시 증감 // w_mod가 0이면 -> 시작 클리어(나머지 동작 x)

stopwatch_cu U_stopwatch_cu(
                            .clk(clk),
                            .rst(rst),
                            .i_btn_run(btn_run),
                            .i_btn_clear(btn_clear),
                            .sw_mod(sw_mod),
                            .w_mod(w_mod),
                            .o_run(o_run),
                            .o_clear(o_clear),
                            .o_mod(o_mod_stopwatch)
);
watch_cu U_watch_cu(
                            .clk(clk),
                            .rst(rst),
                            .i_btn_run(btn_run),
                            .i_btn_sec_cal(btn_sec_cal),
                            .i_btn_min_cal(btn_min_cal),
                            .sw_mod(sw_mod),
                            .w_mod(w_mod),
                            .pm_mod(pm_mod),
                            .o_sec_mod(o_sec_mod),
                            .o_min_mod(o_min_mod),
                            .o_hour_mod(o_hour_mod),
                            .o_mod(o_mod_watch),
                            .o_pm_mod(o_pm_mod)
);

endmodule
