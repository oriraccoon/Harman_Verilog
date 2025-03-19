module ram_ip #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8)
(
    input clk,
    input [ADDR_WIDTH-1:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    input wr,
    output [DATA_WIDTH-1:0] rdata
);

    reg [DATA_WIDTH-1:0] ram[0:2**ADDR_WIDTH-1];

    // write
    always @(posedge clk) begin
        if(wr) begin
            ram[waddr] <= wdata;
        end
    end

    assign rdata = ram[waddr];

/*
    // read
    always @(posedge clk) begin
        if(!wr) begin
            rdata <= ram[waddr];
        end
    end
*/
endmodule