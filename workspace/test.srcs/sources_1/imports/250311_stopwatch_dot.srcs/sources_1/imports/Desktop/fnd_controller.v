`timescale 1ns / 1ps

module fnd_controller (
    input clk,
    input reset,
    input sw_mode,
    input [6:0] msec,
    input [5:0] sec,
    input [5:0] min,
    input [4:0] hour,
    output [6:0] fnd_font,
    output reg dp,
    output [3:0] fnd_comm
);

    wire w_dp;

    wire [3:0] w_bcd, w_digit_msec_1, w_digit_msec_10, 
                w_digit_sec_1, w_digit_sec_10,
                w_digit_min_1, w_digit_min_10,
                w_digit_hour_1, w_digit_hour_10;

    wire [3:0] w_msec_sec, w_min_hour;
    wire [3:0] w_seg_sel;
    wire w_clk_100hz;

    // 100Hz 클럭 (예: 다중화 주기) 생성
    clk_divider U_Clk_Divider (
        .clk  (clk),
        .reset(reset),
        .o_clk(w_clk_100hz)
    );

    // 4채널 다중화 선택 신호
    counter_8 U_Counter_8 (
        .clk  (w_clk_100hz),
        .reset(reset),
        .o_sel(w_seg_sel)
    );

    // 3x8 디코더로 7-세그먼트 공통선 제어 (active low)
    decoder_3x8 U_decoder_3x8 (
        .seg_sel (w_seg_sel),
        .seg_comm(fnd_comm)
    );

    digit_splitter #(
        .BIT_WIDTH(7)
    ) U_Msec_ds (
        .bcd(msec),
        .digit_1(w_digit_msec_1),
        .digit_10(w_digit_msec_10)
    );
    digit_splitter #(
        .BIT_WIDTH(7)
    ) U_Sec_ds (
        .bcd(sec),
        .digit_1(w_digit_sec_1),
        .digit_10(w_digit_sec_10)
    );
    digit_splitter #(
        .BIT_WIDTH(7)
    ) U_Min_ds (
        .bcd(min),
        .digit_1(w_digit_min_1),
        .digit_10(w_digit_min_10)
    );
    digit_splitter #(
        .BIT_WIDTH(5)
    ) U_Hour_ds (
        .bcd(hour),
        .digit_1(w_digit_hour_1),
        .digit_10(w_digit_hour_10)
    );

    mux_8x1 U_mux_8x1_Msec_Sec (
        .sel(w_seg_sel),
        .x0 (w_digit_msec_1),
        .x1 (w_digit_msec_10),
        .x2 (w_digit_sec_1),
        .x3 (w_digit_sec_10),
        .x4 (4'hf),
        .x5 (4'hf),
        .x6 (4'hf),
        .x7 (4'hf),
        .y  (w_msec_sec)
    );

    mux_2x1 U_mux_2x1_Mode (
        .sw_mode(sw_mode),
        .msec_sec(w_msec_sec),
        .min_hour(w_min_hour),
        .bcd(w_bcd)
    );

    mux_8x1 U_mux_8x1_Min_Hour (
        .sel(w_seg_sel),
        .x0 (w_digit_min_1),
        .x1 (w_digit_min_10),
        .x2 (w_digit_hour_1),
        .x3 (w_digit_hour_10),
        .x4 (4'hf),
        .x5 (4'hf),
        .x6 (4'hf),
        .x7 (4'hf),
        .y  (w_min_hour)
    );

    // BCD를 7-세그먼트 코드로 변환
    bcdtoseg U_bcdtoseg (
        .bcd(w_bcd),
        .seg(fnd_font[6:0])
    );

    dp_blink db(
        .clk(clk),
        .rst(rst),
        .dp(w_dp)
    );

    

    always @(*) begin
        if(w_seg_sel == 3'b010 || w_seg_sel == 3'b110) begin
            dp = w_dp;
        end else dp = 1;
    end

    

endmodule

// 100MHz 입력을 분주하여 100Hz 클럭 생성 (예: 100MHz -> 200Hz도 가능하나 여기서는 다중화용)
module clk_divider (
    input  clk,
    input  reset,
    output o_clk
);
    parameter FCOUNT = 100_000;
    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_clk;
    assign o_clk = r_clk;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if (r_counter == FCOUNT - 1) begin
                r_counter <= 0;
                r_clk <= 1'b1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule

// 4채널 다중화 선택을 위한 카운터
module counter_8 (
    input clk,
    input reset,
    output [2:0] o_sel
);
    reg [2:0] r_counter;
    assign o_sel = r_counter;

    always @(posedge clk, posedge reset) begin
        if (reset) r_counter <= 0;
        else r_counter <= r_counter + 1;
    end
endmodule

// 3x8 디코더: 선택 신호에 따라 활성화할 세그먼트 커먼 라인을 low로 만듦
module decoder_3x8 (
    input [2:0] seg_sel,
    output reg [3:0] seg_comm
);

    always @(seg_sel) begin
        case (seg_sel)
            3'b000:  seg_comm = 4'b1110;
            3'b001:  seg_comm = 4'b1101;
            3'b010:  seg_comm = 4'b1011;
            3'b011:  seg_comm = 4'b0111;
            3'b100:  seg_comm = 4'b1110;
            3'b101:  seg_comm = 4'b1101;
            3'b110:  seg_comm = 4'b1011;
            3'b111:  seg_comm = 4'b0111;
            default: seg_comm = 4'b1111;
        endcase
    end
endmodule

// 14비트 입력을 10진수 각 자리로 분리 (나중에 7-세그먼트 출력 순서는 다중화로 제어)
module digit_splitter #(
    parameter BIT_WIDTH = 7
) (
    input [BIT_WIDTH-1:0] bcd,
    output [3:0] digit_1,
    output [3:0] digit_10
);
    assign digit_1  = bcd % 10;  // 일의 백분초
    assign digit_10 = (bcd / 10) % 10;  // 십의 백분초
endmodule

// MUX 2x1
module mux_2x1 (
    input sw_mode,
    input [3:0] msec_sec,
    input [3:0] min_hour,
    output reg [3:0] bcd
);
    always @(*) begin
        case (sw_mode)
            1'b0: bcd = msec_sec;
            1'b1: bcd = min_hour;
            default: bcd = 4'hf;
        endcase
    end

endmodule

// MUX 8x1
module mux_8x1 (
    input [2:0] sel,
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    input [3:0] x4,
    input [3:0] x5,
    input [3:0] x6,
    input [3:0] x7,
    output reg [3:0] y
);

    always @(*) begin
        case (sel)
            3'b000:  y = x0;
            3'b001:  y = x1;
            3'b010:  y = x2;
            3'b011:  y = x3;
            3'b100:  y = x4;
            3'b101:  y = x5;
            3'b110:  y = x6;
            3'b111:  y = x7;
            default: y = 4'hf;
        endcase
    end

endmodule

// 4채널 다중화: 현재 활성화된 채널에 해당하는 자리수를 출력
// module mux_4x1 (
//     input  [1:0] sel,
//     input  [3:0] w_digit_msec_1,
//     input  [3:0] w_digit_msec_10,
//     input  [3:0] w_digit_sec_1,
//     input  [3:0] w_digit_sec_10,
//     output [3:0] bcd
// );
//     reg [3:0] r_bcd;
//     assign bcd = r_bcd;

//     always @(sel, w_digit_msec_1, w_digit_msec_10, w_digit_sec_1, w_digit_sec_10) begin
//         case (sel)
//             2'b00:   r_bcd = w_digit_msec_1;
//             2'b01:   r_bcd = w_digit_msec_10;
//             2'b10:   r_bcd = w_digit_sec_1;
//             2'b11:   r_bcd = w_digit_sec_10;
//             default: r_bcd = 4'bx;
//         endcase
//     end
// endmodule

// BCD 코드(4비트)를 7-세그먼트 제어 신호로 변환 (active low)
module bcdtoseg (
    input [3:0] bcd,
    output reg [7:0] seg
);
    always @(bcd) begin
        case (bcd)
            4'h0: seg = 7'h40;
            4'h1: seg = 7'h79;
            4'h2: seg = 7'h24;
            4'h3: seg = 7'h30;
            4'h4: seg = 7'h19;
            4'h5: seg = 7'h12;
            4'h6: seg = 7'h02;
            4'h7: seg = 7'h78;
            4'h8: seg = 7'h00;
            4'h9: seg = 7'h10;
            4'hA: seg = 7'h08;
            4'hB: seg = 7'h03;
            4'hC: seg = 7'h46;
            4'hD: seg = 7'h21;
            4'hE: seg = 7'h06;
            4'hF: seg = 7'h7f;  // segment off
            default: seg = 7'h7F;
        endcase
    end
endmodule

module dp_blink (
    input clk,
    input rst,
    output reg dp
);

    initial begin
        dp = 1'b1;
    end

    parameter FCOUNT = 200_000_000;

    reg [$clog2(FCOUNT)-1:0] r_counter;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            r_counter <= 0;
            dp <= 1'b1;
        end else begin
            if(r_counter == FCOUNT - 1 ) begin // 500mHz
                r_counter <= 0;
                dp <= ~dp;
            end else if(r_counter == FCOUNT - FCOUNT/4) begin
                dp <= ~dp;
                r_counter <= r_counter + 1;
            end else begin
                r_counter <= r_counter + 1;
            end
        end
    end
    
endmodule