`timescale 1ns / 1ps

module btn_debounce(
    input clk,
    input reset,
    input i_btn,
    output o_btn
    );

    // 8비트 shift register를 이용한 디바운스 구현
    reg [7:0] q_reg, q_next;    
    reg edge_detect;
    wire btn_debounce;

    // 1kHz 클럭 생성 (100MHz 입력 기준, 100_000 사이클)
    reg [$clog2(100_000)-1:0] counter;
    reg r_1khz;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter <= 0;
            r_1khz <= 0;
        end else begin
            if (counter == 100_000 - 1) begin
                counter <= 0;
                r_1khz <= 1'b1;  
            end else begin
                counter <= counter + 1;
                r_1khz <= 1'b0; 
            end
        end
    end
 
    // shift register – r_1khz 주기마다 입력값을 shift
    always @(posedge r_1khz, posedge reset) begin
        if (reset) begin
            q_reg <= 0;
        end else begin
            q_reg <= q_next;
        end
    end

    // next logic: 최신 i_btn 값을 최상위 비트에 삽입
    always @(i_btn, r_1khz) begin  
        q_next = {i_btn, q_reg[7:1]};
    end

    // 모든 비트가 1이면 btn_debounce 신호 생성
    assign btn_debounce = &q_reg;

    // rising edge 검출 (100MHz 클럭 도메인)
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            edge_detect <= 1'b0;
        end else begin
            edge_detect <= btn_debounce;
        end
    end

    // 최종 디바운스 출력: rising edge에서만 high
    assign o_btn = btn_debounce & (~edge_detect);

endmodule
