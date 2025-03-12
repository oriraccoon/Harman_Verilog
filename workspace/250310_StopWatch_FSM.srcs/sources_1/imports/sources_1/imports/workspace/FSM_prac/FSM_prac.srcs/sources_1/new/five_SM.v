module five_SM(
                input clk,
                input rst,
                input [1:0] btn,
                output reg [1:0] state
    );

    parameter STAY = 0, START = 1, H_M_Mod1 = 0, H_M_Mod2 = 1;

    reg [1:0] next;

    always @(posedge clk, posedge rst) begin
        if(rst) state <= STAY;
        else state <= next;
    end

    always @(*) begin
        next = state;
        case (state[0])
            STAY: begin
                if (btn[0] == 1) next[0] = START;
                else if (state[1] == H_M_Mod2 && btn[1] == 1) next[1] = H_M_Mod1;
                else if (state[1] == H_M_Mod1 && btn[1] == 1) next[1] = H_M_Mod2;
            end
            START: begin
                if (btn[0] == 1) next[0] = STAY;
                else if (state[1] == H_M_Mod2 && btn[1] == 1) next[1] = H_M_Mod1;
                else if (state[1] == H_M_Mod1 && btn[1] == 1) next[1] = H_M_Mod2;
            end
        endcase

        case(state[1])
            H_M_Mod1: begin
                if (btn[1] == 1) next[1] = H_M_Mod2;
                else if (state[0] == START && btn[0] == 1) next[0] = STAY;
                else if (state[0] == STAY && btn[0] == 1) next[0] = START;  
            end
            H_M_Mod2: begin
                if (btn[1] == 1) next[1] = H_M_Mod1;
                else if (state[0] == START && btn[0] == 1) next[0] = STAY;
                else if (state[0] == STAY && btn[0] == 1) next[0] = START; 
            end
        endcase
    end

endmodule
