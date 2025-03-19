module tb_register ();
reg clk;
reg [31:0] d;
reg [3:0] addr;
wire [31:0] q;
register dut(
    .clk(clk),
    .d(d),
    .addr(addr),
    .q(q)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    d = 0;
    addr = 0;
    #10
    d = 32'h0123_abcd;
    #2
    @(posedge clk);
    if(d==q) $display("pass");
    else $display("fail");

end


endmodule
