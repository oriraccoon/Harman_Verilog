`include "btn_edge_trigger.v"

module send_tx_btn (
    input  clk,
    input  rst,
    input  btn_start,
    output tx
);

    wire w_btn_start, w_tx_done;
    reg [7:0] send_tx_data_reg, send_tx_data_next;
    reg send_state;

    initial send_state = 0;

    btn_edge_trigger BDT (
        .clk  (clk),
        .rst  (rst),
        .i_btn(btn_start),
        .o_btn(w_btn_start)
    );
    Top_Uart U_Top_Uart (
        .clk(clk),
        .rst(rst),
        .btn_start(send_state),
        .tx_data_in(send_tx_data_reg),
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

    always @(w_btn_start, w_tx_done) begin
        send_tx_data_next = send_tx_data_reg;
        if(w_btn_start) begin
            send_state = 1;
            send_tx_data_next = "0";
        end else if(send_state == 1) begin
            if(send_tx_data_reg != "z") begin
                if(w_tx_done == 0) begin
                    send_tx_data_next = send_tx_data_reg + 1;
                end
            end else if(send_tx_data_reg == "z") begin
                send_state = 0;
            end
        end
    end
    


endmodule