`timescale 1ns / 1ps
module tb_top;

    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    wire [7:0] uo_out;

    integer errors;
    reg [7:0] expected;

    // Instantiate DUT
    tt_um_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    // Reference model
always @(posedge clk or negedge rst_n or posedge ui_in[3]) begin
    if (!rst_n || ui_in[3])
        expected <= 8'd0;
    else begin
        if (ui_in[2])               // load button
            expected <= 8'd46;
        else if (ui_in[0] && !ui_in[1])  // up
            expected <= expected + 1;
        else if (ui_in[1] && !ui_in[0])  // down
            expected <= expected - 1;
    end
end

    // Checker
    always @(posedge clk) begin
        if (rst_n) begin
            if (uo_out !== expected) begin
                $display("ERROR at time %0t: expected=%0d got=%0d",
                         $time, expected, uo_out);
                errors = errors + 1;
            end
        end
    end

    // Test sequence
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_top);

        clk = 0;
        rst_n = 0;
        ui_in = 0;
        errors = 0;

        // Reset
        #20;
        rst_n = 1;

        // Test 1: Count Up
        ui_in[0] = 1;     // up button
        #200;
        ui_in[0] = 0;

        // Test 2: Count Down
        ui_in[1] = 1;     // down button
        #200;
        ui_in[1] = 0;

        // Test 3: Load
        ui_in[2] = 1;     // load button = load 46
        #10;
        ui_in[2] = 0;

        // Count up 
        ui_in[0] = 1;
        #100;
        ui_in[0] = 0;

        // Count down
        ui_in[1] = 1;
        #100;
        ui_in[1] = 0;

        // Test 4: Reset Button
        // Count up
        ui_in[0] = 1;
        #50;
        ui_in[0] = 0;

        // Reset
        ui_in[3] = 1;
        #10;
        ui_in[3] = 0;

        // Final report
        #20;
        if (errors == 0) begin
            $display("=================================");
            $display(" ALL TESTS PASSED ");
            $display("=================================");
        end else begin
            $display("=================================");
            $display(" TEST FAILED with %0d errors ", errors);
            $display("=================================");
        end

        $finish;
    end

endmodule