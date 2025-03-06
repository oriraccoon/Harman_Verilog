module five_SM(
                input clk,
                input rst,
                input [2:0] sw,
                output [2:0] led
    );

    parameter [2:0] IDLE = 3'b000, ST1 = 3'b001, ST2 = 3'b010, ST3 = 3'b100, ST4 = 3'b111;

    reg [2:0] state, next;

    always @(posedge clk, posedge rst) begin
        if(rst) state <= 0;
        else state <= next;
    end

    always @(*) begin
        next = state;
        case(state)
            IDLE: begin
                if(sw == 3'b001) next = ST1;
                else if(sw == 3'b010) next = ST2;
                else next = state;
            end
            ST1: begin
                if(sw == 3'b010) next = ST2;
                else next = state;
            end
            ST2: begin
                if(sw == 3'b100) next = ST3;
                else next = state;
            end
            ST3: begin
                if(sw == 3'b001) next = ST1;
                else if(sw == 3'b111) next = ST4;
                else if(sw == 3'b000) next = IDLE;
                else next = state;
            end
            ST4: begin
                if(sw == 3'b100) next = ST3;
                else next = state;
            end
            default: begin
                next = state;
            end
        endcase
    end

    state_LED sl(
                .state(next),
                .led(led)
    );

endmodule

module state_LED(
                 input [2:0] state,
                 output [2:0] led
);
    assign led = state;

endmodule