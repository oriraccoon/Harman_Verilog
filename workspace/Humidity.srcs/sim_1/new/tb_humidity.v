`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/26 12:16:49
// Design Name: 
// Module Name: tb_humidity
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_humidity ();
reg clk, rst;
wire dht_io;
reg dht_eo;

reg dht_reg;

assign dht_io = dht_eo ? dht_reg : 1'bz;

humidity dut(
    .clk(clk),
    .rst(rst),
    .dht_io(dht_io)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    dht_eo = 0;

    // dht_io = 0;
    #100 rst = 0;
    #10000;
    wait(dht_io);
    #30000
    dht_eo = 1;
    dht_reg = 0;
    #80000
    dht_reg = 1;
    #80000
    #50000;



end

endmodule
