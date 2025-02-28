module Four_bits_adder(
                        input [3:0] a,
                        input [3:0] b,
                        input cin,
                        output [3:0] result,
                        output overflow
                        );

  wire [2:0] c1;


  Full_adder fa1(
                  .a(a[0]),
                  .b(b[0]),
                  .cin(cin),
                  .sum(result[0]),
                  .cout(c1[0])
                );                        
  Full_adder fa2(
                  .a(a[1]),
                  .b(b[1]),
                  .cin(c1[0]),
                  .sum(result[1]),
                  .cout(c1[1])
                );                        
  Full_adder fa3(
                  .a(a[2]),
                  .b(b[2]),
                  .cin(c1[1]),
                  .sum(result[2]),
                  .cout(c1[2])
                );                        
  Full_adder fa4(
                  .a(a[3]),
                  .b(b[3]),
                  .cin(c1[2]),
                  .sum(result[3]),
                  .cout(overflow)
                );
                  
endmodule