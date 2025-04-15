module myHC_SR04(
    input clk,
    input echo,
    input rst,
    output trig,
    output [$clog2(400)-1:0] distance
    );

parameter IDLE = 0, START = 1, HIGH_COUNT = 2, DIST = 3;

reg [1:0] state, next, sec_reg, sec_next;
reg prev_echo, sync_prev_echo;
reg [$clog2(1000)-1:0] clk_count, clk_count_next;
reg trig_reg, trig_next;
reg [$clog2(23200)-1:0] dist_reg, dist_next;
reg [$clog2(400)-1:0] centi_reg, centi_next;
wire o_clk;



clock_divider_0_5sec u_0_5sec(
    .clk(clk),
    .rst(rst),
    .o_clk(o_clk)
);
always @(posedge clk or posedge rst) begin
    if(rst) begin
        state <= 0;
        prev_echo <= 0;
        clk_count <= 0;
        trig_reg <= 0;
        dist_reg <= 0;
        centi_reg <= 0;
        sec_reg <= 0;
    end else begin
        state <= next;
        prev_echo <= sync_prev_echo;
        clk_count <= clk_count_next;
        trig_reg <= trig_next;
        dist_reg <= dist_next;
        centi_reg <= centi_next;
        sec_reg <= sec_next;
    end        
end

assign distance = centi_reg;
assign trig = trig_reg;

always @(*) begin
    next = state;
    sync_prev_echo = prev_echo;
    clk_count_next = clk_count;
    trig_next = trig_reg;
    dist_next = dist_reg;
    centi_next = centi_reg;
    sec_next = sec_reg;
    case (state)
        IDLE: begin
            if(o_clk) sec_next = sec_next + 1;
            else if(sec_reg == 2) begin
                next = START;
                sec_next = 0;
            end
        end
        START: begin
            clk_count_next = clk_count + 1;
            trig_next = 1;
            if(clk_count == 1000) begin
                trig_next = 0;
                next = HIGH_COUNT;
                clk_count_next = 0;        
            end
        end
        HIGH_COUNT: begin
            if (~prev_echo & echo) begin
                dist_next = 0;
            end else if(prev_echo & echo) begin
                clk_count_next = clk_count + 1;
                if(clk_count == 100) begin
                    dist_next = dist_reg + 1;
                    clk_count_next = 0;
                end
            end else if(prev_echo & ~echo) begin
                next = DIST;
            end else begin
                if(o_clk) begin
                    dist_next = 0;
                    next = DIST;
                end
            end
        end
        DIST: begin
            centi_next = dist_reg / 58;
            next = IDLE;
        end
    endcase

    sync_prev_echo = echo;

end

endmodule


