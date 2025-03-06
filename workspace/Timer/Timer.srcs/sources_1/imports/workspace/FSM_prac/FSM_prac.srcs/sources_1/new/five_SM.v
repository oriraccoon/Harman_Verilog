module five_SM(
                input clk,
                input rst,
                input [1:0] sw,
                output reg [1:0] next
    );

    parameter [1:0] STAY = 2'b00, START = 2'b01, H_M_Mod1 = 2'b10, H_M_Mod2 = 2'b11;

    reg [1:0] state;

    always @(posedge clk, posedge rst) begin
        if(rst) state <= 0;
        else state <= next;
    end

    always @(*) begin
        next = state;
        case(state)
            STAY: begin
                if(sw == START) next = START;
                else if(sw == H_M_Mod1) next = H_M_Mod1;
                else next = state;
            end
            START: begin
                if(sw == STAY) next = STAY;
                else if(sw == H_M_Mod2) next = H_M_Mod2;
                else next = state;
            end
            H_M_Mod1: begin
                if(sw == H_M_Mod2) next = H_M_Mod2;
                else if(sw == STAY) next = STAY;  // Reset과 Clear의 차이 실험  
                else next = state;
            end
            H_M_Mod2: begin
                if(sw == START) next = START;
                else if(sw == START) next = START;  // Reset과 Clear의 차이 실험  
                else next = state;
            end
            default: begin
                next = state;
            end
        endcase
    end

endmodule
