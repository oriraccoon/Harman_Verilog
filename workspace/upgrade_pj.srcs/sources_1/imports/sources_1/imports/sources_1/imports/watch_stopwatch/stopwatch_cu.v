module stopwatch_cu(
                    input clk,
                    input rst,
                    input i_btn_run,
                    input i_btn_clear,
                    input sw_mod,
                    input w_mod,
                    input [3:0] t_command,
                    output reg o_run,
                    output reg o_clear,
                    output reg o_mod
);

    wire w_run, w_clear;

    btn_edge_trigger U_btn_run(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(i_btn_run),
                        .o_btn(w_run)
    );
    btn_edge_trigger U_btn_clear(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(i_btn_clear),
                        .o_btn(w_clear)
    );


    parameter [1:0] STOP = 2'b00, RUN = 2'b01, CLEAR = 2'b10;
    parameter MOD1 = 0, MOD2 = 1;

    parameter C_IDLE = 0, C_WAIT = 1, C_RUN = 2, C_CLEAR = 3;
    reg [1:0] state, next, prev;
    reg mod_state, mod_next;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= STOP;
            mod_state <= MOD1;
            prev <= STOP;
        end
        else if (w_mod == 0) begin
            if(next != CLEAR) prev <= state;
            state <= next;
            mod_state <= mod_next;
        end
    end

    always @(*) begin
            next = state;
            case (state)
                STOP:begin
                        if (w_run | t_command == C_RUN ) begin
                            next = RUN;
                        end else if (w_clear | t_command == C_CLEAR) begin
                            next = CLEAR;
                        end
                    end
                RUN:begin
                        if (w_run | t_command == C_WAIT ) begin
                            next = STOP;
                        end else if (w_clear | t_command == C_CLEAR ) begin
                            next = CLEAR;
                        end
                    end
                CLEAR:begin
                        if (prev == RUN | t_command == C_RUN ) begin
                            next = RUN;
                        end else if (prev == STOP | t_command == C_WAIT ) begin
                            next = STOP;
                        end
                    end
            endcase
    end

    always @(*) begin
            mod_next = mod_state;
            case (mod_state)
                MOD1: if(sw_mod) begin
                    mod_next = MOD2;
                end
                MOD2: if (sw_mod==0) begin
                    mod_next = MOD1;
                end
            endcase
        
    end

    always @(*) begin
            o_run = 0;
            o_clear = 0;
            case (state)
                STOP:begin
                    o_run = 1'b0;
                    o_clear = 1'b0;
                end
                RUN:begin
                    o_run = 1'b1;
                    o_clear = 1'b0;
                end
                CLEAR:begin
                    o_clear = 1'b1;
                    if(prev == STOP) o_run = 1'b0;
                    else if(prev == RUN) o_run = 1'b1;
                end 
            endcase
        
    end

    always @(*) begin
            o_mod = 0;
            case (mod_state)
                MOD1:begin
                    o_mod = 1'b0;
                end
                MOD2:begin
                    o_mod = 1'b1;
                end 
            endcase
        
    end



endmodule
