module watch_dp (
    input clk,
    input rst,
    input sec_mod,
    input min_mod,
    input hour_mod,
    input pm_mod,
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
    .i_tick(o_clk),
    .o_time_counter(ms_counter),
    .o_tick(ms_tick)
    );
    watch_time_counter #(.TICK_COUNT(60), .BIT_WIDTH(6)) U_time_sec( 
    .clk(clk),
    .rst(rst),
    .pm_mod(pm_mod),
    .mod_val(sec_mod),
    .i_tick(ms_tick),
    .o_time_counter(s_counter),
    .o_tick(s_tick)
    );
    watch_time_counter #(.TICK_COUNT(60), .BIT_WIDTH(6)) U_time_min( 
    .clk(clk),
    .rst(rst),
    .pm_mod(pm_mod),
    .mod_val(min_mod),
    .i_tick(s_tick),
    .o_time_counter(m_counter),
    .o_tick(m_tick)
    );
    watch_time_counter #(.TICK_COUNT(24), .BIT_WIDTH(5), .START_VAL(12)) U_time_hour( 
    .clk(clk),
    .rst(rst),
    .pm_mod(pm_mod),
    .mod_val(hour_mod),
    .i_tick(m_tick),
    .o_time_counter(h_counter)
    );

endmodule


module watch_time_counter #(parameter TICK_COUNT = 100, BIT_WIDTH = 7, DEFAULT_VAL = 0, START_VAL = 0) (
    input clk,
    input rst,
    input i_tick, // 100 ms가 됐을 때
    input pm_mod,
    input mod_val, // 합 차 값
    output [BIT_WIDTH-1:0] o_time_counter,
    output o_tick // 60초가 됐을 때 틱
);

    //parameter TICK_COUNT = 60;
    reg [$clog2(TICK_COUNT -1) : 0] count_reg, count_next;
    reg tick_reg, tick_next;

    assign o_time_counter = count_reg;
    assign o_tick = tick_reg;

    initial count_reg = START_VAL;

    always@(posedge clk, posedge rst) begin
    
        if(rst) begin
            count_reg <= START_VAL;
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
        if(mod_val != 0) begin
            if (pm_mod == 1) begin
                if (count_reg == 0) begin
                    count_next = TICK_COUNT - 1;
                end else begin
                    count_next = count_reg - mod_val;
                end
            end else if (pm_mod == 0) begin
                if(count_reg >= TICK_COUNT -1)begin
                    count_next = DEFAULT_VAL;
                    tick_next = 1'b1;
                end
                else begin
                    count_next = count_reg + mod_val;
                    tick_next = 1'b0;
                    end
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