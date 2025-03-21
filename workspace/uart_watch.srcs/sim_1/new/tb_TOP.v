module tb_TOP ();
reg clk, rst, rx;


Top_Uart_Watch DUT(
    .clk(clk),
    .rst(rst),
    // UART_FIFO
    .rx(rx)
    );


    always #1 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        rx = 1;

        #20 
        rst = 0;
        #2
        rx = 0; #10417; send_bit("r"); rx = 1; #31248; // 'r'
        #2
        rx = 0; #10417; send_bit("c"); rx = 1; #31248; // 'c'
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
