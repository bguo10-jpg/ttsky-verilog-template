`timescale 1ns / 1ps
module Add8(
    input [7:0] A_i,
    input [7:0] B_i,
    output [7:0] S_o,
    input Cin_i,
    output cout_o,
    output ovfl_o
    );
    wire [7:0] carry_w;
    fa FA0(.A_i(A_i[0]), .B_i(B_i[0]), .cin_i(Cin_i), .S_o(S_o[0]), .cout_o(carry_w[0]));
    fa FA1(.A_i(A_i[1]), .B_i(B_i[1]), .cin_i(carry_w[0]), .S_o(S_o[1]), .cout_o(carry_w[1]));
    fa FA2(.A_i(A_i[2]), .B_i(B_i[2]), .cin_i(carry_w[1]), .S_o(S_o[2]), .cout_o(carry_w[2]));
    fa FA3(.A_i(A_i[3]), .B_i(B_i[3]), .cin_i(carry_w[2]), .S_o(S_o[3]), .cout_o(carry_w[3]));
    fa FA4(.A_i(A_i[4]), .B_i(B_i[4]), .cin_i(carry_w[3]), .S_o(S_o[4]), .cout_o(carry_w[4]));
    fa FA5(.A_i(A_i[5]), .B_i(B_i[5]), .cin_i(carry_w[4]), .S_o(S_o[5]), .cout_o(carry_w[5]));
    fa FA6(.A_i(A_i[6]), .B_i(B_i[6]), .cin_i(carry_w[5]), .S_o(S_o[6]), .cout_o(carry_w[6]));
    fa FA7(.A_i(A_i[7]), .B_i(B_i[7]), .cin_i(carry_w[6]), .S_o(S_o[7]), .cout_o(cout_o));
    
    assign ovfl_o = (~(A_i[7] ^ B_i[7])) & (S_o[7] ^ A_i[7]);

endmodule
