module fnd_ctrl(
                input clk, rst,
                input [8:0] sum_in,
                output [3:0] an,
                output [7:0] seg_o
);

    wire [15:0] digit;
    wire [31:0] seg;
    

    digit_num dn(
        .sum(sum_in),
        .digit(digit)
    );
    

    counter_4 cf(
        .clk(clk),
        .rst(rst),
        .digit(digit),
        .seg(seg),
        .seg_o(seg_o),
        .an(an)
    );



endmodule

module counter_4(
                input clk,
                input rst,
                input [15:0] digit,
                input [31:0] seg,
                output reg [7:0] seg_o,
                output [3:0] an
);

    reg [1:0] r_counter;
    reg [19:0] clk_div;

    bcd2seg bs1(
        .digit(digit[3:0]),
        .seg(seg[7:0])
    );
    bcd2seg bs2(
        .digit(digit[7:4]),
        .seg(seg[14:8])
    );
    bcd2seg bs3(
        .digit(digit[11:8]),
        .seg(seg[23:15])
    );
    bcd2seg bs4(
        .digit(digit[15:12]),
        .seg(seg[31:24])
    );
    clk_mux cm(
                .i_sel(r_counter),
                .seg_comm(an)
    );

    always@(posedge clk or posedge rst) begin
        if(rst) begin
            r_counter <= 0;
            clk_div <= 0;
        end
        else begin
            clk_div <= clk_div + 1;
            if(clk_div == 500000 - 1) begin
                clk_div <= 0;
                r_counter <= r_counter + 1;

                case(an)
                    4'b1110: seg_o = seg[7:0];
                    4'b1101: seg_o = seg[15:8];
                    4'b1011: seg_o = seg[23:16];
                    4'b0111: seg_o = seg[31:24];
                endcase
            end
        end
    end

endmodule

module clk_divider(
    input clk,
    input rst,
    output o_clk
);

    reg [19:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == 100_000 - 1 ) begin // 1kHz
                r_counter <= 0;
                r_clk <= 1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end

endmodule

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


module clk_mux (
    input [1:0] i_sel,
    output reg [3:0] seg_comm
);

    always @(i_sel) begin
        case (i_sel)
            2'b00:   seg_comm = 4'b1110;
            2'b01:   seg_comm = 4'b1101;
            2'b10:   seg_comm = 4'b1011;
            2'b11:   seg_comm = 4'b0111;
            default: seg_comm = 4'b1111;
        endcase
    end

endmodule


module bcd2seg(
    input [3:0] digit,
    output reg [7:0] seg
);

    always@(*) begin
        case (digit)
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
            default: seg = 8'hC0;
        endcase
    end
endmodule