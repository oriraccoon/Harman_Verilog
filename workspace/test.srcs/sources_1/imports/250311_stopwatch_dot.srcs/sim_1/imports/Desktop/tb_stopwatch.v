`timescale 1ns / 1ps

module tb_stopwatch ();

    reg clk, reset, run, clear;
    wire [6:0] msec, sec, min;
    wire [4:0] hour;

    stopwatch_DP DUT (
        .clk  (clk),
        .reset(reset),
        .run  (run),
        .clear(clear),
        .msec (msec),
        .sec  (sec),
        .min  (min),
        .hour (hour)
    );


    always #5 clk = ~clk;   // 100Mhz

    initial begin
        // 초기화
        clk   = 0;
        reset = 1;
        run   = 0;
        clear = 0;

        #10; // 10나노 run
        reset = 0;
        run   = 1;
        wait (sec == 2);    // 23시간 대기

        // wait (sec == 1);    // 1시간 대기

        #10;
        run = 0;    // stop
        repeat(4) @(posedge clk);    // 4번 반복, posedge clk 이벤트
        clear = 1;
        #100;
    $stop;
    end

endmodule