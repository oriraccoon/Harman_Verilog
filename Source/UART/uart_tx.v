module uart_tx (
    input  clk,
    input  rst,
    input  tick,
    input  start_trigger,
    input [7:0] data_in,
    output o_tx,
    output tx_done
);

    parameter [1:0] IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
    reg [2:0] data_index;
    reg [3:0] state, next;
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
        end else begin
            state <= next;
            tx_reg <= tx_next;
            done_reg <= done_next;
        end
    end

    always @(*) begin
        next = state;
        tx_next = tx_reg;
        done_next = done_reg;
        case (state)
            IDLE: begin
                if (start_trigger) begin
                    next = START;
                    done_next = 1;
                end
            end
            START: begin
                tx_next = 1'b0;
                if (tick == 1'b1) begin
                    next = DATA;
                end
            end
            DATA: begin
                if(tick == 1'b1) begin
                    if(data_index == 3'b111) begin
                        tx_next = data_in[data_index];
                        data_index = 0;
                        next = STOP;
                    end
                    else begin
                        tx_next = data_in[data_index];
                        data_index = data_index + 1;
                    end
                end
            end
            STOP: begin
                tx_next = 1'b1;
                if(tick==1'b1) begin
                    done_next = 0;
                    next = IDLE;
                end
            end
            // default: 
        endcase
    end



endmodule
