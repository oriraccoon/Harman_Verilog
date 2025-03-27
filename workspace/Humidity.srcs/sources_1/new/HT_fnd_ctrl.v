module ultra_fnd_ctrl(
    input [3:0] cen1,
    input [3:0] cen10,
    input [3:0] cen100,
    input [3:0] cen1000,
    input clk,
    input rst,
    output reg [7:0] seg_out,
    output reg [3:0] an
);

    reg [7:0] seg_state;
    wire o_clk;

    clock_divider_200hz cd(
        .clk(clk),
        .rst(rst),
        .o_clk(o_clk)
    );

    function [6:0] bcd2seg(
        input [3:0]bcd 
    );
        begin
            case (bcd)
                4'h0:  bcd2seg = 7'h40;
                4'h1:  bcd2seg = 7'h79;
                4'h2:  bcd2seg = 7'h24;
                4'h3:  bcd2seg = 7'h30;
                4'h4:  bcd2seg = 7'h19;
                4'h5:  bcd2seg = 7'h12;
                4'h6:  bcd2seg = 7'h02;
                4'h7:  bcd2seg = 7'h78;
                4'h8:  bcd2seg = 7'h00;
                4'h9:  bcd2seg = 7'h10;
                default: bcd2seg = 7'h7F;
            endcase
        end
    endfunction

    initial begin
        an = 4'b1110;
        seg_out = 8'hFF;
    end

    always @(posedge o_clk) begin
        case (an)
            4'b0111: begin
                an <= 4'b1110;
                seg_out <= {1'b1,bcd2seg(cen1)};
            end
            4'b1110: begin
                an <= 4'b1101;
                seg_out <= {1'b1,bcd2seg(cen10)};
            end
            4'b1101: begin
                an <= 4'b1011;
                seg_out <= {1'b0,bcd2seg(cen100)};
            end
            4'b1011: begin
                an <= 4'b0111;
                seg_out <= {1'b1,bcd2seg(cen1000)};
            end
            default: begin
                an <= 4'b1110;
                seg_out <= 8'hFF;
            end
        endcase
    end


endmodule