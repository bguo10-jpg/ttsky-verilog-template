`timescale 1ns / 1ps
module mux8bit(
    input [7:0] a_i,
    input [7:0] b_i,
    input sel_i,
    output [7:0] c_o
    );
    assign c_o = ({8{~sel_i}} & a_i) | ({8{sel_i}} & b_i);
    
endmodule