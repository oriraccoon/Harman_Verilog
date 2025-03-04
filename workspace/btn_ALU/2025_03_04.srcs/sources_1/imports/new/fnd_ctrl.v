module digit_num(
    input [8:0] sum,
    output reg [15:0] digit
);
    always @(*) begin
        digit[3:0] = ((sum % 1000) % 100) % 10;
        digit[7:4] = ((sum % 1000) % 100) / 10;
        digit[11:8] = (sum % 1000) / 100;
        digit[15:12] = sum / 1000;
    end
endmodule


module btn_mux (
    input [1:0] btn,
    output reg [3:0] seg_comm
);

    always @(btn) begin
        case (btn)
            2'b00:   seg_comm = 4'b1110;
            2'b01:   seg_comm = 4'b1101;
            2'b10:   seg_comm = 4'b1011;
            2'b11:   seg_comm = 4'b0111;
            default: seg_comm = 4'b1111;
        endcase
    end
endmodule


module bcd2seg(
    input [8:0] sum_in,
    input [1:0] btn,
    output reg [7:0] seg,
    output [3:0] an
);

wire [15:0] digit;


digit_num dn(
    .sum(sum_in),
    .digit(digit)
);

btn_mux bm(
    .btn(btn),
    .seg_comm(an)
);

    always@(*) begin
        case(an)
            4'b1110: begin
                case (digit[3:0])
                    4'h0:  seg = 8'hC0;
                    4'h1:  seg = 8'hF9;
                    4'h2:  seg = 8'hA4;
                    4'h3:  seg = 8'hB0;
                    4'h4:  seg = 8'h99;
                    4'h5:  seg = 8'h92;
                    4'h6:  seg = 8'h82;
                    4'h7:  seg = 8'hF8;
                    4'h8:  seg = 8'h80;
                    4'h9:  seg = 8'h90;
                    default: seg = 8'hFF;
                endcase
            end
            4'b1101: begin
                case (digit[7:4])
                    4'h0:  seg = 8'hC0;
                    4'h1:  seg = 8'hF9;
                    4'h2:  seg = 8'hA4;
                    4'h3:  seg = 8'hB0;
                    4'h4:  seg = 8'h99;
                    4'h5:  seg = 8'h92;
                    4'h6:  seg = 8'h82;
                    4'h7:  seg = 8'hF8;
                    4'h8:  seg = 8'h80;
                    4'h9:  seg = 8'h90;
                    default: seg = 8'hFF;
                endcase
            end
            4'b1011: begin
                case (digit[11:8])
                    4'h0:  seg = 8'hC0;
                    4'h1:  seg = 8'hF9;
                    4'h2:  seg = 8'hA4;
                    4'h3:  seg = 8'hB0;
                    4'h4:  seg = 8'h99;
                    4'h5:  seg = 8'h92;
                    4'h6:  seg = 8'h82;
                    4'h7:  seg = 8'hF8;
                    4'h8:  seg = 8'h80;
                    4'h9:  seg = 8'h90;
                    default: seg = 8'hFF;
                endcase
            end
            4'b0111: begin
                case (digit[15:12])
                    4'h0:  seg = 8'hC0;
                    4'h1:  seg = 8'hF9;
                    4'h2:  seg = 8'hA4;
                    4'h3:  seg = 8'hB0;
                    4'h4:  seg = 8'h99;
                    4'h5:  seg = 8'h92;
                    4'h6:  seg = 8'h82;
                    4'h7:  seg = 8'hF8;
                    4'h8:  seg = 8'h80;
                    4'h9:  seg = 8'h90;
                    default: seg = 8'hFF;
                endcase
            end
        endcase
    end
endmodule