module fnd_ctrl(
    input [3:0] ms_counter,
    input [3:0] s_counter,
    input [3:0] m_counter,
    input [3:0] h_counter,
    input clk,
    input rst,
    output reg [7:0] seg_out,
    output reg [3:0] an
);
    reg [7:0] seg_state;
    wire o_clk, o_dp;



    clock_divider_200hz cd(
        .clk(clk),
        .rst(rst),
        .o_clk(o_clk)
    );

    watch_dp_blink db(
        .clk(clk),
        .rst(rst),
        .dp(o_dp)
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
                seg_out <= {1'b1,bcd2seg(ms_counter)};
            end
            4'b1110: begin
                an <= 4'b1101;
                seg_out <= {1'b1,bcd2seg(s_counter)};
            end
            4'b1101: begin
                an <= 4'b1011;
                seg_out <= {o_dp,bcd2seg(m_counter)};
            end
            4'b1011: begin
                an <= 4'b0111;
                seg_out <= {1'b1,bcd2seg(h_counter)};
            end
            default: begin
                an <= 4'b1110;
                seg_out <= 8'hFF;
            end
        endcase
end



endmodule

module watch_dp_blink (
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