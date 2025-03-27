module humidity (
    input clk,
    input rst,
    output [15:0] humidity_data,
    output [15:0] temperature_data,
    output [2:0] c_state,
    output [5:0] bit_count,
    inout dht_io
);

    wire o_clk;

    tick_gen #(.FCOUNT(100)) U_tick_gen (
        .clk  (clk),
        .rst  (rst),
        .o_clk(o_clk)
    );

    DHT_controll_unit U_DHT_controll_unit (
        .clk(clk),
        .rst(rst),
        .tick(o_clk),
        .c_state(c_state),
        .humidity_data(humidity_data),
        .temperature_data(temperature_data),
        .bit_count_o(bit_count),
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
    output [2:0] c_state,
    output [5:0] bit_count_o,
    output reg [15:0] humidity_data,
    output reg [15:0] temperature_data,

    inout dht_io
);
    parameter START_CNT = 18000, WAIT_CNT = 30, DATA_0 = 40, TIME_OUT = 20000;
    
    wire o_clk;

    localparam IDLE = 0, START = 1, WAIT = 2, RESPONSE = 3, READY = 4, SET = 5, READ = 6;
    
    tick_gen #(.FCOUNT(50_000_000)) half_sec(
        .clk(clk),
        .rst(rst),
        .o_clk(o_clk)
    );

    reg [2:0] state, next;
    reg [$clog2(TIME_OUT)-1:0] tick_count_reg, tick_count_next;
    reg dht_io_reg, dht_io_next;
    reg dht_io_oe_reg, dht_io_oe_next;
    reg [4:0] sec_reg, sec_next;
    reg [39:0] data_buffer, data_buffer_next;
    reg [5:0] bit_count, bit_count_next;
    reg dht_io_sync;
    reg [15:0] humidity_reg, humidity_next, temperature_reg, temperature_next;
    assign c_state = state;
    assign bit_count_o = bit_count;
    assign dht_io = (dht_io_oe_reg) ? dht_io_reg : 1'bz;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            dht_io_reg <= 0;
            tick_count_reg <= 0;
            dht_io_oe_reg <= 1;
            data_buffer <= 0;
            bit_count <= 0;
            humidity_reg <= 0;
            temperature_reg <= 0;
            dht_io_sync <= 0;
            sec_reg <= 0;
        end else begin
            state <= next;
            dht_io_reg <= dht_io_next;
            tick_count_reg <= tick_count_next;
            dht_io_oe_reg <= dht_io_oe_next;
            data_buffer <= data_buffer_next;
            bit_count <= bit_count_next;
            sec_reg <= sec_next;
            dht_io_sync <= dht_io;
            humidity_reg <= humidity_next;
            humidity_data <= humidity_reg;
            temperature_reg <= temperature_next;
            temperature_data <= temperature_reg;
        end
    end



    always @(*) begin
    next = state;
    dht_io_next = dht_io_reg;
    tick_count_next = tick_count_reg;
    dht_io_oe_next = dht_io_oe_reg;
    data_buffer_next = data_buffer;
    bit_count_next = bit_count;
    sec_next = sec_reg;
    humidity_next = humidity_reg;
    temperature_next = temperature_reg;

    case (state)
        IDLE: begin
            dht_io_oe_next = 1;
            dht_io_next = 1;
            if (o_clk) sec_next = sec_next + 1;
            else if (sec_reg == 30) begin
                next = START;
                sec_next = 0;
                tick_count_next = 0;
            end
        end

        START: begin
            dht_io_next = 0;
            if (tick) begin
                if (tick_count_reg == START_CNT) begin
                    next = WAIT;
                    tick_count_next = 0;
                end else begin
                    tick_count_next = tick_count_reg + 1;
                end
            end
        end

        WAIT: begin
            dht_io_next = 1;
            if (tick) begin
                if (tick_count_reg == WAIT_CNT) begin
                    next = RESPONSE;
                    tick_count_next = 0;
                    dht_io_oe_next = 0;
                end else begin
                    tick_count_next = tick_count_reg + 1;
                end
            end
        end

        RESPONSE: begin
            if(tick) begin
                if(tick_count_reg >= 30) begin
                    if (dht_io) begin
                        next = READY;
                        tick_count_next = 0;
                    end
                end else tick_count_next = tick_count_reg + 1;
            end
        end

        READY: begin
            if(tick) begin
                if(tick_count_reg >= 30) begin
                    if (~dht_io) begin
                        next = SET;
                        bit_count_next = 0;
                        tick_count_next = 0;
                    end
                end else tick_count_next = tick_count_reg + 1;
            end
        end

        SET: begin
            if(tick) begin
                if(tick_count_reg >= 15) begin
                    if (dht_io) begin
                        next = READ;
                    end
                end else tick_count_next = tick_count_reg + 1;
            end
        end

        READ: begin
            if (tick) begin
                if(dht_io) begin
                    tick_count_next = tick_count_reg + 1;
                    if (tick_count_reg == TIME_OUT - 1) begin
                        next = IDLE;
                    end
                end

                else if (~dht_io) begin
                    if (bit_count == 40) begin
                        bit_count_next = 0;
                        if (data_buffer[7:0] == (data_buffer[39:32] + data_buffer[31:24] + data_buffer[23:16] + data_buffer[15:8])) begin
                            humidity_next = {data_buffer[39:32], data_buffer[31:24]};
                            temperature_next = {data_buffer[23:16], data_buffer[15:8]};
                        end else begin
                            humidity_next = 16'd404;
                            temperature_next = 16'd404;
                        end
                        next = IDLE;
                    end
                    else begin
                        data_buffer_next = {data_buffer[38:0], (tick_count_reg >= DATA_0)};
                        bit_count_next = bit_count + 1;
                        tick_count_next = 0;
                        next = SET;
                    
                    
                    end
                end
            end
        end
    endcase
end


endmodule