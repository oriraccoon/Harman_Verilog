module Control_Unit(
                    input clk,
                    input rst,
                    input btn_run,
                    input btn_clear,
                    input btn_sec_cal,
                    input btn_min_cal,
                    input sw_mod,
                    input w_mod,
                    input ultra_mod,
                    input [3:0] t_command,
                    output o_run,
                    output o_clear,
                    output o_mod_stopwatch,
                    output o_mod_watch,
                    output o_sec_detect,
                    output o_min_detect,
                    output o_hour_detect
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
                            .ultra_mod(ultra_mod),
                            .t_command(t_command),
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
                            .ultra_mod(ultra_mod),
                            .t_command(t_command),
                            .o_mod(o_mod_watch),
                            .o_sec_detect(o_sec_detect),
                            .o_min_detect(o_min_detect),
                            .o_hour_detect(o_hour_detect)
);

endmodule
