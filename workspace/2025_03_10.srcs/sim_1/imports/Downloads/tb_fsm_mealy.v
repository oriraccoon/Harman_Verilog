`timescale 1ns/1ps
module TB_Mealy;
  reg clk, rst_n, x;
  wire z;
  
  seq_detector_1010_Mealy sd(clk, rst_n, x, z);
  initial clk = 0;   
  always #20 clk = ~clk;
    
  initial begin
    x = 0;
    #10 rst_n = 0;
    #20 rst_n = 1;
    
    #30 x = 1;
    #40 x = 1;
    #40 x = 0;
    #40 x = 1;
    #40 x = 0;
    #40 x = 1;
    #40 x = 0;
    #40 x = 1;
    #40 x = 1;
    #40 x = 1;
    #40 x = 0;
    #40 x = 1;
    #40 x = 0;
    #40 x = 1;
    #40 x = 0;
    #100;
    $finish;
  end
  
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
endmodule
