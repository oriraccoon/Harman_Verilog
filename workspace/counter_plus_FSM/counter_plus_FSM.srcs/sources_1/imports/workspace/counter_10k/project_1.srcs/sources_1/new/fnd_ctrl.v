module fnd_ctrl(
    input [13:0] sum_in,
    input clk,
    input rst,
    output reg [7:0] seg_out,
    output reg [3:0] an
);

    wire [15:0] digit;
    reg [7:0] seg_state;
    reg [19:0] clk_div;
    wire o_clk;

    digit_num dn(
        .sum(sum_in),
        .digit(digit)
    );

    clk_divider cd(
        .clk(clk),
        .rst(rst),
        .o_clk(o_clk)
    );

    function [7:0] bcd2seg(
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
                default: bcd2seg = 8'hFF;
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
                seg_out <= bcd2seg(digit[3:0]); 
            end
            4'b1110: begin
                an <= 4'b1101;
                seg_out <= bcd2seg(digit[7:4]);  
            end
            4'b1101: begin
                an <= 4'b1011;
                seg_out <= bcd2seg(digit[11:8]);  
            end
            4'b1011: begin
                an <= 4'b0111;
                seg_out <= bcd2seg(digit[15:12]); 
            end
            default: begin
                an <= 4'b1110;
                seg_out <= 8'hFF;
            end
        endcase
        
    end
endmodule

module clk_divider(
    input clk,
    input rst,
    output o_clk
);

		parameter FCOUNT = 500_000;

    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == FCOUNT - 1 ) begin // 1kHz
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
    input [13:0] sum,
    output reg [15:0] digit
);
    always @(*) begin
        digit[3:0] = ((sum % 1000) % 100) % 10;
        digit[7:4] = ((sum % 1000) % 100) / 10;
        digit[11:8] = (sum % 1000) / 100;
        digit[15:12] = sum / 1000;
    end
endmodule


