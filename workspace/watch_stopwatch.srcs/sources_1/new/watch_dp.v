module watch_dp (
    input clk,
    input rst,
    input signed [1:0] sec_mod,
    input signed [1:0] min_mod,
    input signed [1:0] hour_mod,
    output [6:0] ms_counter,
    output [5:0] s_counter,
    output [5:0] m_counter,
    output [4:0] h_counter
);

    wire o_clk, ms_tick, s_tick, m_tick;
    wire sec_tick, min_tick, hour_tick;


    clock_divider_100hz hhzd (
        .clk  (clk),
        .rst  (rst),
        .o_clk(o_clk)
    );

    watch_time_counter #(.TICK_COUNT(100), .BIT_WIDTH(7)) U_time_msec( 
    .clk(clk),
    .rst(rst),
    .btn_tick(1'b0),
    .i_tick(o_clk),
    .o_time_counter(ms_counter),
    .o_tick(ms_tick)
    );
    watch_time_counter #(.TICK_COUNT(60), .BIT_WIDTH(6)) U_time_sec( 
    .clk(clk),
    .rst(rst),
    .btn_tick(sec_tick),
    .mod_val(sec_mod),
    .i_tick(ms_tick),
    .o_time_counter(s_counter),
    .o_tick(s_tick)
    );
    watch_time_counter #(.TICK_COUNT(60), .BIT_WIDTH(6)) U_time_min( 
    .clk(clk),
    .rst(rst),
    .btn_tick(min_tick),
    .mod_val(min_mod),
    .i_tick(s_tick),
    .o_time_counter(m_counter),
    .o_tick(m_tick)
    );
    watch_time_counter #(.TICK_COUNT(24), .BIT_WIDTH(5), .DEFAULT_VAL(12)) U_time_hour( 
    .clk(clk),
    .rst(rst),
    .btn_tick(hour_tick),
    .mod_val(hour_mod),
    .i_tick(m_tick),
    .o_time_counter(h_counter)
    );


mod_val_tick_generator sec_tick_gen(
    .clk(clk),
    .rst(rst),
    .mod_val(sec_mod),
    .m_tick(sec_tick)
);
mod_val_tick_generator min_tick_gen(
    .clk(clk),
    .rst(rst),
    .mod_val(min_mod),
    .m_tick(min_tick)
);
mod_val_tick_generator hour_tick_gen(
    .clk(clk),
    .rst(rst),
    .mod_val(hour_mod),
    .m_tick(hour_tick)
);

endmodule


module watch_time_counter #(parameter TICK_COUNT = 100, BIT_WIDTH = 7, DEFAULT_VAL = 0) (
    input clk,
    input rst,
    input i_tick, // 100 ms가 됐을 때
    input btn_tick, // 합 차 값이 변경됐을 때 틱
    input signed [1:0] mod_val, // 합 차 값
    output [BIT_WIDTH-1:0] o_time_counter,
    output o_tick // 60초가 됐을 때 틱
);

    //parameter TICK_COUNT = 60;
    reg [$clog2(TICK_COUNT -1) : 0] count_reg, count_next;
    reg tick_reg, tick_next;

    assign o_time_counter = count_reg;
    assign o_tick = tick_reg;

    always@(posedge clk, posedge rst) begin
    
        if(rst) begin
            count_reg <= DEFAULT_VAL;
            tick_reg <= 0;
        end
        else begin
            count_reg <= count_next;
            tick_reg <= tick_next;
        end
        
    end

    always @(*) begin
        count_next = count_reg;
        tick_next = 0;  
        if(btn_tick) begin
            if(count_reg >= TICK_COUNT -1)begin
                count_next = DEFAULT_VAL;
                tick_next = 1'b1;
            end
            else begin
                count_next = count_reg + mod_val;
                tick_next = 1'b0;
            end
        end if(i_tick) begin
                if(count_reg == TICK_COUNT -1)begin
                    count_next = DEFAULT_VAL;
                    tick_next = 1'b1;
                end
                else begin
                    count_next = count_reg + 1;
                    tick_next = 1'b0;
                end
        end
    
    end


endmodule


module mod_val_tick_generator (
    input clk,
    input rst,
    input signed [1:0] mod_val,
    output reg m_tick
);

    reg [1:0] prev_mod_val;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            m_tick <= 0;
            prev_mod_val <= 0;
        end else begin
            if (mod_val != 0 && prev_mod_val == 0) begin
                m_tick <= 1;
            end else begin
                m_tick <= 0;
            end
            prev_mod_val <= mod_val;
        end
    end

endmodule