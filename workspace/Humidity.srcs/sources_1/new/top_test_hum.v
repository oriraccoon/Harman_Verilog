`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/26 16:25:48
// Design Name: 
// Module Name: top_test_hum
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


module top_test_hum (
    input clk,
    input rst,
    output [1:0] led,
    inout dht_io
);
wire [15:0] humidity_data, temperature_data;

ila_0 ila(
clk,


humidity_data,
temperature_data
);

humidity dtest(
    .clk(clk),
    .rst(rst),
    .humidity_data(humidity_data),
    .temperature_data(temperature_data),
    .dht_io(dht_io)
);

assign led = humidity_data == 0 ? 2'b01 : 2'b10;

endmodule
