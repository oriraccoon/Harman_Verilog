module baud_tick_gen (
    input  clk,
    input  rst,
    output baud_tick
);

    parameter BAUD_RATE = 9600;
    localparam BAUD_COUNT = 100_000_000 / BAUD_RATE;
    reg [$clog2(BAUD_COUNT)-1:0] count_reg, count_next;
    reg tick_reg, tick_next;

    assign baud_tick = tick_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count_reg <= 0;
            tick_reg  <= 0;
        end else begin
            count_reg <= count_next;
            tick_reg  <= tick_next;
        end
    end

    always @(*) begin
        count_next = count_reg;
        tick_next  = tick_reg;
        if (count_reg == BAUD_COUNT - 1) begin
            count_next = 0;
            tick_next  = 1'b1;
        end else begin
            count_next = count_reg + 1;
            tick_next  = 1'b0;
        end
    end


endmodule
