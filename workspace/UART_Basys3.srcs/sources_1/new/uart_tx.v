module uart_tx (
    input  clk,
    input  rst,
    input  tick,
    input  start_trigger,
    input [7:0] data_in,
    output o_tx
);

    parameter IDLE = 4'h0, START = 4'h1, D0 = 4'h2, D1 = 4'h3, D2 = 4'h4, D3 = 4'h5, D4 = 4'h6, D5 = 4'h7, D6 = 4'h8, D7 = 4'h9, STOP = 4'hA;
    reg [3:0] state, next;
    reg tx_reg, tx_next;

    assign o_tx = tx_reg;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= 0;
            tx_reg <= 0;
        end else begin
            state <= next;
            tx_reg <= tx_next;
        end
    end

    always @(*) begin
        next = state;
        tx_next = tx_reg;
        case (state)
            IDLE: begin
                if (start_trigger) begin
                    next = START;
                end
            end
            START: begin
                tx_next = 1'b0;
                if (tick == 1'b1) begin
                    next = D0;
                end
            end
            D0: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[0];
                    next = D1;
                end
            end
            D1: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[1];
                    next = D2;
                end
            end
            D2: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[2];
                    next = D3;
                end
            end
            D3: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[3];
                    next = D4;
                end
            end
            D4: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[4];
                    next = D5;
                end
            end
            D5: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[5];
                    next = D6;
                end
            end
            D6: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[6];
                    next = D7;
                end
            end
            D7: begin
                if (tick == 1'b1) begin
                    tx_next = data_in[7];
                    next = STOP;
                end
            end
            STOP: begin
                if(tick==1'b1) begin
                    tx_next = 1'b1;
                    next = IDLE;
                end
            end
            // default: 
        endcase
    end



endmodule
