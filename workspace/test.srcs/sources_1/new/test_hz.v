`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/07 11:00:27
// Design Name: 
// Module Name: test_hz
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top_module(
    input clk,
    input rst,
    output tick,
    output [$clog2(10_000) : 0] counter_reg,
    output [$clog2(10_000) : 0] counter_next
);


t100_Hz_divider td(
    .clk(clk),
    .rst(rst),
    .o_clk(tick)
);

counter_tick ct(
    .clk(clk),
    .rst(rst),
    .tick(tick),
    .counter_reg(counter_reg),
    .counter_next(counter_next)
);

endmodule

module t100_Hz_divider(
    input clk,
    input rst,
    output o_clk
);

	parameter FCOUNT = 1_000_000;

    reg [$clog2(FCOUNT)-1:0] r_counter;
    reg r_clk;

    assign o_clk = r_clk;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            r_counter <= 0;
            r_clk <= 1'b0;
        end else begin
            if(r_counter == FCOUNT - 1 ) begin // 1kHz
                r_counter <= 0;
                r_clk <= 1;
            end else begin
                r_counter <= r_counter + 1;
                r_clk <= 1'b0;
            end
        end
    end
endmodule

module counter_tick(
    input clk,
    input rst,
    input tick,
    output [$clog2(10_000) - 1 : 0] counter,
    output reg [$clog2(10_000) : 0] counter_reg,
    output reg [$clog2(10_000) : 0] counter_next
);
    // like state, like next_state
    

    always @(posedge clk, posedge rst) begin
        if(rst) counter_reg <= 0;
        else counter_reg <= counter_next;
    end

    always @(*) begin
        counter_next = counter_reg;
        if(tick==1'b1) begin 
            if (counter_reg == 10_000 - 1) begin
                counter_next <= 0;
            end else begin
                counter_next = counter_reg + 1;
            end
        end
        
    end

endmodule