`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:43:40 PM
// Design Name: 
// Module Name: fifo_8bit
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


module fifo_8bit #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = 4  // 2^4 = 16 locations
)(
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   wr_en,
    input  wire                   rd_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output wire                   full,
    output wire                   empty,
    output reg  [ADDR_WIDTH:0]    fifo_count // Tracks current number of items
);

    // Memory array
    reg [DATA_WIDTH-1:0] memory [0:FIFO_DEPTH-1];

    // Read and write pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // Status Flag assignments
    assign empty = (fifo_count == 0);
    assign full  = (fifo_count == FIFO_DEPTH);

    // 1. Write Pointer, Read Pointer, and Item Counter Control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr     <= 0;
            rd_ptr     <= 0;
            fifo_count <= 0;
            data_out   <= 0;
        end else begin
            // Handle Write
            if (wr_en && !full) begin
                memory[wr_ptr] <= data_in;
                wr_ptr         <= wr_ptr + 1;
            end

            // Handle Read
            if (rd_en && !empty) begin
                data_out <= memory[rd_ptr];
                rd_ptr   <= rd_ptr + 1;
            end

            // Handle Item Tracker Counter
            case ({wr_en && !full, rd_en && !empty})
                2'b10: fifo_count <= fifo_count + 1; // Write only
                2'b01: fifo_count <= fifo_count - 1; // Read only
                2'b11: fifo_count <= fifo_count;     // Simultaneous read and write
                default: fifo_count <= fifo_count;
            endcase
        end
    end
endmodule
