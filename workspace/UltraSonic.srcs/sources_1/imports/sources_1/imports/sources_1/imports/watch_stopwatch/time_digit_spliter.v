module time_digit_spliter(
    input [$clog2(100) - 1:0] ms_counter,
    input [$clog2(60) - 1:0] s_counter,
    input [$clog2(60) - 1:0] m_counter,
    input [$clog2(24) - 1:0] h_counter,
    output [31:0] digit
);

digit_spliter msec_split(
    .bcd(ms_counter),
    .digit(digit[7:0])
);
digit_spliter sec_split(
    .bcd(s_counter),
    .digit(digit[15:8])
);
digit_spliter min_split(
    .bcd(m_counter),
    .digit(digit[23:16])
);
digit_spliter hour_split(
    .bcd(h_counter),
    .digit(digit[31:24])
);

endmodule

module digit_spliter #(parameter WIDTH = 8)(
    input [WIDTH-1:0] bcd,
    output [7:0] digit
);

    assign digit[3:0] = (bcd % 10);
    assign digit[7:4] = (bcd % 100) / 10;

endmodule

module digit_spliter2 #(parameter WIDTH = 16)(
    input [WIDTH-1:0] bcd,
    output [15:0] digit
);

    assign digit[3:0] = (bcd % 10);
    assign digit[7:4] = (bcd % 100) / 10;
    assign digit[11:8] = (bcd%1000) / 100;
    assign digit[15:12] = (bcd%10000) / 1000; 

endmodule
