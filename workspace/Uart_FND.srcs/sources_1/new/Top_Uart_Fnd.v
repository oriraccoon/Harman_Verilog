module Top_Uart_Fnd (
    input clk,
    input rst,
    input rx,
    output tx,
    output [7:0] seg,
    output [3:0] an
);
    wire w_rx_done;
    wire [7:0] w_rx_data;

    uart U_UART (
        .clk(clk),
        .rst(rst),
        .btn_start(w_rx_done),
        .tx_data_in(w_rx_data),
        .tx_done(),
        .tx(tx),
        .rx(rx),
        .rx_done(w_rx_done),
        .rx_data(w_rx_data)
    );

    fnd_display U_FND (
        .clk(clk),
        .rst(rst),
        .data(w_rx_data),
        .fnd_out(seg),
        .fnd_sel(an)
    );

endmodule

module fnd_display (
    input clk,
    input rst,
    input [7:0] data,
    output reg [7:0] fnd_out,
    output reg [3:0] fnd_sel
);

    reg [19:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 20'd0;
        end else begin
            cnt <= cnt + 1;
        end
    end

    always @(*) begin
        case (cnt[18])
            0: begin
                fnd_sel = 4'b1110;
                fnd_out = ascii_to_fnd(data);
            end
            1: begin
                fnd_sel = 4'b1110;
                fnd_out = ascii_to_fnd(data);
            end
            default: begin
                fnd_sel = 4'b1111;
                fnd_out = 8'b1111_1111;
            end
        endcase
    end

    function [7:0] ascii_to_fnd;
        input [7:0] ascii;
        case (ascii)
            8'h30: ascii_to_fnd = 8'b1100_0000; // '0'
            8'h31: ascii_to_fnd = 8'b1111_1001; // '1'
            8'h32: ascii_to_fnd = 8'b1010_0100; // '2'
            8'h33: ascii_to_fnd = 8'b1011_0000; // '3'
            8'h34: ascii_to_fnd = 8'b1001_1001; // '4'
            8'h35: ascii_to_fnd = 8'b1001_0010; // '5'
            8'h36: ascii_to_fnd = 8'b1000_0010; // '6'
            8'h37: ascii_to_fnd = 8'b1111_1000; // '7'
            8'h38: ascii_to_fnd = 8'b1000_0000; // '8'
            8'h39: ascii_to_fnd = 8'b1001_0000; // '9'
            8'h41: ascii_to_fnd = 8'b1000_1000; // 'A'
            8'h42: ascii_to_fnd = 8'b0000_0011; // 'B'
            8'h43: ascii_to_fnd = 8'b1100_0110; // 'C'
            8'h44: ascii_to_fnd = 8'b0010_0001; // 'D'
            8'h45: ascii_to_fnd = 8'b1000_0110; // 'E'
            8'h46: ascii_to_fnd = 8'b1000_1110; // 'F'
            // Add more ASCII characters here if necessary
            default: ascii_to_fnd = 7'b111_1111; // Invalid character
        endcase
    endfunction

endmodule
