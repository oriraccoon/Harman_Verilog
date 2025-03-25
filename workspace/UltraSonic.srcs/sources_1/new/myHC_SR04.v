module myHC_SR04(
    input clk,
    input echo,
    input rst,
    output trig,
    output [$clog2(400)-1:0] distance
    );

parameter WAIT = 0, HIGH = 1;


reg [$clog2(23200) - 1:0] time_count, time_count_next;
reg [$clog2(50_000_000)-1:0] wait_time, wait_time_next;
reg [$clog2(1002):0] c_count, c_count_next;
reg waiting, waiting_next;
wire o_clk;
reg echo_prev;
reg trigger, trigger_next;
reg state, next;
reg [$clog2(400)-1:0] convert2centi, c2c_next;

initial begin
    time_count = 0;
    time_count_next = 0;
    wait_time = 0;
    wait_time_next = 0;
    c_count = 0;
    c_count_next = 0;
    waiting = 0;
    waiting_next = 0;
    echo_prev = 0;
    trigger = 0;
    trigger_next = 0;
    state = 0;
    next = 0;
    convert2centi = 0;
    c2c_next = 0;
end


assign distance = convert2centi;
assign trig = trigger;
ila_0 ila(
clk,


trig,
convert2centi,
c_count
);  
always @(posedge clk) begin
    if (rst) begin
        time_count <= 0;
        c_count <= 0;
        waiting <= 1;
        trigger <= 0;
        convert2centi <= 0;
        wait_time <= 0;
        echo_prev <= 0;
        state <= 0;
    end else begin
        state <= next;
        convert2centi <= c2c_next;
        time_count <= time_count_next;
        c_count <= c_count_next;
        waiting <= waiting_next;
        trigger <= trigger_next;
        wait_time <= wait_time_next;
        echo_prev <= echo;
    end
end
always @(*) begin
    time_count_next = time_count;
    c_count_next = c_count;
    waiting_next = waiting;
    trigger_next = trigger;
    c2c_next = convert2centi;
    wait_time_next = wait_time;
    next = state;
    case(state)
        WAIT: begin 
                if(waiting) begin
                    if(c_count < 1002) begin
                        c_count_next = c_count_next + 1;
                        trigger_next = 1;
                    end else begin
                        c_count_next = 0;
                        waiting_next = 0;
                        trigger_next = 0;
                        next = HIGH;
                    end
                end 
            end
        HIGH: begin
                if(echo & ~echo_prev) time_count_next = 0;
                else if(echo & echo_prev) time_count_next = time_count + 1;
                else if(~echo & echo_prev) begin
                    c2c_next = time_count / 58;
                    time_count_next = 0;
                    waiting_next = 1;
                    wait_time_next = 0;
                    next = WAIT;
                end else if(~echo & ~echo_prev) begin
                    wait_time_next = wait_time + 1;
                    if(wait_time == 50_000_000) begin
                        c2c_next = 44;
                        time_count_next = 0;
                        waiting_next = 1;
                        wait_time_next = 0;
                        next = WAIT;
                    end
                end
            end
    endcase
end

endmodule


