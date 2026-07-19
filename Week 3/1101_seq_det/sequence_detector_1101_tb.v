`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:00:30 PM
// Design Name: 
// Module Name: sequence_detector_1101_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// File: tb_sequence_detector_1101.v


module tb_sequence_detector_1101;
    reg clk;
    reg reset;
    reg sequence_in;
    wire detector_out;

    // Instantiate UUT
    sequence_detector_1101 uut (
        .clk(clk), 
        .reset(reset), 
        .sequence_in(sequence_in), 
        .detector_out(detector_out)
    );

    // 100 MHz Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        sequence_in = 0;

        // Hold reset for 15ns (releases safely during low phase of clock)
        #15;
        reset = 0;
        
        // --- Vivado Non-Blocking Stimulus Pattern ---
        // We change sequence_in 1ns after the clock edge to show clean steps
        @(posedge clk); #1 sequence_in = 1; // Bit 1
        @(posedge clk); #1 sequence_in = 1; // Bit 1
        @(posedge clk); #1 sequence_in = 0; // Bit 0
        @(posedge clk); #1 sequence_in = 1; // Bit 1 -> DETECTOR_OUT WILL GO HIGH HERE
        
        // Overlap test (1101101)
        @(posedge clk); #1 sequence_in = 1; // Bit 1
        @(posedge clk); #1 sequence_in = 0; // Bit 0
        @(posedge clk); #1 sequence_in = 1; // Bit 1 -> SECOND DETECTION HERE
        
        @(posedge clk); #1 sequence_in = 0;
        #50;
        $finish;
    end
endmodule
