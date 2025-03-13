`timescale 1ns / 1ps

module tb_alu();

    // 입력 및 출력 신호 선언
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    wire [7:0] result;

    // ALU 모듈 인스턴스화
    alu DUT(
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    // ALU 테스트 태스크 정의
    task test_alu;
        input [3:0] test_a;
        input [3:0] test_b;
        input [1:0] test_op;
        input [3:0] expected;
        begin
            a = test_a;
            b = test_b;
            op = test_op;
            #10; // 연산 결과 확인을 위한 대기
            if(result === expected) 
                $display("PASS: a = %h, b = %h, op = %b, result = %h", test_a, test_b, test_op, result);
            else $display("FAIL: a = %h, b = %h, op = %b, result = %h", test_a, test_b, test_op, result);

        end
    endtask

    // 테스트 시퀀스
    initial begin
        $display("ALU Testbench Start");

        // ADD 테스트 (op = 00)
        test_alu(4'h3, 4'h5, 2'b00, 4'h8);
        // SUB 테스트 (op = 01)
        test_alu(4'h7, 4'h2, 2'b01, 4'h5);
        // AND 테스트 (op = 10)
        test_alu(4'hF, 4'h4, 2'b10, 4'hA);
        // OR 테스트 (op = 11)
        test_alu(4'hC, 4'hF, 2'b11, 4'hF);

        $display("ALU Testbench Complete");
        $finish;
    end

endmodule
