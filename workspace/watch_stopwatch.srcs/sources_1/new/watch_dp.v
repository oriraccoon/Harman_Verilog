module watch_dp (
    input clk,
    input rst,
    input pm_mod,
    input signed [5:0] sec_mod,
    input signed [5:0] min_mod,
    input signed [5:0] hour_mod,
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
    watch_msec_counter msc (
        .clk(o_clk),
        .rst(rst),
        .ms_counter(ms_counter),
        .ms_tick(ms_tick)
    );


    watch_sec_counter sc (
        .rst(rst),
        .ms_tick(ms_tick),
        .sec_tick(sec_tick),
        .mod_counter(sec_mod),
        .s_counter(s_counter),
        .s_tick(s_tick)
    );



    watch_min_counter mc (
        .rst(rst),
        .s_tick(s_tick),
        .min_tick(min_tick),
        .mod_counter(min_mod),
        .m_counter(m_counter),
        .m_tick(m_tick)
    );

    watch_hour_counter hc (
        .rst(rst),
        .m_tick(m_tick),
        .hour_tick(hour_tick),
        .mod_counter(hour_mod),
        .h_counter(h_counter)
    );

mod_counter_tick_generator sec_tick_gen(
    .clk(clk),
    .rst(rst),
    .mod_counter(sec_mod),
    .m_tick(sec_tick)
);
mod_counter_tick_generator min_tick_gen(
    .clk(clk),
    .rst(rst),
    .mod_counter(min_mod),
    .m_tick(min_tick)
);
mod_counter_tick_generator hour_tick_gen(
    .clk(clk),
    .rst(rst),
    .mod_counter(hour_mod),
    .m_tick(hour_tick)
);

endmodule

module watch_msec_counter (
    input clk,
    input rst,
    output reg [6:0] ms_counter,
    output reg ms_tick
);


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ms_counter <= 0;
        end else begin
            if (ms_counter == 99) begin
                ms_counter <= 0;
                ms_tick <= 1;
            end else begin
                ms_counter <= ms_counter + 1;
                ms_tick <= 0;
            end
        end
    end



endmodule

module watch_sec_counter (
    input rst,
    input ms_tick, // 100 ms가 됐을 때
    input sec_tick, // 합 차 값이 변경됐을 때 틱
    input signed [5:0] mod_counter, // 합 차 값
    output reg [5:0] s_counter,
    output reg s_tick // 60초가 됐을 때 틱
);

    wire tick_val;
    wire val_tick;
    assign tick_val = ms_tick ? 1:0;

    tick_generator (
        .clk(clk),
        .rst(rst),
        .mod_counter(tick_val),
        .m_tick(val_tick)
    );

    always @(posedge rst or posedge val_tick or posedge sec_tick) begin
        if (rst) begin
            s_counter <= 0;
        end else begin
            if(val_tick) begin
                if(s_counter >= 59) begin
                    s_counter = 0;
                    s_tick = 1;
                end else begin
                    s_counter = s_counter + 1;
                    s_tick = 0;
                end
            end else if(sec_tick) begin
                s_counter = s_counter + mod_counter;
                if(s_counter > 59) begin
                    s_counter = 0;
                    s_tick = 1;
                end
            end
        end
    end


endmodule

module watch_min_counter (
    input rst,
    input s_tick,
    input min_tick,
    input signed [5:0] mod_counter,
    output reg [5:0] m_counter,
    output reg m_tick
);

    always @(posedge rst or posedge s_tick or posedge min_tick) begin
        if (rst) begin
            m_counter = 0;
        end else begin
            if(s_tick) begin
                if(m_counter >= 59) begin
                    m_counter = 0;
                    m_tick = 1;
                end else begin
                    m_counter = m_counter + 1;
                    m_tick = 0;
                end
            end else if(min_tick) begin
                m_counter = m_counter + mod_counter;
                if(m_counter > 59) begin
                    m_counter = 0;
                    m_tick = 1;
                end
            end
        end
    end

endmodule

module watch_hour_counter (
    input rst,
    input m_tick,
    input hour_tick,
    input signed [5:0] mod_counter,
    output reg [4:0] h_counter
);

    always @(posedge rst or posedge m_tick or posedge hour_tick) begin
        if (rst) begin
            h_counter <= 12;
        end else begin
            if(m_tick) begin
                if (h_counter >= 23) h_counter = 12;
                else begin
                    h_counter = h_counter + 1;
                end
            end else if(hour_tick) begin
                    h_counter = h_counter + mod_counter;
                    if(h_counter > 23) h_counter = 12;
            end
        end
        
    end

endmodule

module mod_counter_tick_generator (
    input clk,
    input rst,
    input signed [5:0] mod_counter,
    output reg m_tick
);

    reg signed [5:0] prev_mod_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_mod_counter <= 0;
            m_tick <= 0;
        end else begin
            if (mod_counter != prev_mod_counter) begin
                m_tick <= 1;
            end else begin
                m_tick <= 0;
            end
            prev_mod_counter <= mod_counter;
        end
    end

endmodule

module tick_generator (
    input clk,
    input rst,
    input mod_counter,
    output reg m_tick
);

    reg prev_mod_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_mod_counter <= 0;
            m_tick <= 0;
        end else begin
            if (mod_counter != prev_mod_counter) begin
                m_tick <= 1;
            end else begin
                m_tick <= 0;
            end
            prev_mod_counter <= mod_counter;
        end
    end

endmodule