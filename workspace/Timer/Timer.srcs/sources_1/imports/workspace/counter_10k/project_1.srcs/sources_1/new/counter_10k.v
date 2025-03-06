module hmsms_counter(
        input clk,
        input rst,
        input state,
        output [26:0] time_counter
    );

    wire o_clk;
    reg [7:0] ms_counter;
    reg [6:0] s_counter;
    reg [6:0] m_counter;
    reg [4:0] h_counter;
    hundred_Hz_divider hhzd(
    .clk(clk),
    .rst(rst),
    .o_clk(o_clk)
    );

    assign time_counter = {h_counter, m_counter, s_counter, ms_counter};

    always@(posedge o_clk or posedge rst) begin
        if(rst) begin
            ms_counter <= 0;
            s_counter <= 0;
            m_counter <= 0;
            h_counter <= 0;
        end else begin
            case(state)
                1'b0: ms_counter <= ms_counter;
                1'b1: begin
                    if(ms_counter == 99) begin
                        ms_counter <= 0;
                        if(s_counter == 59) begin
                            s_counter <= 0;
                            if(m_counter == 59) begin
                                m_counter <= 0;
                                if(h_counter == 23) begin
                                    h_counter <= 0;
                                end
                                else h_counter <= h_counter + 1;
                            end
                            else m_counter <= m_counter + 1;
                        end
                        else s_counter <= s_counter + 1;
                    end
                    else ms_counter <= ms_counter + 1;
                end
                default: ms_counter <= ms_counter;
            endcase
        end
    end

endmodule

module hundred_Hz_divider(
    input clk,
    input rst,
    output o_clk
);

	parameter FCOUNT = 1_000_000;

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

