module calculator(
                    input [7:0] a,
                    input [7:0] b,
                    input cin,
                    input [1:0] btn,
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

    bcd2seg bs(
                .sum_in(sum_in),
                .btn(btn),
                .seg(seg),
                .an(an)
            );

endmodule