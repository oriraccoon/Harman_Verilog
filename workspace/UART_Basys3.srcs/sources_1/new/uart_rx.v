module uart_rx(
    input  clk,
    input  rst,
    input  tick,
    input  rx,
    output [7:0] data_in,
    output rx_done
    );

    parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

    reg rx_done_reg, rx_done_next;
    reg [1:0] state, next;
    reg [2:0] data_index, data_index_next;
    reg [4:0] tick_count_reg, tick_count_next;
    reg [7:0] rx_data_reg, rx_data_next;
    assign rx_done = rx_done_reg;
    assign data_in = rx_data_reg;

    initial begin
        data_index = 0;
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            tick_count_reg <= 0;
            rx_done_reg <= 0;
            rx_data_reg <= 0;
            data_index <= 0;
        end else begin
            state <= next;
            tick_count_reg <= tick_count_next;
            rx_done_reg <= rx_done_next;
            rx_data_reg <= rx_data_next;
            data_index <= data_index_next;
        end
    end

    always @(*) begin
        next = state;
        tick_count_next = tick_count_reg;
        rx_done_next = rx_done_reg;
        rx_data_next = rx_data_reg;
        data_index_next = data_index;
        case(state)
            IDLE: begin
                rx_data_next = 0;
                
                if(rx == 0) next = START;
            end
            START: begin
                if(tick == 1) begin
                    if(tick_count_reg == 23) begin
                        next = DATA;
                        tick_count_next = 0;
                    end
                    else tick_count_next = tick_count_reg + 1;
                end
            end
            DATA: begin
                if(tick == 1) begin
                    if(tick_count_reg == 15) begin
                        tick_count_next = 0;
                        rx_data_next[data_index] = rx;
                        if(data_index == 7) begin
                            next = STOP;
                            data_index_next = 0;
                        end else data_index_next = data_index + 1;
                    end else tick_count_next = tick_count_reg + 1;
                end
            end
            STOP: begin
                if(tick == 1) begin
                    if(tick_count_reg == 7) begin
                        next = IDLE;
                        tick_count_next = 0;
                    end else tick_count_next = tick_count_reg + 1;
                end
            end
        endcase
    end


endmodule
