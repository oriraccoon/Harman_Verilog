`timescale 1ns / 1ps
module tb_watch_dp();
reg clk, rst, pm_mod, sec_mod, min_mod, hour_mod;
wire [6:0] ms_counter;
wire [5:0] s_counter, m_counter;
wire [4:0] h_counter;

watch_dp dut(
             .clk(clk),
             .rst(rst),
             .pm_mod(pm_mod),
             .sec_mod(sec_mod),
             .min_mod(min_mod),
             .hour_mod(hour_mod),
             .ms_counter(ms_counter),
             .s_counter(s_counter),
             .m_counter(m_counter),
             .h_counter(h_counter)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    pm_mod = 0;
    sec_mod = 0;
    min_mod = 0;
    hour_mod = 0;

    #10 rst = 0;


end



endmodule
