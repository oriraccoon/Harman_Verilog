module fnd_ctrl(
    input [7:0] data,      // UART로 입력받은 데이터
    input clk,             // 시스템 클럭
    input rst,             // 리셋 신호
    output reg [7:0] seg_out, // FND 세그먼트 출력
    output reg [3:0] an      // FND 자릿수 선택
);

    // 16x8bit RAM: 최근 16개의 입력 저장
    reg [7:0] ram [0:15];
    reg [3:0] write_addr;    // RAM 쓰기 주소
    reg flag;                // 중복 입력 방지 플래그
    wire o_clk;              // FND 출력 주파수 (200Hz)

    // 200Hz로 FND를 갱신하는 클럭 분주기
    clock_divider_200hz cd(
        .clk(clk),
        .rst(rst),
        .o_clk(o_clk)
    );

    // ASCII를 7-segment로 변환하는 함수 (0~9, A~F 지원)
    function [7:0] ascii_to_fnd;
        input [7:0] ascii;
        begin
            case (ascii)
                8'h30: ascii_to_fnd = 8'b1100_0000; // '0'
                8'h31: ascii_to_fnd = 8'b1111_1001; // '1'
                8'h32: ascii_to_fnd = 8'b1010_0100; // '2'
                8'h33: ascii_to_fnd = 8'b1011_0000; // '3'
                8'h34: ascii_to_fnd = 8'b1001_1001; // '4'
                8'h35: ascii_to_fnd = 8'b1001_0010; // '5'
                8'h36: ascii_to_fnd = 8'b1000_0010; // '6'
                8'h37: ascii_to_fnd = 8'b1111_1000; // '7'
                8'h38: ascii_to_fnd = 8'b1000_0000; // '8'
                8'h39: ascii_to_fnd = 8'b1001_0000; // '9'
                8'h41: ascii_to_fnd = 8'b1000_1000; // 'A'
                8'h42: ascii_to_fnd = 8'b0000_0011; // 'b'
                8'h43: ascii_to_fnd = 8'b1100_0110; // 'C'
                8'h44: ascii_to_fnd = 8'b0100_0001; // 'd'
                8'h45: ascii_to_fnd = 8'b1000_0110; // 'E'
                8'h46: ascii_to_fnd = 8'b1000_1110; // 'F'
                default: ascii_to_fnd = 8'b1111_1111; // 잘못된 값
            endcase
        end
    endfunction

    // 초기화
    initial begin
        write_addr = 4'd0; // RAM 초기화
        an = 4'b1110;      // 첫 번째 자리 활성화
        seg_out = 8'hC0;   // '0'
        flag = 0;          // 중복 방지 플래그 초기화
    end

    // 새로운 입력 처리 (숫자 '0'~'9', 알파벳 'A'~'F'만 허용)
    always @(posedge clk) begin
        if (((data >= 8'h30 && data <= 8'h39) || (data >= 8'h41 && data <= 8'h46)) && !flag) begin
            ram[write_addr] <= data;    // RAM에 데이터 저장
            write_addr <= write_addr + 1; // 주소 증가 (0~15 순환)
            flag <= 1;                  // 중복 방지
        end else if (data == 8'h00) begin
            flag <= 0; // 입력 초기화
        end
    end

    // FND 자릿수 스캔 출력
    reg [3:0] read_offset; // 4자리 순환용 읽기 오프셋

    always @(posedge o_clk) begin
        case (an)
            4'b0111: begin
                an <= 4'b1110;
                seg_out <= {1'b1, ascii_to_fnd(ram[(write_addr - 1 - read_offset) % 16])};
                read_offset <= 4'd0;
            end
            4'b1110: begin
                an <= 4'b1101;
                seg_out <= {1'b1, ascii_to_fnd(ram[(write_addr - 2 - read_offset) % 16])};
                read_offset <= 4'd1;
            end
            4'b1101: begin
                an <= 4'b1011;
                seg_out <= {1'b1, ascii_to_fnd(ram[(write_addr - 3 - read_offset) % 16])};
                read_offset <= 4'd2;
            end
            4'b1011: begin
                an <= 4'b0111;
                seg_out <= {1'b1, ascii_to_fnd(ram[(write_addr - 4 - read_offset) % 16])};
                read_offset <= 4'd3;
            end
            default: begin
                an <= 4'b1110;
                seg_out <= 8'hC0; // 기본값 '0'
            end
        endcase
    end

endmodule
