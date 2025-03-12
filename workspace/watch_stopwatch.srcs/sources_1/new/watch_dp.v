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
    wire w_sec_mod, w_min_mod, w_hour_mod;

    wire [5:0] w_s_counter, w_m_counter;
    wire [4:0] w_h_counter;

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
        .s_counter(w_s_counter),
        .s_tick(s_tick)
    );
    watch_min_counter mc(
        .rst(rst),
        .s_tick(s_tick),
        .m_counter(w_m_counter),
        .m_tick(m_tick)
    );
    watch_hour_counter hc(
        .rst(rst),
        .m_tick(m_tick),
        .h_counter(w_h_counter)
    );

    btn_edge_trigger U_btn_sec_D(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(sec_mod),
                        .o_btn(w_sec_mod)
    );
    btn_edge_trigger U_btn_min_D(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(min_mod),
                        .o_btn(w_min_mod)
    );
    btn_edge_trigger U_btn_hour_D(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(hour_mod),
                        .o_btn(w_hour_mod)
    );

    btn_cal bc(
        .w_sec_mod(w_sec_mod),
        .w_min_mod(w_hour_mod),
        .w_hour_mod(w_hour_mod),
        .pm_mod(pm_mod),
        .w_s_counter(w_s_counter),
        .w_m_counter(w_m_counter),
        .w_h_counter(w_h_counter),
        .s_counter(s_counter),
        .m_counter(m_counter),
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
                    output reg [5:0] s_counter,
                    output reg s_tick
);

always @(posedge rst or posedge ms_tick) begin
    if (rst) begin
        s_counter <= 0;
        s_tick <= 0;
    end else begin
        if (ms_tick) begin
            if (s_counter == 59) begin
                s_counter <= 0;
                s_tick <= 1;
            end else begin
                s_counter <= s_counter + 1;
                s_tick <= 0;
            end
        end
    end
end

    
endmodule

module watch_min_counter(
                    input rst,
                    input s_tick,
                    output reg [5:0] m_counter,
                    output reg m_tick
);

    always @(posedge rst or posedge s_tick) begin
        if (rst) begin
            m_counter <= 0;
            m_tick <= 0;
        end else begin
            if (s_tick) begin
                if (m_counter == 59) begin
                    m_counter <= 0;
                    m_tick <= 1;
                end else begin
                    m_counter <= m_counter + 1;
                    m_tick <= 0;
                end
            end
        end
    end


endmodule

module watch_hour_counter(
                    input rst,
                    input m_tick,
                    output reg [4:0] h_counter
);

    initial begin
        h_counter = 12;
    end

    always @(posedge rst or posedge m_tick) begin
        if (rst) begin
            h_counter <= 12;
        end else begin
        if (m_tick) begin
                if (h_counter == 23) begin
                    h_counter <= 12;
                end else begin
                    h_counter <= h_counter + 1;
                end
            end
        end
    end


endmodule

module btn_cal (
    input w_sec_mod,
    input w_min_mod,
    input w_hour_mod,
    input pm_mod,
    input [5:0] w_s_counter,
    input [5:0] w_m_counter,
    input [4:0] w_h_counter,
    output reg [5:0] s_counter,
    output reg [5:0] m_counter,
    output reg [4:0] h_counter
);
    always @(w_sec_mod or w_min_mod or w_hour_mod) begin
        if(w_sec_mod) begin
            if(pm_mod) s_counter = w_s_counter - 1;
            else s_counter = w_s_counter + 1;
        end else if(w_min_mod) begin
            if(pm_mod) m_counter = w_m_counter - 1;
            else m_counter = w_m_counter + 1;
        end else if(w_hour_mod) begin
            if(pm_mod) h_counter = w_h_counter - 1;
            else h_counter = w_h_counter + 1;
        end else begin
            s_counter = w_s_counter;
            m_counter = w_m_counter;
            h_counter = w_h_counter;
        end
    end
endmodule