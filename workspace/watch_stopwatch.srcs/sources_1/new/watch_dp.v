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
        .clk(o_clk),
        .rst(rst),
        .ms_tick(ms_tick),
        .sec_mod(w_sec_mod),
        .pm_mod(pm_mod),
        .s_counter(s_counter),
        .s_tick(s_tick)
    );
    watch_min_counter mc(
				.clk(o_clk),
        .rst(rst),
        .s_tick(s_tick),
        .min_mod(w_min_mod),
        .pm_mod(pm_mod),
        .m_counter(m_counter),
        .m_tick(m_tick)
    );
    watch_hour_counter hc(
				.clk(o_clk),
        .rst(rst),
        .m_tick(m_tick),
        .hour_mod(w_hour_mod),
        .pm_mod(pm_mod),
        .h_counter(h_counter)
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
    input clk,
    input rst,
    input ms_tick,
    input sec_mod,
    input pm_mod,
    output reg [5:0] s_counter,
    output reg s_tick
);

    reg [5:0] w_s_counter;
    reg signed [1:0] mod_counter;

    always @(posedge rst or posedge ms_tick) begin
        if (rst) begin
            w_s_counter <= 0;
            s_tick <= 0;
        end else begin
            if (w_s_counter >= 59) begin
                w_s_counter <= 0;
                s_tick <= 1;
            end else begin
                w_s_counter <= w_s_counter + 1;
                s_tick <= 0;
            end
        end
    end

    always @(posedge sec_mod) begin
        if (sec_mod) begin
            mod_counter <= pm_mod ? -1 : 1;
        end else begin
            mod_counter <= 0;
        end
    end

    always @(posedge clk) begin
        s_counter <= w_s_counter + mod_counter;
    end

endmodule

module watch_min_counter(
										input clk,
                    input rst,
                    input s_tick,
										input min_mod,
										input pm_mod,
                    output reg [5:0] m_counter,
                    output reg m_tick
);

    reg [5:0] w_m_counter;
    reg signed [1:0] mod_counter;

    always @(posedge rst or posedge s_tick) begin
        if (rst) begin
            w_m_counter <= 0;
            m_tick <= 0;
        end else begin
            if (s_tick) begin
                if (w_m_counter == 59) begin
                    w_m_counter <= 0;
                    m_tick <= 1;
                end else begin
                    w_m_counter <= w_m_counter + 1;
                    m_tick <= 0;
                end
            end
        end
    end

    always @(posedge min_mod) begin
        if (min_mod) begin
            mod_counter <= pm_mod ? -1 : 1;
        end else begin
            mod_counter <= 0;
        end
    end

    always @(posedge clk) begin
        m_counter <= w_m_counter + mod_counter;
    end

endmodule

module watch_hour_counter(
										input clk,
                    input rst,
                    input m_tick,
										input hour_mod,
										input pm_mod,
                    output reg [4:0] h_counter
);

    reg [5:0] w_h_counter;
    reg signed [1:0] mod_counter;

    initial begin
        h_counter = 12;
    end

    always @(posedge rst or posedge m_tick) begin
        if (rst) begin
            w_h_counter <= 12;
        end else begin
        if (m_tick) begin
                if (w_h_counter == 23) begin
                    w_h_counter <= 12;
                end else begin
                    w_h_counter <= w_h_counter + 1;
                end
            end
        end
    end

    always @(posedge hour_mod) begin
        if (hour_mod) begin
            mod_counter <= pm_mod ? -1 : 1;
        end else begin
            mod_counter <= 0;
        end
    end

    always @(posedge clk) begin
        h_counter <= w_h_counter + mod_counter;
    end

endmodule
