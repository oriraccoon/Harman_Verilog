module uart_rx(
    input  clk,
    input  rst,
    input  tick,
    input  rx,
    output reg [7:0] data_in,
    output reg tx_done
    );

    parameter IDLE = 0, RECEIVE = 1, START = 2, DATA = 3, STOP = 4;

    reg [2:0] state, next;



endmodule
