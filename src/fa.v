`timescale 1ns / 1ps
module fa(
    input A_i,
    input B_i,
    input cin_i,
    output S_o,
    output cout_o
    );
    assign S_o = A_i ^ B_i ^ cin_i;
    assign cout_o = (B_i & cin_i)|(A_i & B_i)|(A_i & cin_i);
endmodule