`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/26 12:16:49
// Design Name: 
// Module Name: tb_humidity
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_humidity ();
reg clk, rst, dht_i;
wire dht_io;

reg dht_eo;

assign dht_io = dht_eo ? 1'hz : dht_i;
 

humidity dut(
    .clk(clk),
    .rst(rst),
    .dht_io(dht_io)
    );

always #5 clk = ~clk;

initial begin
    clk = 0;
    // 초기화
    rst = 1;
    dht_eo = 1;
    dht_i = 0;

    #100
    rst = 0;  // 리셋 해제

    // DHT 센서 시뮬레이션 시작
    #1018003000  // 대기 후 응답 시작
    // RESPONSE STATE
    dht_eo = 0;
    dht_i = 0;
    #80000
    
    dht_i = 1;  // DHT 센서 응답 준비 신호
    //READY STATE
    #80000 // 80us Low 신호

    // 데이터 전송 (40비트, 각 비트는 50us Low + 데이터별 High 시간)
    repeat (40) begin
        dht_i = 0;
        // SET STATE
        #50000  // 50us Low 신호
        dht_i = 1;
        // READ STATE
        if ($random % 2)  // 랜덤하게 0 또는 1을 시뮬레이션
            #70000;  // 70us High (1)
        else
            #26000;  // 26us High (0)
    end

    dht_i = 0;  // 전송 완료 후 종료 신호
    #50000
    dht_i = 1;
    #1000
    dht_eo = 1;
    #1000;
end


endmodule
