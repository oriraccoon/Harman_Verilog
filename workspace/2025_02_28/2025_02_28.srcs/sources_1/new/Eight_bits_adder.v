module Eight_bits_adder(
input [7:0] a,
input [7:0] b,
output [8:0] sum
);

Four_bits_adder fba1(.a(a), .b(b), .result