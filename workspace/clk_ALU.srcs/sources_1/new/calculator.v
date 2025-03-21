module calculator(
                    input [7:0] a,
                    input [7:0] b,
                    input cin,
                    input clk,
                    input rst,
                    output [7:0] seg,
                    output [3:0] an
                );

    wire [8:0] sum_in;

    Eight_bits_adder fba(
                        .a(a),
                        .b(b),
                        .cin(cin),
                        .sum(sum_in)
                    );

    fnd_ctrl fc(
                .sum_in(sum_in),
                .clk(clk),
                .rst(rst),
                .seg_out(seg),
                .an(an)
            );

endmodule