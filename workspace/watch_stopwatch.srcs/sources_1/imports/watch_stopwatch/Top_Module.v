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
wire signed [5:0] o_sec_detect;
wire signed [5:0] o_min_detect;
wire signed [5:0] o_hour_detect;
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
                    .o_pm_mod(o_pm_mod),
                    .o_sec_detect(o_sec_detect),
                    .o_min_detect(o_min_detect),
                    .o_hour_detect(o_hour_detect)
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

Datapath_Unit U_Datapath_Unit(
    .clk(clk),
    .rst(rst),
    .o_run(o_run),
    .o_clear(o_clear),
    .btn_hour_cal(o_hour_detect),
    .btn_sec_cal(o_sec_detect),
    .btn_min_cal(o_min_detect),
    .o_pm_mod(o_pm_mod),
    .ms_counter(ms_counter),
    .s_counter(s_counter),
    .m_counter(m_counter),
    .h_counter(h_counter),
    .w_ms_counter(w_ms_counter),
    .w_s_counter(w_s_counter),
    .w_m_counter(w_m_counter),
    .w_h_counter(w_h_counter)
);

led_generate U_led_generate(
    .clk(clk),
    .rst(rst),
    .sw_mod(sw_mod),
    .switch_mod(switch_mod),
    .pm_mod(pm_mod),
    .led_mod(led_mod)
);

endmodule

module led_generate (
    input clk,
    input rst,
    input sw_mod,
    input switch_mod,
    input pm_mod,
    output reg [5:0] led_mod
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        led_mod <= 6'b000000;
    end else begin
        led_mod[1:0] <= sw_mod ? 2'b10 : 2'b01;
        led_mod[3:2] <= switch_mod ? 2'b10 : 2'b01;
        led_mod[5:4] <= pm_mod ? 2'b10 : 2'b01;
    end
end
    
endmodule
