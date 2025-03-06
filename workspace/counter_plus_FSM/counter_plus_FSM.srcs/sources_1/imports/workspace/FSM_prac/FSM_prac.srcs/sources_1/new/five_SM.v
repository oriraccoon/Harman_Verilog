module five_SM(
                input clk,
                input rst,
                input [2:0] sw,
                output reg [2:0] state
    );

    parameter [2:0] STAY = 3'b000, START = 3'b001, CLEAR = 3'b010, U_CLEAR = 3'b011;

    reg [2:0] next;

    always @(posedge clk, posedge rst) begin
        if(rst) state <= 0;
        else state <= next;
    end

    always @(*) begin
        next = state;
        case(state)
            STAY: begin
                if(sw == 3'b001) next = ST1;
                else next = state;
            end
            ST1: begin
                if(sw == 3'b010) next = ST2;
                else next = state;
            end
            ST2: begin
                if(sw == 3'b011) next = ST3;
                else next = state;
            end
            ST3: begin
                if(sw == 3'b000) next = ST1;
                else next = state;
            end
            default: begin
                next = state;
            end
        endcase
    end

endmodule
