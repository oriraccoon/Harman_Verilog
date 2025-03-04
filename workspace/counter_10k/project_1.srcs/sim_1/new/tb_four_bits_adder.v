`timescale 1ns / 1ps

module tb_four_bits_adder();
    reg [3:0] a, b;
    reg cin;
    wire [3:0] result;
    wire overflow;

    Four_bits_adder dut(
                        .a(a),
                        .b(b),
                        .cin(cin),
                        .result(result),
                        .overflow(overflow)
                        );
integer i;
integer j;

    initial begin
        a = 4'b0000;
        b = 4'b0000;
        cin = 0;
        for (i=0; i<16; i=i+1) begin
            #10
            a = a + 1;
            for (j=0; j<16; j=j+1) begin
                #10
                b = b + 1;
            end
        end
        #10
        $finish;
    end

endmodule
