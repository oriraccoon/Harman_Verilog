`include "C:\Users\kccistc\Desktop\workspace\UART_Basys3\UART_Basys3.srcs\sources_1\new\btn_edge_trigger.v"
`include "C:\Users\kccistc\Desktop\workspace\UART_Basys3\UART_Basys3.srcs\sources_1\new\Top_Uart.v"

module send_tx_btn (
    input  clk,
    input  rst,
    input  btn_start,
    output tx
);

    wire w_btn_start, w_tx_done;
    reg [7:0] send_tx_data_reg, send_tx_data_next;

    btn_edge_trigger BDT (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btn_start),
        .o_btn(w_btn_start)
    );
    Top_Uart U_Top_Uart (
        .clk(clk),
        .rst(rst),
        .tx_data_in(send_tx_data_reg),
        .btn_start(w_btn_start),
        .tx(tx),
        .tx_done(w_tx_done)
    );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            send_tx_data_reg <= "0"; // 8'h30
        end else begin
            send_tx_data_reg <= send_tx_data_next;
        end
    end

    always @(*) begin
        send_tx_data_next = send_tx_data_reg;
        if(w_btn_start) begin
            if(send_tx_data_reg == "z") begin
                send_tx_data_next = "0";
            end
            send_tx_data_next = send_tx_data_reg + 1;
        end
    end
    


endmodule
