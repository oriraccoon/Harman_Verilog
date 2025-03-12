module Top_Module(
                    input clk,
                    input rst,
                    input btn_run,
                    input btn_clear,
                    input sw_mod,
                    input w_mod,
                    output [3:0] led_mod,
                    output [3:0] fnd_comm,
                    output [7:0] fnd_font
);

wire o_run, o_clear, o_mod;
wire [6:0] ms_counter;
wire [5:0] s_counter, m_counter;
wire [4:0] h_counter;

assign led_mod[3:2] =  w_mod ? 2'b10 : 2'b01;
stopwatch_cu U_stopwatch_cu(
                            .clk(clk),
                            .rst(rst),
                            .i_btn_run(btn_run),
                            .i_btn_clear(btn_clear),
                            .sw_mod(sw_mod),
                            .led_mod(led_mod[1:0]),
                            .o_run(o_run),
                            .o_clear(o_clear),
                            .o_mod(o_mod)
);

fnd_ctrl U_fnd_ctrl(
                    .ms_counter(ms_counter),
                    .s_counter(s_counter),
                    .m_counter(m_counter),
                    .h_counter(h_counter),
                    .clk(clk),
                    .rst(rst),
                    .state(o_mod),
                    .stop_state(o_run),
                    .seg_out(fnd_font),
                    .an(fnd_comm)
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




endmodule
