module four_bits_adder(
                    input [0:3] a,
                    input [0:3] b,
                    output [0:4] result
                );

wire c1, c2, c3;

    Full_adder adder1(
                         .a(a[3]),
                         .b(b[3]),
                         .cin(0),
                         .cout(c1),
                         .sum(result[4])
                         
                        );

    Full_adder adder2(
                         .a(a[2]),
                         .b(b[2]),
                         .cin(c1),
                         .cout(c2),
                         .sum(result[3])
                         
                        );

    Full_adder adder3(
                         .a(a[1]),
                         .b(b[1]),
                         .cin(c2),
                         .cout(c3),
                         .sum(result[2])
                         
                        );

    Full_adder adder4(
                         .a(a[0]),
                         .b(b[0]),
                         .cin(c3),
                         .cout(result[0]),
                         .sum(result[1])
                        );
                        
endmodule

                        