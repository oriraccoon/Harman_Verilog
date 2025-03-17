module uart_tx (
    input  clk,
    input  rst,
    input  tick,
    input  start_trigger,
    input [7:0] data_in,
    output o_tx,
    output tx_done
);

    parameter IDLE = 0, SEND = 1, START = 2, DATA = 3, STOP = 4;
    reg [2:0] data_index;
    reg [3:0] state, next;
    reg [3:0] tick_count_reg, tick_count_next;
    reg tx_reg, tx_next;
    reg done_reg, done_next;

    initial begin
        data_index = 3'b000;
    end

    assign o_tx = tx_reg;
    assign tx_done = done_reg;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= 0;
            tx_reg <= 1;
            done_reg <= 0;
            tick_count_reg <= 0;
        end else begin
            state <= next;
            tx_reg <= tx_next;
            done_reg <= done_next;
            tick_count_reg <= tick_count_next;
        end
    end

    always @(*) begin
        next = state;
        tx_next = tx_reg;
        done_next = done_reg;
        tick_count_next = tick_count_reg;
        case (state)
            IDLE: begin
                if (start_trigger) begin
                    tick_count_next = 0;
                    next = SEND;
                end
            end
            SEND: begin
                if(tick) begin
                    next = START;
                    tx_next = 0;
                    done_next = 1;
                end
            end
            START: begin
                if (tick == 1'b1) begin
                    if(tick_count_reg == 15) begin
                        next = DATA;
                        tick_count_next = 0;
                    end
                    else tick_count_next = tick_count_reg + 1;
                end
            end
            DATA: begin
                if(tick == 1'b1) begin
                    if(tick_count_reg == 15) begin
                        tick_count_next = 0;
                        if(data_index == 3'b111) begin
                            tx_next = data_in[data_index];
                            data_index = 0;
                            next = STOP;
                        end
                        else begin
                            tx_next = data_in[data_index];
                            data_index = data_index + 1;
                        end
                    end else tick_count_next = tick_count_reg + 1;
                end
            end
            STOP: begin
                tx_next = 1'b1;
                if(tick==1'b1) begin
                    if (tick_count_reg == 15) begin
                        next = IDLE;
                        tick_count_next = 0;
                        done_next = 0;
                    end else tick_count_next = tick_count_reg + 1;
                end
            end
            // default: 
        endcase
    end



endmodule
