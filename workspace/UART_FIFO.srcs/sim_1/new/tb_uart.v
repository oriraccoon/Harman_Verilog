`timescale 1ns/1ps

module TOP_UART_FIFO_tb();
    reg clk, rst, rx;
    wire tx;

    TOP_UART_FIFO UUT (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx(tx)
    );

    always #1 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        rx = 1;

        #20 
        rst = 0;
        #2
        rx = 0; #10417; send_bit(8'h68); rx = 1; #31248; // 'h'
        #2
        rx = 0; #10417; send_bit(8'b01100101); rx = 1; #31248; // 'e'
        #2
        rx = 0; #10417; send_bit(8'h6C); rx = 1; #31248; // 'l'
        #2
        rx = 0; #10417; send_bit(8'h6C); rx = 1; #31248; // 'l'
        #2
        rx = 0; #10417; send_bit(8'h6F); rx = 1; #31248; // 'o'

        #500;

        rx = 0; #10417; send_bit(8'h77); rx = 1; #31248; // 'w'
        #2
        rx = 0; #10417; send_bit(8'h6F); rx = 1; #31248; // 'o'
        #2
        rx = 0; #10417; send_bit(8'h72); rx = 1; #31248; // 'r'
        #2
        rx = 0; #10417; send_bit(8'h6C); rx = 1; #31248; // 'l'
        #2
        rx = 0; #10417; send_bit(8'h64); rx = 1; #31248; // 'd'

        #10000;
        $finish;
    end

    task send_bit(input [7:0] data);
        integer i;
        for (i = 0; i < 8; i = i + 1) begin
            rx = data[i];
            #20834;
        end
    endtask

endmodule
