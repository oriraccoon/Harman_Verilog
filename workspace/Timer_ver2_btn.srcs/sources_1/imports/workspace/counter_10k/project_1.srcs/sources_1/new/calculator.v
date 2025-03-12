module Top_Module(
                    input clk,
                    input rst,
                    input [2:0] btn,
                    output [7:0] seg,
                    output [3:0] an
                );

    wire [26:0] time_counter;
    wire [1:0] state;
    wire [2:0] o_btn;

    btn_edge_trigger bet1(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(btn[0]),
                        .o_btn(o_btn[0])
    );
    btn_edge_trigger bet2(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(btn[1]),
                        .o_btn(o_btn[1])
    );
    btn_edge_trigger bet3(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(btn[2]),
                        .o_btn(o_btn[2])
    );

    hmsms_counter timer(
        .clk(clk),
        .rst(rst),
        .state(state[0]),
        .btn(o_btn[2]),
        .time_counter(time_counter)
    );
    five_SM fs(
                .clk(clk),
                .rst(rst),
                .btn(o_btn[1:0]),
                .state(state)
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