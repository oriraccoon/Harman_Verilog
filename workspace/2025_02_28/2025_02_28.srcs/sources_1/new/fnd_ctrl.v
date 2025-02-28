`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/28 14:31:58
// Design Name: 
// Module Name: fnd_ctrl
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


module fnd_ctrl(
                input [3:0] sum_in,
                input [1:0] btn,
                output [7:0] seg_out,
                output [3:0] an
                );

    btn2comm u_btn2comm (
        .btn(btn),
        .seg_comm(an)
    );


    bcd2seg bs(
                .sum_in(sum_in),
                .seg_out(seg_out)
                );

endmodule

module btn2comm (
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
                input [3:0] sum_in,
                output reg [7:0] seg_out
            );

    always @(*) begin
        case (sum_in)
            4'h0:  seg_out = 8'hC0;
            4'h1:  seg_out = 8'hF9;
            4'h2:  seg_out = 8'hA4;
            4'h3:  seg_out = 8'hB0;
            4'h4:  seg_out = 8'h99;
            4'h5:  seg_out = 8'h92;
            4'h6:  seg_out = 8'h82;
            4'h7:  seg_out = 8'hF8;
            4'h8:  seg_out = 8'h80;
            4'h9:  seg_out = 8'h90;
            4'hA:  seg_out = 8'h88;
            4'hB:  seg_out = 8'h83;
            4'hC:  seg_out = 8'hC6;
            4'hD:  seg_out = 8'hA1;
            4'hE:  seg_out = 8'h86;
            4'hF:  seg_out = 8'h8E;
            default: seg_out = 8'hFF; // 기본값 (모든 LED OFF)
        endcase
    end

endmodule
