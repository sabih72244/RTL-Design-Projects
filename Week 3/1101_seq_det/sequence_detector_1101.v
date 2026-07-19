`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 05:58:58 PM
// Design Name: 
// Module Name: sequence_detector_1101
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


// File: sequence_detector_1101.v
module sequence_detector_1101 (
    input  wire clk,
    input  wire reset,
    input  wire sequence_in,
    output reg  detector_out
);

    localparam IDLE = 2'b00,
               S1   = 2'b01,
               S11  = 2'b10,
               S110 = 2'b11;

    reg [1:0] current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) current_state <= IDLE;
        else       current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:  next_state = sequence_in ? S1  : IDLE;
            S1:    next_state = sequence_in ? S11 : IDLE;
            S11:   next_state = sequence_in ? S11 : S110;
            S110:  next_state = sequence_in ? S1  : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Fixed output logic assignment
    always @(*) begin
        if ((current_state == S110) && (sequence_in == 1'b1))
            detector_out = 1'b1; 
        else
            detector_out = 1'b0;
    end

endmodule