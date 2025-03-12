module Top_Module(
                    input clk,
                    input rst,
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

wire o_run, o_clear, o_mod_stopwatch;
wire o_mod_watch, o_sec_mod, o_min_mod, o_hour_mod, o_pm_mod;
wire [6:0] ms_counter;
wire [5:0] s_counter, m_counter;
wire [4:0] h_counter;
wire [6:0] w_ms_counter;
wire [5:0] w_s_counter, w_m_counter;
wire [4:0] w_h_counter;

Control_Unit U_Control_Unit(
                    .clk(clk),
                    .rst(rst),
                    .btn_run(btn_run),
                    .btn_clear(btn_clear),
                    .btn_sec_cal(btn_sec_cal),
                    .btn_min_cal(btn_min_cal),
                    .sw_mod(sw_mod),
                    .w_mod(switch_mod),
                    .pm_mod(pm_mod),
                    .o_run(o_run),
                    .o_clear(o_clear),
                    .o_mod_stopwatch(o_mod_stopwatch),
                    .o_mod_watch(o_mod_watch),
                    .o_sec_mod(o_sec_mod),
                    .o_min_mod(o_min_mod),
                    .o_hour_mod(o_hour_mod),
                    .o_pm_mod(o_pm_mod)
);



Fnd_Ctrl_Unit U_Fnd_ctrl_Unit(
                    .ms_counter(ms_counter),
                    .s_counter(s_counter),
                    .m_counter(m_counter),
                    .h_counter(h_counter),
                    .w_ms_counter(w_ms_counter),
                    .w_s_counter(w_s_counter),
                    .w_m_counter(w_m_counter),
                    .w_h_counter(w_h_counter),
                    .clk(clk),
                    .rst(rst),
                    .o_mod_stopwatch(o_mod_stopwatch),
                    .o_mod_watch(o_mod_watch),
                    .o_run(o_run),
                    .w_mod(switch_mod),
                    .fnd_font(fnd_font),
                    .fnd_comm(fnd_comm)
);

/*
Datapath_Unit U_Datapath_Unit(
    clk(clk),
    rst(rst),
    o_run(o_run),
    o_clear(o_clear),
    o_sec_mod(o_sec_mod),
    o_min_mod(o_min_mod),
    o_hour_mod(o_hour_mod),
    o_pm_mod(o_pm_mod),
    .ms_counter(),
    .s_counter(),
    .m_counter(),
    .h_counter(),
    .w_ms_counter(),
    .w_s_counter(),
    .w_m_counter(),
    .w_h_counter()
);*/

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


reg [5:0] led_mod_reg;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        led_mod_reg <= 6'b000000;
    end else begin
        led_mod_reg[1:0] <= sw_mod ? 2'b10 : 2'b01;
        led_mod_reg[3:2] <= switch_mod ? 2'b10 : 2'b01;
        led_mod_reg[5:4] <= pm_mod ? 2'b10 : 2'b01;
    end
end
assign led_mod = led_mod_reg;

endmodule
