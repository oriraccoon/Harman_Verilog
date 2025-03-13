module watch_cu(
                    input clk,
                    input rst,
                    input i_btn_run,
                    input i_btn_sec_cal,
                    input i_btn_min_cal,
                    input sw_mod,
                    input w_mod,
                    input pm_mod,
                    output reg o_mod,
                    output reg o_pm_mod,
                    output signed [5:0] o_sec_detect,
                    output signed [5:0] o_min_detect,
                    output signed [5:0] o_hour_detect
);

    parameter MSEC_SEC_MOD1 = 0, MIN_HOUR_MOD2 = 1, ADD_MOD = 0, MINUS_MOD = 1;

    reg state, next;
    reg mod_state, mod_next;
    reg pm_state, pm_next;
    reg signed [5:0] sec_detect, min_detect, hour_detect;
    wire w_sec_mod, w_min_mod, w_hour_mod;

    btn_edge_trigger U_btn_sec_D (
        .clk  (clk),
        .rst  (rst),
        .i_btn(i_btn_sec_cal),
        .o_btn(w_sec_mod)
    );
    btn_edge_trigger U_btn_min_D (
        .clk  (clk),
        .rst  (rst),
        .i_btn(i_btn_min_cal),
        .o_btn(w_min_mod)
    );
    btn_edge_trigger U_btn_hour_D (
        .clk  (clk),
        .rst  (rst),
        .i_btn(i_btn_run),
        .o_btn(w_hour_mod)
    );


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

    assign o_sec_detect = sec_detect;
    assign o_min_detect = min_detect;
    assign o_hour_detect = hour_detect;

// pm_mod 동작
    always @(*) begin
            pm_next = pm_state;
            case (pm_state)
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
            case (pm_state)
                ADD_MOD:begin
                    o_pm_mod = 1'b0;
                end
                MINUS_MOD:begin
                    o_pm_mod = 1'b1;
                end 
            endcase
    end

    always @(*) begin
        sec_detect = 0;
        min_detect = 0;
        hour_detect = 0;
        case(pm_state)
            ADD_MOD:begin
                if(w_sec_mod) sec_detect = 1;
                if(w_min_mod) min_detect = 1;
                if(w_hour_mod) hour_detect = 1;
            end
            MINUS_MOD:begin
                if(w_sec_mod) sec_detect = -1;
                if(w_min_mod) min_detect = -1;
                if(w_hour_mod) hour_detect = -1;
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
