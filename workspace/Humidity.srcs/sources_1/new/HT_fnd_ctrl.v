module HT_fnd_ctrl(
    input [3:0] hum1,
    input [3:0] hum10,
    input [3:0] hum100,
    input [3:0] hum1000,
    input [3:0] temp1,
    input [3:0] temp10,
    input [3:0] temp100,
    input [3:0] temp1000,
    input clk,
    input rst,
    input [3:0] switch_mod,
    output reg [7:0] seg_out,
    output reg [3:0] an
);

parameter HUMIDITY = 9, TEMPERATURE = 10;

    reg [7:0] seg_state;
    wire o_clk;
    wire state;

    assign state = (switch_mod == 9) ? 1 : (switch_mod == 10) ? 0 : state;
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
        case(state)
            1 : begin 
                case (an)
                    4'b0111: begin
                        an <= 4'b1110;
                        seg_out <= {1'b1,bcd2seg(hum1)};
                    end
                    4'b1110: begin
                        an <= 4'b1101;
                        seg_out <= {1'b1,bcd2seg(hum10)};
                    end
                    4'b1101: begin
                        an <= 4'b1011;
                        seg_out <= {1'b0,bcd2seg(hum100)};
                    end
                    4'b1011: begin
                        an <= 4'b0111;
                        seg_out <= {1'b1,bcd2seg(hum1000)};
                    end
                    default: begin
                        an <= 4'b1110;
                        seg_out <= 8'hFF;
                    end
                endcase
            end
            0: begin
                case (an)
                    4'b0111: begin
                        an <= 4'b1110;
                        seg_out <= {1'b1,bcd2seg(temp1)};
                    end
                    4'b1110: begin
                        an <= 4'b1101;
                        seg_out <= {1'b1,bcd2seg(temp10)};
                    end
                    4'b1101: begin
                        an <= 4'b1011;
                        seg_out <= {1'b0,bcd2seg(temp100)};
                    end
                    4'b1011: begin
                        an <= 4'b0111;
                        seg_out <= {1'b1,bcd2seg(temp1000)};
                    end
                    default: begin
                        an <= 4'b1110;
                        seg_out <= 8'hFF;
                    end
                endcase
            end
        endcase
    end


endmodule