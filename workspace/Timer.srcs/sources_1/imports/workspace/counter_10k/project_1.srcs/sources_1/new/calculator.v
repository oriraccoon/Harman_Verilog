module calculator(
                    input clk,
                    input rst,
                    input [1:0] sw,
                    output [7:0] seg,
                    output [3:0] an
                );

    wire [26:0] time_counter;
    wire [1:0] state;

    hmsms_counter timer(
        .clk(clk),
        .rst(rst),
        .state(state[0]),
        .time_counter(time_counter)
    );
    five_SM fs(
                .clk(clk),
                .rst(rst),
                .sw(sw),
                .next(state)
        );

    fnd_ctrl fc(
                .num_in(time_counter),
                .clk(clk),
                .rst(rst),
                .state(state[1]),
                .seg_out(seg),
                .an(an)
            );

endmodule