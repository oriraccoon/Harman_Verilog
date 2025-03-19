module tb_mem_ip ();

    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8;
    reg clk, wr;
    reg [DATA_WIDTH-1:0] wdata;
    reg [ADDR_WIDTH-1:0] waddr;
    wire [DATA_WIDTH-1:0] rdata;


ram_ip dut
(
    .clk(clk),
    .waddr(waddr),
    .wdata(wdata),
    .wr(wr),
    .rdata(rdata)
);

always #1 clk = ~clk;

integer i;
reg [DATA_WIDTH-1:0] rand_data;
reg [ADDR_WIDTH-1:0] rand_addr;

initial begin
    clk = 0;
    waddr = 0;
    wdata = 0;
    rand_addr = 0;
    rand_data = 0;
    wr = 0;
    #10
    for (i = 0; i<50; i=i+1) begin
        @(posedge clk);
        rand_addr = $random%16;
        rand_data = $random%256;
        wr = 1;
        waddr = rand_addr;
        wdata = rand_data;
        @(posedge clk);
        waddr = rand_addr;
        
        #10
        // == 값 비교, === 비트 비교
        if (rdata === wdata) begin // 입력과 출력이 같은지 비교
            $display("pass");
        end else $display("fail addr = %d, rdata = %h, wdata = %h",waddr, rdata, wdata);
    end

    #100
    $stop;
end

endmodule
