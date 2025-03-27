module watch_cu (
    input clk,
    input rst,
    input i_btn_run,
    input i_btn_sec_cal,
    input i_btn_min_cal,
    input sw_mod,
    input w_mod,
    input ultra_mod,
    input [3:0] t_command,
    output reg o_mod,
    output reg o_sec_detect,
    output reg o_min_detect,
    output reg o_hour_detect
);
    parameter C_IDLE = 0, C_SEC = 4, C_MIN = 5, C_HOUR = 6;
    parameter MSEC_SEC_MOD1 = 0, MIN_HOUR_MOD2 = 1;
    parameter [1:0] IDLE = 2'b00, SEC = 2'b01, MIN = 2'b10, HOUR = 2'b11;

    reg [1:0] state, next;
    reg mod_state, mod_next;
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
        if (rst) begin
            mod_state <= MSEC_SEC_MOD1;
            state <= IDLE;
        end else if (w_mod == 1 & ~ultra_mod) begin
            mod_state <= mod_next;
            state <= next;
        end
    end

    always @(*) begin
        next = state;
        case (state)
            IDLE: begin
                if (w_sec_mod | t_command == C_SEC ) begin
                    next = SEC;
                end else if (w_min_mod | t_command == C_MIN ) begin
                    next = MIN;
                end else if (w_hour_mod | t_command == C_HOUR ) begin
                    next = HOUR;
                end
            end
            SEC: begin
                if(w_sec_mod == 1'b0 | t_command == IDLE) begin
                    next = IDLE;
                end
            end
            MIN: begin
                if(w_min_mod == 1'b0 | t_command == IDLE) begin
                    next = IDLE;
                end
            end
            HOUR: begin
                if(w_hour_mod == 1'b0 | t_command == IDLE) begin
                    next = IDLE;
                end
            end
        endcase
    end

    always @(*) begin
        o_sec_detect  = 0;
        o_min_detect  = 0;
        o_hour_detect = 0;
        case (state)
            IDLE: begin
                o_sec_detect = 0;
                o_min_detect = 0;
                o_hour_detect = 0;
            end
            SEC: begin
                o_sec_detect = 1;
                o_min_detect = 0;
                o_hour_detect = 0;
            end
            MIN: begin
                o_sec_detect = 0;
                o_min_detect = 1;
                o_hour_detect = 0;
            end
            HOUR: begin
                o_sec_detect = 0;
                o_min_detect = 0;
                o_hour_detect = 1;
            end      
        endcase

    end

    // sw_mod 동작
    always @(*) begin
        mod_next = mod_state;
        case (mod_state)
            MSEC_SEC_MOD1:
            if (sw_mod) begin
                mod_next = MIN_HOUR_MOD2;
            end
            MIN_HOUR_MOD2:
            if (sw_mod == 0) begin
                mod_next = MSEC_SEC_MOD1;
            end
        endcase
    end

    always @(*) begin
        o_mod = 0;
        case (mod_state)
            MSEC_SEC_MOD1: begin
                o_mod = 1'b0;
            end
            MIN_HOUR_MOD2: begin
                o_mod = 1'b1;
            end
        endcase
    end


endmodule
