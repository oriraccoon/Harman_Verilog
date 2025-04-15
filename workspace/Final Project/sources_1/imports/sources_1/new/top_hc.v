module top_hc(
    input clk,
    input rst,
    input echo,
    output trig,
    output [1:0] led
    );

    wire [$clog2(400)-1:0] distance;

    myHC_SR04 dut(
    .clk(clk),
    .echo(echo),
    .rst(rst),
    .trig(trig),
    .distance(distance)
    );



    assign led = distance < 10 ? 2'b01 : 2'b10;
    
endmodule
