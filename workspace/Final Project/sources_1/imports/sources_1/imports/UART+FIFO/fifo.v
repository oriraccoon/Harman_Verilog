module fifo #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] w_data,
    input w_en,
    input r_en,
    output [DATA_WIDTH-1:0] r_data,
    output full,
    output empty
);

    wire [ADDR_WIDTH-1:0] w_addr, r_addr;

    // module instance
    fifo_control_unit #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) U_FIFO_CU(
    .clk(clk),
    .rst(rst),
    .w_en(w_en),
    .r_en(r_en),
    .w_addr(w_addr),
    .r_addr(r_addr),
    .full(full),
    .empty(empty)
    );

    register_file #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) U_REGISTER(
    .clk(clk),
    .w_data(w_data),  
    .w_addr(w_addr), 
    .w_en({~full&w_en}),
    .r_addr(r_addr),
    .r_data(r_data)
    );

endmodule

module register_file #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8
)(
    input clk,
    input [DATA_WIDTH-1:0] w_data,  // 8bit 
    input [ADDR_WIDTH-1:0] w_addr,  // 16개
    input w_en,
    input [ADDR_WIDTH-1:0] r_addr,
    output [DATA_WIDTH-1:0] r_data
);

    reg [DATA_WIDTH-1:0] mem[0:2**ADDR_WIDTH-1];  // 4bit address

    // write
    always @(posedge clk) begin
        if (w_en) begin
            mem[w_addr] <= w_data;
        end
    end

    // resd
    assign r_data = mem[r_addr];

endmodule

module fifo_control_unit #(
    parameter ADDR_WIDTH = 4, DATA_WIDTH = 8
)(
    input clk,
    input rst,
    input w_en,
    input r_en,
    output [ADDR_WIDTH-1:0] w_addr,
    output [ADDR_WIDTH-1:0] r_addr,
    output full,
    output empty
);
    // 1bit 상태 output
    reg full_reg, full_next, empty_reg, empty_next;
    // W, R address 관리
    reg [ADDR_WIDTH-1:0] w_ptr_reg, w_ptr_next, r_ptr_reg, r_ptr_next;

    assign w_addr = w_ptr_reg;
    assign r_addr = r_ptr_reg;
    assign full = full_reg;
    assign empty = empty_reg;

    // state
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            full_reg  <= 0;
            empty_reg <= 1;
            w_ptr_reg <= 0;
            r_ptr_reg <= 0;
        end else begin
            full_reg  <= full_next;
            empty_reg <= empty_next;
            w_ptr_reg <= w_ptr_next;
            r_ptr_reg <= r_ptr_next;
        end
    end

    //next
    always @(*) begin
        full_next  = full_reg;
        empty_next = empty_reg;
        w_ptr_next = w_ptr_reg;
        r_ptr_next = r_ptr_reg;
        case ({w_en, r_en})  // state 외부에서 입력으로 변경됨.
            2'b01: begin  // r_en가 1일때, read
                if (!empty_reg) begin
                    r_ptr_next = r_ptr_reg + 1;
                    full_next  = 1'b0;
                    if (w_ptr_reg == r_ptr_next) begin
                        empty_next = 1'b1;
                    end
                end
            end
            2'b10: begin  // w_en가 1일때, write
                if (!full_reg) begin
                    w_ptr_next = w_ptr_reg + 1;
                    empty_next = 1'b0;
                    if (w_ptr_next == r_ptr_reg) begin
                        full_next = 1'b1;
                    end
                end
            end
            2'b11: begin
                if (empty_reg) begin  // pop 먼저 조건
                    w_ptr_next = w_ptr_reg + 1;
                    empty_next = 1'b0;
                end else if (full_reg) begin
                    r_ptr_next = r_ptr_reg + 1;
                    full_next  = 1'b0;
                end else begin
                    w_ptr_next = w_ptr_reg + 1;
                    r_ptr_next = r_ptr_reg + 1;
                end
            end
        endcase
    end
endmodule