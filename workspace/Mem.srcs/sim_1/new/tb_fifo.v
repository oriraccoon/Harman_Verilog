module tb_fifo ();
    reg clk, rst, wr, rd;
    reg  [7:0] wdata;
    wire [7:0] rdata;
    wire empty, full;


    fifo dut (
        .clk(clk),
        .rst(rst),
        .wr(wr),
        .rd(rd),
        .wdata(wdata),
        .rdata(rdata),
        .empty(empty),
        .full(full)
    );
    integer i;
    always #1 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        wr = 0;
        rd = 0;
        wdata = 0;
        #10 rst = 0;
        @(posedge clk);
        wdata = 2;
        @(posedge clk);
        wr = 1;
        @(posedge clk);
        wr = 0;
        @(posedge clk);
        rd = 1;
        #10
        for (i = 0; i<100; i = i + 1) begin
            @(posedge clk);
            wdata=$random%256;
            @(posedge clk);
            wr = 1;
            rd = 1;
            @(posedge clk); 
            wr = 0;
            @(posedge clk); 
            wr = 1;
            rd = 0;
            @(posedge clk); 
            wr = 0; 
        end
        #1
        wr = 1;
        #33
        wr = 0;
        #1
        rd = 1;
        #33
        rd = 0; 
        #100
        $stop;
    end
endmodule
