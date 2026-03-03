`timescale 1ns / 1ps
module countUD4L(
    input        clk_i,
    input        rst_n,
    input        up_i,
    input        dw_i,
    input        ld_i,
    input  [3:0] Din_i,
    output reg [3:0] Q_o,
    output       utc_o,
    output       dtc_o
);

    wire [7:0] add_val;
    wire [7:0] mux_out;
    wire [7:0] Q_out;
    wire [7:0] Din_out;
    wire ce;
    wire unused_ovfl;
    wire unused_cout;
    wire [7:0] add_input = up_i ? 8'b00000001 : (dw_i ? 8'b11111111 : 8'b00000000);

    assign Q_out = {4'b0000, Q_o};
    assign Din_out = {4'b0000, Din_i};
    AddSub8 addsub_0 (.A_i(Q_out), .B_i(add_input), .cin_i(1'b0), .S_o(add_val), .ovfl_o(unused_ovfl), .cout_o(unused_cout));
    mux8bit mux0 (.a_i(add_val), .b_i(Din_out), .sel_i(ld_i), .c_o(mux_out));

    assign ce = up_i | dw_i | ld_i;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n)
            Q_o <= 4'd0;
        else if (ce)
            Q_o <= mux_out[3:0];
    end
    
    assign utc_o = (Q_o == 4'b1111);
    assign dtc_o = (Q_o == 4'b0000);

endmodule