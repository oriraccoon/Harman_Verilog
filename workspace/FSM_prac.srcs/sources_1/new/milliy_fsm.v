module mealy_SM(
                input clk,
                input rst,
                input [2:0] sw,
                output [2:0] led
    );

    parameter [2:0] IDLE = 3'b000, ST1 = 3'b001, ST2 = 3'b010, ST3 = 3'b100, ST4 = 3'b111;

    reg [2:0] state, next;
    reg [2:0] r_led;

    always @(posedge clk, posedge rst) begin
        if(rst) state <= 0;
        else state <= next;
    end

    assign led = r_led;

    always @(*) begin
        next = state;
        case(state)
            IDLE: begin
                if(sw == 3'b001) begin
                    next = ST1;
                    r_led = ST1;
                end
                else if(sw == 3'b010) begin
                    next = ST2;
                    r_led = ST2;
                end
                else begin
                    next = state;
                    r_led = state;
                end
            end
            ST1: begin
                if(sw == 3'b010) begin
                    next = ST2;
                    r_led = ST2;
                end
                else begin
                    next = state;
                    r_led = state;
                end
            end
            ST2: begin
                if(sw == 3'b100) begin
                    next = ST3;
                    r_led = ST3;
                end
                else begin
                    next = state;
                    r_led = state;
                end
            end
            ST3: begin
                if(sw == 3'b001) begin
                    next = ST1;
                    r_led = ST1;
                end
                else if(sw == 3'b111) begin
                    next = ST4;
                    r_led = ST4;
                end
                else if(sw == 3'b000) begin
                    next = IDLE;
                    r_led = IDLE;
                end
                else begin
                    next = state;
                    r_led = state;
                end
            end
            ST4: begin
                if(sw == 3'b100) begin
                    next = ST3;
                    r_led = ST3;
                end
                else begin
                    next = state;
                    r_led = state;
                end
            end
            default: begin
                next = state;
                r_led = state;
            end
        endcase
    end
endmodule