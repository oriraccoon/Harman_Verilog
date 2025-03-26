module humidity (
    input clk,
    input rst,
    output [15:0] humidity_data,
    output [15:0] temperature_data,
    inout dht_io
);

    wire o_clk;

    tick_gen U_tick_gen (
        .clk  (clk),
        .rst  (rst),
        .o_clk(o_clk)
    );

    DHT_controll_unit U_DHT_controll_unit (
        .clk(clk),
        .rst(rst),
        .tick(o_clk),
        .humidity_data(humidity_data),
        .temperature_data(temperature_data),

        .dht_io(dht_io)
    );

endmodule

module tick_gen #(
    parameter FCOUNT = 1000
) (
    input  clk,
    input  rst,
    output o_clk
);
    reg r_clk;
    reg [$clog2(FCOUNT)-1:0] clk_counter;
    assign o_clk = r_clk;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r_clk <= 0;
            clk_counter <= 0;
        end else begin
            if (clk_counter == FCOUNT - 1) begin
                r_clk <= 1;
                clk_counter <= 0;
            end else begin
                r_clk <= 0;
                clk_counter <= clk_counter + 1;
            end
        end
    end
endmodule

module DHT_controll_unit (
    input clk,
    input rst,
    input tick,
    input s_btn,
    output [3:0] current_state,
    output [15:0] humidity_data,
    output [15:0] temperature_data,
    output led_ind,

    inout dht_io
);
    parameter START_CNT = 1800, WAIT_CNT = 3, DATA_0 = 4, DATA_1 = 7, TIME_OUT = 2000, LOOP_CNT = 50000;

    localparam IDLE = 0, START = 1, WAIT = 2, RESPONSE = 3, READY = 4, READ = 5;

    reg [2:0] state, next;
    reg [$clog2(TIME_OUT)-1:0] tick_count_reg, tick_count_next;
    reg dht_io_reg, dht_io_next;
    reg dht_io_oe_reg, dht_io_oe_next;
    reg led_ind_reg, led_ind_next;

    reg [39:0] data_buffer, data_buffer_next;
    reg [5:0] bit_count, bit_count_next;
    reg dht_io_last, dht_io_sync, dht_io_unsync;
    reg [15:0] humidity_reg, temperature_reg;
    reg valid_data;

    assign current_state = state;
    assign dht_io = (dht_io_oe_reg) ? dht_io_reg : 1'bz;
    assign led_ind = led_ind_reg;
    assign humidity_data = valid_data ? humidity_reg : 16'h0;
    assign temperature_data = valid_data ? temperature_reg : 16'h0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            dht_io_reg <= 0;
            tick_count_reg <= 0;
            led_ind_reg <= 0;
            dht_io_oe_reg <= 1;
            data_buffer <= 0;
            bit_count <= 0;
            dht_io_last <= 0;
            dht_io_sync <= 0;
            dht_io_unsync <= 0;
            humidity_reg <= 0;
            temperature_reg <= 0;
            valid_data <= 0;
        end else begin
            state <= next;
            dht_io_reg <= dht_io_next;
            tick_count_reg <= tick_count_next;
            led_ind_reg <= led_ind_next;
            dht_io_oe_reg <= dht_io_oe_next;
            data_buffer <= data_buffer_next;
            bit_count <= bit_count_next;
            dht_io_last <= dht_io_sync;
            dht_io_sync <= dht_io_unsync;
            dht_io_unsync <= dht_io;
        end
    end

    always @(*) begin
        next = state;
        dht_io_next = dht_io_reg;
        tick_count_next = tick_count_reg;
        led_ind_next = led_ind_reg;
        dht_io_oe_next = dht_io_oe_reg;
        data_buffer_next = data_buffer;
        bit_count_next = bit_count;

        case (state)
            IDLE: begin
                dht_io_next = 1;
                dht_io_oe_next = 1;
                led_ind_next = 0;
                if (s_btn) begin
                    next = START;
                    tick_count_next = 0;
                end
            end

            START: begin
                dht_io_next = 0;
                if (tick) begin
                    tick_count_next = tick_count_reg + 1;
                    if (tick_count_reg == START_CNT) begin
                        next = WAIT;
                        tick_count_next = 0;
                    end
                end
            end

            WAIT: begin
                dht_io_next = 1;
                if (tick) begin
                    tick_count_next = tick_count_reg + 1;
                    if (tick_count_reg == WAIT_CNT) begin
                        next = RESPONSE;
                        tick_count_next = 0;
                    end
                end
            end

            RESPONSE: begin
                dht_io_oe_next = 0;
                if (dht_io_last & ~dht_io_sync) begin
                    next = READY;
                    tick_count_next = 0;
                    bit_count_next = 0;
                end
            end

            READY: begin
                if (~dht_io_last & dht_io_sync) begin
                    next = READ;
                    tick_count_next = 0;
                end
            end

            READ: begin
                if (tick) begin
                    tick_count_next = tick_count_reg + 1;

                    if (~dht_io_last & dht_io_sync) begin
                        if (tick_count_reg > DATA_1) begin
                            data_buffer_next = {data_buffer[38:0], 1'b1};
                        end else if (tick_count_reg > DATA_0) begin
                            data_buffer_next = {data_buffer[38:0], 1'b0};
                        end
                        bit_count_next = bit_count + 1;
                        tick_count_next = 0;
                    end

                    if (bit_count == 40) begin
                        next = IDLE;
                        if (data_buffer[39:32] == (data_buffer[31:24] + data_buffer[23:16] + data_buffer[15:8] + data_buffer[7:0])) begin
                            humidity_reg = {data_buffer[39:32], data_buffer[31:24]};
                            temperature_reg = {data_buffer[23:16], data_buffer[15:8]};
                            valid_data = 1;
                        end else begin
                            valid_data = 0;
                        end
                    end
                end
            end
        endcase
    end

endmodule