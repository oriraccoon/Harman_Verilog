module calculator(
                    input clk,
                    input rst,
                    input [2:0] sw,
                    output [7:0] seg,
                    output [3:0] an
                );

    wire [13:0] sum_in;
    wire [2:0] state;

    counter_10k ck(
        .clk(clk),
        .rst(rst),
        .state(state),
        .counter_10k(sum_in)
    );
    five_SM fs(
                .clk(clk),
                .rst(rst),
                .sw(sw),
                .next(state)
        );

    fnd_ctrl fc(
                .sum_in(sum_in),
                .clk(clk),
                .rst(rst),
                .seg_out(seg),
                .an(an)
            );

endmodule