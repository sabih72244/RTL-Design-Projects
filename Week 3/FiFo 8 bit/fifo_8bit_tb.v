`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:44:57 PM
// Design Name: 
// Module Name: fifo_8bit_tb
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


module fifo_8bit_tb;
reg clk;
    reg reset;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    
    wire [7:0] data_out;
    wire full;
    wire empty;
    wire [4:0] fifo_count;

    // Instantiate UUT
    fifo_8bit #(
        .DATA_WIDTH(8),
        .FIFO_DEPTH(16),
        .ADDR_WIDTH(4)
    ) uut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .fifo_count(fifo_count)
    );

    // 100MHz clock generation (10ns period)
    always #5 clk = ~clk;

    integer i;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        #15;
        reset = 0;
        #10;

        // ====================================================================
        // CASE 1: Basic Burst Write and Read (3 items)
        // ====================================================================
        $display("--- CASE 1: Basic Write and Read ---");
        @(posedge clk); #1 wr_en = 1; data_in = 8'hAA;
        @(posedge clk); #1 wr_en = 1; data_in = 8'hBB;
        @(posedge clk); #1 wr_en = 1; data_in = 8'hCC;
        @(posedge clk); #1 wr_en = 0; // Turn off write

        #20; // Idle space

        @(posedge clk); #1 rd_en = 1; // Read out 8'hAA
        @(posedge clk); #1 rd_en = 1; // Read out 8'hBB
        @(posedge clk); #1 rd_en = 1; // Read out 8'hCC
        @(posedge clk); #1 rd_en = 0;
        #20;

        // ====================================================================
        // CASE 2: Fill FIFO completely & Test Overflow Protection
        // ====================================================================
        $display("--- CASE 2: Testing Full and Overflow ---");
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk); #1 wr_en = 1; data_in = i;
        end
        // At this point FIFO is Full. Try writing a 17th item (Should be blocked)
        @(posedge clk); #1 data_in = 8'hFF; 
        @(posedge clk); #1 wr_en = 0;
        #20;

        // ====================================================================
        // CASE 3: Empty FIFO completely & Test Underflow Protection
        // ====================================================================
        $display("--- CASE 3: Testing Empty and Underflow ---");
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk); #1 rd_en = 1;
        end
        // At this point FIFO is Empty. Try reading a 17th time (Should be ignored)
        @(posedge clk); #1;
        @(posedge clk); #1 rd_en = 0;
        #20;

        // ====================================================================
        // CASE 4: Simultaneous Read and Write
        // ====================================================================
        $display("--- CASE 4: Simultaneous Read and Write ---");
        // Pre-fill with 1 element so read is valid
        @(posedge clk); #1 wr_en = 1; data_in = 8'h11;
        @(posedge clk); #1 wr_en = 0;
        #10;
        
        // Command a write and a read during the exact same clock step
        @(posedge clk); #1;
        wr_en = 1; data_in = 8'h22;
        rd_en = 1;
        
        @(posedge clk); #1;
        wr_en = 0;
        rd_en = 0;

        #50;
        $display("FIFO Simulation Complete.");
        $finish;
    end
endmodule
