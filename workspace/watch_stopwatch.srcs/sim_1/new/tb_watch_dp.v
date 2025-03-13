`timescale 1ns / 1ps
module tb_watch_dp();
reg clk, rst, pm_mod, w_mod, btn_sec, btn_min, btn_hour;

Top_Module dut(
                    .clk(clk),
                    .rst(rst),
                    .btn_run(btn_hour),
                    .btn_sec_cal(btn_sec),
                    .btn_min_cal(btn_min),
                    .switch_mod(w_mod),
                    .pm_mod(pm_mod)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    pm_mod = 0;
    w_mod = 1;
    btn_sec = 0;
    btn_min = 0;
    btn_hour = 0;

    // 초기화
    #10 rst = 0;

    // 버튼 누르기 (디바운스 고려)
    #2000000 
    btn_hour = 1;  // 200us(0.2ms) 동안 버튼 누름
    btn_min = 1;
    btn_sec = 1;
    #2000000 
    btn_hour = 0;  // 버튼 떼기
    btn_min = 0;
    btn_sec = 0;
    
    #1000000000; // 충분한 시간 대기 (1ms)

    $finish;
end




endmodule
