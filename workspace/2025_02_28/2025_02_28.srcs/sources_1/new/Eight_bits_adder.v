module Eight_bits_adder(
input [7:0] a,
input [7:0] b,
input cin,
output [8:0] sum
);

wire fba_over;

	Four_bits_adder fba1(.a(a[3:0]),
												.b(b[3:0]),
												.cin(cin),
												.result(sum[3:0),
												.overflow(fba_over)
);

	Four_bits_adder fba2(.a(a[7:4]),
                       .b(b[7:4]),
                       .cin(fba_over),
                       .result(sum[7:4]),
                       .overflow(sum[8])
);