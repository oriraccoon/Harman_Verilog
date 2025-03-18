module time_digit_spliter(
    input [3:0] ms_counter,
    input [3:0] s_counter,
    input [3:0] m_counter,
    input [3:0] h_counter,
    output [15:0] digit
);

digit_spliter msec_split(
    .bcd(ms_counter),
    .digit(digit[3:0])
);
digit_spliter sec_split(
    .bcd(s_counter),
    .digit(digit[7:4])
);
digit_spliter min_split(
    .bcd(m_counter),
    .digit(digit[11:8])
);
digit_spliter hour_split(
    .bcd(h_counter),
    .digit(digit[15:12])
);

endmodule

module digit_spliter #(parameter WIDTH = 4)(
    input [WIDTH-1:0] bcd,
    output [WIDTH-1:0] digit
);

    assign digit[3:0] = (bcd % 10);
    assign digit[7:4] = (bcd % 100) / 10;

endmodule
