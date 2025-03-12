module Full_adder(
                    input a,
                    input b,
                    input cin,
                    output sum,
                    output cout
                 );
             
    wire h1_sum, h1_carry, h2_carry;
             
    half_adder ha1(a, b, h1_sum, h1_carry);
    half_adder ha2(cin, h1_sum, sum, h2_carry);
    
    or (cout, h1_carry, h2_carry);
                                  
endmodule
                 