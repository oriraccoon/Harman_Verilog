module calculator(
                    input clk,
                    input rst,
                    input [1:0] btn,
                    output [7:0] seg,
                    output [3:0] an
                );

    wire [13:0] sum_in;

    counter_10k ck(
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .counter_10k(sum_in)
    );

    fnd_ctrl fc(
                .sum_in(sum_in),
                .clk(clk),
                .rst(rst),
                .seg_out(seg),
                .an(an)
            );

endmodule