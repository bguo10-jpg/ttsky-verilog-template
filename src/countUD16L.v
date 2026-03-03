`timescale 1ns / 1ps
module countUD16L(
    input clk_i,
    input rst_n,
    input up_i,
    input dw_i,
    input ld_i,
    input [15:0] Din_i,
    output [15:0] Q_o,
    output utc_o,
    output dtc_o
    );
    wire [3:0] q0, q1, q2, q3;
    wire utc0, utc1, utc2, utc3;
    wire dtc0, dtc1, dtc2, dtc3;
    
    wire up1 = up_i & utc0;
    wire up2 = up1 & utc1;
    wire up3 = up2 & utc2;
    
    wire dw1 = dw_i & dtc0; 
    wire dw2 = dw1 & dtc1;
    wire dw3 = dw2 & dtc2;
    
    countUD4L u0 (.clk_i(clk_i), .rst_n(rst_n), .up_i(up_i), .dw_i(dw_i), .ld_i(ld_i), .Din_i(Din_i[3:0]), .Q_o(q0), .utc_o(utc0), .dtc_o(dtc0) );
    countUD4L u1 (.clk_i(clk_i), .rst_n(rst_n), .up_i(up1), .dw_i(dw1), .ld_i(ld_i), .Din_i(Din_i[7:4]), .Q_o(q1), .utc_o(utc1), .dtc_o(dtc1) );
    countUD4L u2 (.clk_i(clk_i), .rst_n(rst_n), .up_i(up2), .dw_i(dw2), .ld_i(ld_i), .Din_i(Din_i[11:8]), .Q_o(q2), .utc_o(utc2), .dtc_o(dtc2) );
    countUD4L u3 (.clk_i(clk_i), .rst_n(rst_n), .up_i(up3), .dw_i(dw3), .ld_i(ld_i), .Din_i(Din_i[15:12]), .Q_o(q3), .utc_o(utc3), .dtc_o(dtc3) );
    
    assign Q_o = {q3, q2, q1, q0};
    assign utc_o = utc0 & utc1 & utc2 & utc3;
    assign dtc_o = dtc0 & dtc1 & dtc2 & dtc3;

endmodule
