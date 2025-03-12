module watch_cu(
                    input clk,
                    input rst,
                    input i_btn_run,
                    input i_btn_sec_cal,
                    input i_btn_min_cal,
                    input sw_mod,
                    input w_mod,
                    input pm_mod,
                    output o_sec_mod,
                    output o_min_mod,
                    output o_hour_mod,
                    output reg o_mod,
                    output reg o_pm_mod
);


    btn_edge_trigger U_btn_hour(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(i_btn_run),
                        .o_btn(o_hour_mod)
    );
    btn_edge_trigger U_btn_sec(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(i_btn_sec_cal),
                        .o_btn(o_sec_mod)
    );
    btn_edge_trigger U_btn_min(
                        .clk(clk),
                        .rst(rst),
                        .i_btn(i_btn_min_cal),
                        .o_btn(o_min_mod)
    );




    parameter MSEC_SEC_MOD1 = 0, MIN_HOUR_MOD2 = 1, ADD_MOD = 0, MINUS_MOD = 1;

    reg mod_state, mod_next;
    reg pm_state, pm_next;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            mod_state <= MSEC_SEC_MOD1;
            pm_state <= ADD_MOD;
        end
        else if (w_mod == 1) begin
            mod_state <= mod_next;
            pm_state <= pm_next;
        end
    end

// pm_mod 동작
    always @(*) begin
            pm_next = pm_state;
            case (mod_state)
                ADD_MOD: if(pm_mod) begin
                    pm_next = MINUS_MOD;
                end
                MINUS_MOD: if (pm_mod==0) begin
                    pm_next = ADD_MOD;
                end
            endcase
    end

    always @(*) begin
            o_pm_mod = 0;
            case (mod_state)
                ADD_MOD:begin
                    o_pm_mod = 1'b0;
                end
                MINUS_MOD:begin
                    o_pm_mod = 1'b1;
                end 
            endcase
    end






// sw_mod 동작
    always @(*) begin
            mod_next = mod_state;
            case (mod_state)
                MSEC_SEC_MOD1: if(sw_mod) begin
                    mod_next = MIN_HOUR_MOD2;
                end
                MIN_HOUR_MOD2: if (sw_mod==0) begin
                    mod_next = MSEC_SEC_MOD1;
                end
            endcase
    end

    always @(*) begin
            o_mod = 0;
            case (mod_state)
                MSEC_SEC_MOD1:begin
                    o_mod = 1'b0;
                end
                MIN_HOUR_MOD2:begin
                    o_mod = 1'b1;
                end 
            endcase
    end


endmodule
