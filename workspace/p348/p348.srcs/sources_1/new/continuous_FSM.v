module continuous_FSM(
                        input clk,
                        input rst,
                        input sw,
                        output reg o_sign
);
    parameter [2:0] START = 3'b000, rd0_once = 3'b001, rd0_twice = 3'b010, rd1_once = 3'b011, rd1_twice = 3'b100;

    reg [2:0] state, n_state;

    always @(posedge clk, posedge rst) begin
        if(rst) state <= 0;
        else state <= n_state;
    end

    always@(*) begin
        n_state = state;
        case(state)
            START: begin
                if(sw == 0) n_state = rd0_once;
                else if(sw == 1) n_state = rd1_once;
                else n_state = START;
            end
            rd0_once: begin
                if(sw == 0) n_state = rd0_twice;
                else if(sw == 1) n_state = rd1_once;
                else n_state = START;
            end
            rd0_twice: begin
                if(sw == 0) n_state = rd0_twice;
                else if(sw == 1) n_state = rd1_once;
                else n_state = START;
            end
            rd1_once: begin
                if(sw == 0) n_state = rd0_once;
                else if(sw == 1) n_state = rd1_twice;
                else n_state = START;
            end
            rd1_twice: begin
                if(sw == 0) n_state = rd0_once;
                else if(sw == 1) n_state = rd1_twice;
                else n_state = START;
            end
            default: begin
                n_state = START;
            end
        endcase
    end

    always @(*) begin
        case(state)
            rd1_twice:begin
                if(sw == 1) o_sign = 1;
            end
            rd0_twice: begin
                if(sw == 0) o_sign = 1;
            end
            default: begin
                o_sign = 0;
            end
        endcase
    end

endmodule


