module five_SM(
                input clk,
                input rst,
                input [2:0] sw,
                output reg [2:0] next
    );

    parameter [2:0] STAY = 3'b000, START = 3'b001, CLEAR1 = 3'b010, CLEAR2 = 3'b011;

    reg [2:0] state;

    always @(posedge clk, posedge rst) begin
        if(rst) state <= 0;
        else state <= next;
    end

    always @(*) begin
        next = state;
        case(state)
            STAY: begin
                if(sw == START) next = START;
                else if(sw == CLEAR1) next = CLEAR1;
                else next = state;
            end
            START: begin
                if(sw == STAY) next = STAY;
                else if(sw == CLEAR2) next = CLEAR2;
                else next = state;
            end
            CLEAR1: begin
                if(sw == CLEAR2) next = CLEAR2;
                else if(sw == STAY) next = STAY;
                else next = state;
            end
            CLEAR2: begin
                if(sw == CLEAR1) next = CLEAR1;
                // else if(sw == START) next = START;  // Reset과 Clear의 차이 실험
                else next = state;
            end
            default: begin
                next = state;
            end
        endcase
    end

endmodule
