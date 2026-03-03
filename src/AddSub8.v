`timescale 1ns / 1ps
module AddSub8(
    input [7:0] A_i,
    input [7:0] B_i,
    input cin_i,
    output [7:0] S_o,
    output ovfl_o,
    output cout_o
    );
    wire [7:0] muxout_w;
    mux8bit mux_b (.a_i(B_i),.b_i(~B_i),.sel_i(cin_i),.c_o(muxout_w));
    Add8 add_b (.A_i(A_i), .B_i(muxout_w), .Cin_i(cin_i), .S_o(S_o), .ovfl_o(ovfl_o), .cout_o(cout_o));
    
endmodule