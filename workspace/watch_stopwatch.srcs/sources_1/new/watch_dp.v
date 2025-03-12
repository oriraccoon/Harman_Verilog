module watch_dp(
                    input clk,
                    input rst,
                    input pm_mod,
                    input sec_mod,
                    input min_mod,
                    input hour_mod,
                    output [6:0] ms_counter,
                    output [5:0] s_counter,
                    output [5:0] m_counter,
                    output [4:0] h_counter
);

    wire o_clk, ms_tick, s_tick, m_tick;

    clock_divider_100hz hhzd(
    .clk(clk),
    .rst(rst),
    .o_clk(o_clk)
    );
    watch_msec_counter msc(
        .clk(o_clk),
        .rst(rst),
        .ms_counter(ms_counter),
        .ms_tick(ms_tick)
    );
    watch_sec_counter sc(
        .rst(rst),
        .ms_tick(ms_tick),
        .i_btn_clear(i_btn_clear),
        .s_counter(s_counter),
        .s_tick(s_tick)
    );
    watch_min_counter mc(
        .rst(rst),
        .s_tick(s_tick),
        .i_btn_clear(i_btn_clear),
        .m_counter(m_counter),
        .m_tick(m_tick)
    );
    watch_hour_counter hc(
        .rst(rst),
        .m_tick(m_tick),
        .i_btn_clear(i_btn_clear),
        .h_counter(h_counter)
    );

endmodule

module watch_msec_counter(
                    input clk,
                    input rst,
                    output reg [6:0] ms_counter,
                    output reg ms_tick
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ms_counter <= 0;
        end else begin
            // 99 ms 까지
            if(ms_counter == 99) begin
                ms_counter <= 0;
                ms_tick <= 1;
            end
            else begin
                ms_counter <= ms_counter + 1;
                ms_tick <= 0;
            end
        end
    end

endmodule

module watch_sec_counter (
                    input rst,
                    input ms_tick,
                    input pm_mod,
                    input sec_mod,
                    output reg [5:0] s_counter,
                    output reg s_tick
);

    always @(posedge rst or posedge ms_tick) begin
        if(rst) begin
            s_counter <= 0;
        end else begin
            if(ms_tick) begin
                if(s_counter == 59) begin
                    s_counter <= 0;
                    s_tick <= 1;
                end
                else begin
                    s_counter <= s_counter + 1;
                    s_tick <= 0;
                end
            end
        end
    end

    always @(posedge sec_mod) begin
        if (pm_mod) begin
            s_counter <= s_counter - 1;
        end else if(pm_mod == 0) begin
            s_counter <= s_counter + 1;
        end
    end
    
endmodule

module watch_min_counter(
                    input rst,
                    input s_tick,
                    input pm_mod,
                    input min_mod,
                    output reg [5:0] m_counter,
                    output reg m_tick
);

    always @(posedge rst or posedge s_tick) begin
        if(rst) begin
            m_counter <= 0;
        end else begin
            if(s_tick) begin
                if(m_counter == 59) begin
                    m_counter <= 0;
                    m_tick = 1;
                end
                else begin
                    m_counter <= m_counter + 1;
                    m_tick <= 0;
                end
            end
        end
    end

    always @(posedge min_mod) begin
        if (pm_mod) begin
            m_counter <= m_counter - 1;
        end else if(pm_mod == 0) begin
            m_counter <= m_counter + 1;
        end
    end

endmodule

module watch_hour_counter(
                    input rst,
                    input m_tick,
                    input pm_mod,
                    input hour_mod,
                    output reg [4:0] h_counter
);

    always @(posedge rst or posedge m_tick) begin
        if(rst) begin
            h_counter <= 0;
        end else begin
            if(m_tick) begin
                if(h_counter == 23) begin
                    h_counter <= 0;
                end
                else h_counter <= h_counter + 1;
            end
        end
    end

    always @(posedge hour_mod) begin
        if (pm_mod) begin
            h_counter <= h_counter - 1;
        end else if(pm_mod == 0) begin
            h_counter <= h_counter + 1;
        end
    end

endmodule
