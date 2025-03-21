module clock_divider_200hz(
    input clk,
    input rst,
    output o_clk
);

	parameter FCOUNT = 500_000;

    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;
    
    always@(posedge clk, posedge rst) begin
        if(rst) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == FCOUNT - 1 ) begin // 500Hz
                r_counter <= 0;
                r_clk <= 1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule

// FSM
module clock_divider_100hz(
    input clk,
    input rst,
    output o_clk
);

    parameter FCOUNT = 1_000_000;
    reg [$clog2(FCOUNT) - 1:0] count_reg, count_next;
    reg clk_reg, clk_next;

    assign o_clk = clk_reg;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            count_reg <= 0;
            clk_reg <= 0;
        end else begin
            count_reg <= count_next;
            clk_reg <= clk_next;
        end
    end

    always @(*) begin
        count_next = count_reg;
        clk_next = clk_reg;
        if (count_reg == FCOUNT - 1) begin
            count_next = 0;
            clk_next = 1'b1;
        end else begin
            count_next = count_reg + 1;
            clk_next = 1'b0;
        end
    end
    
endmodule

// non FSM
module clock_divider_1hz(
    input clk,
    input rst,
    output o_clk
);

	parameter FCOUNT = 100_000_000;

    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == FCOUNT - 1 ) begin // 1Hz
                r_counter <= 0;
                r_clk <= 1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule


