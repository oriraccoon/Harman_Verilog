module counter_10k(
        input clk,
        input rst,
        input [1:0] btn,
        output reg [$clog2(10000)-1:0] counter_10k
    );

    parameter COUNT_VAL = 10000;
    wire o_clk;

    count_divider cd(
    .clk(clk),
    .rst(rst),
    .o_clk(o_clk)
    );

    always@(posedge o_clk or posedge rst) begin
        if(rst) begin
            counter_10k <= 0;
        end else begin
            case(btn)
                2'b10: counter_10k <= 0;
                2'b00: counter_10k <= counter_10k;
                2'b11: counter_10k <= 0;
                2'b01: begin
                    if(counter_10k == COUNT_VAL - 1) counter_10k <= 0;
                    else counter_10k <= counter_10k + 1;
                end
                default: counter_10k <= 0;
            endcase
        end
    end
endmodule

module count_divider(
    input clk,
    input rst,
    output o_clk
);

	parameter FCOUNT = 5_000_000;

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
                r_clk <= ~r_clk;
            end
        end
    end

    always@(posedge r_clk) begin
                r_counter <= r_counter + 1;
    end

endmodule
