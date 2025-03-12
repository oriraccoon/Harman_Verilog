module stopwatch_fnd_ctrl(
    input [$clog2(100) - 1:0] ms_counter,
    input [$clog2(60) - 1:0] s_counter,
    input [$clog2(60) - 1:0] m_counter,
    input [$clog2(24) - 1:0] h_counter,
    input clk,
    input rst,
    input state,
    input stop_state,
    output reg [7:0] seg_out,
    output reg [3:0] an
);

    wire [3:0] w_msec_digit_1, w_msec_digit_10, w_sec_digit_1, w_sec_digit_10, w_min_digit_1, w_min_digit_10, w_hour_digit_1, w_hour_digit_10;
    reg [7:0] seg_state;
    wire o_clk, o_dp;

    time_digit_spliter tds(
        .ms_counter(ms_counter),
        .s_counter(s_counter),
        .m_counter(m_counter),
        .h_counter(h_counter),
        .digit({w_hour_digit_10, w_hour_digit_1, w_min_digit_10, w_min_digit_1,
            w_sec_digit_10, w_sec_digit_1, w_msec_digit_10, w_msec_digit_1})
    );

    clock_divider_200hz cd(
        .clk(clk),
        .rst(rst),
        .o_clk(o_clk)
    );

    stopwatch_dp_blink db(
        .clk(clk),
        .rst(rst),
        .stop_state(stop_state),
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
    case(state)
        1'b1: begin
            case (an)
                4'b0111: begin
                    an <= 4'b1110;
                    seg_out <= {1'b1,bcd2seg(w_min_digit_1)};
                end
                4'b1110: begin
                    an <= 4'b1101;
                    seg_out <= {1'b1,bcd2seg(w_min_digit_10)};
                end
                4'b1101: begin
                    an <= 4'b1011;
                    seg_out <= {o_dp,bcd2seg(w_hour_digit_1)};
                end
                4'b1011: begin
                    an <= 4'b0111;
                    seg_out <= {1'b1,bcd2seg(w_hour_digit_10)};
                end
                default: begin
                    an <= 4'b1110;
                    seg_out <= 8'hFF;
                end
            endcase
        end

        1'b0: begin
            case (an)
                4'b0111: begin
                    an <= 4'b1110;
                    seg_out <= {1'b1,bcd2seg(w_msec_digit_1)};
                end
                4'b1110: begin
                    an <= 4'b1101;
                    seg_out <= {1'b1,bcd2seg(w_msec_digit_10)};
                end
                4'b1101: begin
                    an <= 4'b1011;
                    seg_out <= {o_dp,bcd2seg(w_sec_digit_1)};
                end
                4'b1011: begin
                    an <= 4'b0111;
                    seg_out <= {1'b1,bcd2seg(w_sec_digit_10)};
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

module stopwatch_dp_blink (
    input clk,
    input rst,
    input stop_state,
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
            if(stop_state) begin
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
    end


endmodule