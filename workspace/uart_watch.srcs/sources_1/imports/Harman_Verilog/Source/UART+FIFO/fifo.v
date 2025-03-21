module fifo #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input wr,
    input rd,
    input [DATA_WIDTH-1:0] wdata,
    output [DATA_WIDTH-1:0] rdata,
    output empty,
    output full  
);

    wire [ADDR_WIDTH-1:0] waddr;
    wire [ADDR_WIDTH-1:0] raddr;

    fifo_control_unit #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) U_fifo_cu(
        .clk(clk),
        .rst(rst),
        .wr(wr),
        .rd(rd),
        .waddr(waddr),
        .raddr(raddr),
        .empty(empty),
        .full(full)    
    );

    register_file #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) U_register_file(
        .clk(clk),
        .waddr(waddr),
        .wdata(wdata),
        .wr({~full&wr}),
        .raddr(raddr),
        .rdata(rdata)
);
    
endmodule

module fifo_control_unit #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input wr,
    input rd,
    output [ADDR_WIDTH-1:0] waddr,
    output [ADDR_WIDTH-1:0] raddr,
    output reg empty,
    output reg full    
    );

    reg [ADDR_WIDTH-1:0] w_ptr, r_ptr, w_ptr_next, r_ptr_next;
    reg empty_next, full_next;
    assign waddr = w_ptr;
    assign raddr = r_ptr;
    reg wait_clk;
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            empty <= 1;
            full <= 0;
            w_ptr <= 0;
            r_ptr <= 0;
            wait_clk <= 0;
        end else begin
            empty <= empty_next;
            full <= full_next;
            w_ptr <= w_ptr_next;
            r_ptr <= r_ptr_next;
            wait_clk <= ~wait_clk;
        end    
    end

    always @(*) begin
        empty_next = empty;
        full_next = full;
        w_ptr_next = w_ptr;
        r_ptr_next = r_ptr;
        case ({wr,rd})
            2'b01: begin
                if(!empty) begin
                    r_ptr_next = r_ptr + 1;
                    full_next = 0;
                    if(r_ptr_next == w_ptr) empty_next = 1;
                end
            end
            2'b10: begin
                if(!full) begin
                    w_ptr_next = w_ptr + 1;
                    empty_next = 0;
                    if(w_ptr_next == r_ptr) full_next = 1;
                end
            end
            2'b11: begin
                if(empty)begin
                    w_ptr_next = w_ptr + 1;
                    empty_next = 0;
                end else if(full) begin
                    r_ptr_next = r_ptr + 1;
                    full_next = 0;
                end else begin
                    w_ptr_next = w_ptr + 1;
                    r_ptr_next = r_ptr + 1;
                end
            end
        endcase
    end
endmodule

module register_file #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8
)(
    input clk,
    input [ADDR_WIDTH-1:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    input wr,
    input [ADDR_WIDTH-1:0] raddr,
    input done,
    output [DATA_WIDTH-1:0] rdata
);
    reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

    always @(posedge clk ) begin
        if(wr) begin
            mem[waddr] <= wdata;
        end
    end


    assign rdata = mem[raddr];
    
endmodule