module fnd_ctrl(
    input [8:0] sum_in,
    input clk,  // 100MHz 입력 클럭

    output reg [7:0] seg_out,
    output reg [3:0] an
);

wire [15:0] digit;
reg [7:0] seg_state;
reg [19:0] clk_div;  // 클럭 분주용 카운터

digit_num dn(
    .sum(sum_in),
    .digit(digit)
);

initial begin
    an = 4'b1110;
    seg_out = 8'hFF;  // 초기값 설정
end

always @(posedge clk) begin
    clk_div <= clk_div + 1;

    if (clk_div == 100000) begin  // 100MHz / 100000 = 1kHz (1ms)
        clk_div <= 0;
        
        case (an)
            4'b0111: begin
                an <= 4'b1110;
                seg_out <= bcd2seg(digit[3:0]);   // 1의 자리
            end
            4'b1110: begin
                an <= 4'b1101;
                seg_out <= bcd2seg(digit[7:4]);   // 10의 자리
            end
            4'b1101: begin
                an <= 4'b1011;
                seg_out <= bcd2seg(digit[11:8]);  // 100의 자리
            end
            4'b1011: begin
                an <= 4'b0111;
                seg_out <= bcd2seg(digit[15:12]); // 1000의 자리
            end
            default: begin
                an <= 4'b1110;
                seg_out <= 8'hFF;
            end
        endcase
    end
end
endmodule


module digit_num(
    input [8:0] sum,
    output reg [15:0] digit  // ? output reg로 변경
);
    always @(*) begin
        digit[3:0] = ((sum % 1000) % 100) % 10;
        digit[7:4] = ((sum % 1000) % 100) / 10;
        digit[11:8] = (sum % 1000) / 100;
        digit[15:12] = sum / 1000;
    end
endmodule



function automatic reg [7:0] bcd2seg(
    input [3:0] sum_in
);
    begin
        case (sum_in)
            4'h0:  bcd2seg = 8'hC0;
            4'h1:  bcd2seg = 8'hF9;
            4'h2:  bcd2seg = 8'hA4;
            4'h3:  bcd2seg = 8'hB0;
            4'h4:  bcd2seg = 8'h99;
            4'h5:  bcd2seg = 8'h92;
            4'h6:  bcd2seg = 8'h82;
            4'h7:  bcd2seg = 8'hF8;
            4'h8:  bcd2seg = 8'h80;
            4'h9:  bcd2seg = 8'h90;
            4'hA:  bcd2seg = 8'h88;
            4'hB:  bcd2seg = 8'h83;
            4'hC:  bcd2seg = 8'hC6;
            4'hD:  bcd2seg = 8'hA1;
            4'hE:  bcd2seg = 8'h86;
            4'hF:  bcd2seg = 8'h8E;
            default: bcd2seg = 8'hFF;
        endcase
    end
endfunction
