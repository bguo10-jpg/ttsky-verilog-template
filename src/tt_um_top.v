`timescale 1ns/1ps

module tt_um_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  ui_in,   // ui_in[0]=up, [1]=down, [2]=load, [3]=reset
    output wire [7:0]  uo_out   
);

    // Button assignments
    wire btnU = ui_in[0];
    wire btnD = ui_in[1];
    wire btnL = ui_in[2];
    wire btnC = ui_in[3];

    wire rst_combined_n = rst_n & ~ui_in[3];

    // Counter output
    wire [15:0] cnt_out;


    // Unused carry outputs
    wire unused_utc;
    wire unused_dtc;

    // 16-bit up/down counter
    countUD16L cnt_ins (
        .clk_i(clk),
        .rst_n(rst_combined_n),
        .up_i(btnU),
        .dw_i(btnD),

        // Load 46 when load pressed
        .ld_i(btnL),
        .Din_i(16'd46),

        .Q_o(cnt_out),
        .utc_o(unused_utc),
        .dtc_o(unused_dtc)
    );

    // Output lower 8 bits
    assign uo_out = cnt_out[7:0];

endmodule