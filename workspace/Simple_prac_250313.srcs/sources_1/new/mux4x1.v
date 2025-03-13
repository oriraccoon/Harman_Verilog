module mux4x1 (
    input [3:0] a, b, c, d,
    input [1:0] sel,
    output reg [3:0] mux_out
);

always@(*) begin
    case(sel)
        0: mux_out = a;
        1: mux_out = b;
        2: mux_out = c;
        3: mux_out = d;
        default: mux_out = 4'bx;
    endcase
end

endmodule
