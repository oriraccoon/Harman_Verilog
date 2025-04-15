// uS / 58 = centimeters or uS / 148 =inch;

module HC_SR04 (
    input wire clk,
    input wire echo,
    output trigger,
    output [15:0] sonar_out
);

    reg [16:0] count = 0;
    reg [15:0] centimeters = 0;
    reg echo_last = 0;
    reg echo_synced = 0;
    reg echo_unsynced = 0;
    reg waiting = 0;
    reg [15:0] r_sonar_out;
    reg r_trigger;
    assign sonar_out = r_sonar_out;
    assign trigger = r_trigger;
    
    always @(posedge clk) begin
        if (waiting == 0) begin
            if (count == 1000) begin // 10us pulse (100MHz clock)
                r_trigger <= 0;
                waiting <= 1;
                count <= 0;
            end else begin
                r_trigger <= 1;
                count <= count + 1;
            end
        end else if (echo_last == 0 && echo_synced == 1) begin
            // Rising edge: Start counting
            count <= 0;
            centimeters <= 0;
        end else if (echo_last == 1 && echo_synced == 0) begin
            // Falling edge: Capture distance
            r_sonar_out <= centimeters;
        end else if (count == (2900 * 2 - 1)) begin
            // Advance the counter
            centimeters <= centimeters + 1;
            count <= 0;

            if (centimeters == 3448) begin
                // Timeout: Send another pulse
                waiting <= 0;
            end
        end else begin
            count <= count + 1;
        end

        echo_last <= echo_synced;
        echo_synced <= echo_unsynced;
        echo_unsynced <= echo;
    end

endmodule
    