`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 09:23:49 PM
// Design Name: 
// Module Name: ps2_receiver
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


module ps2_receiver(
    input wire clk,          
    input wire reset,        // Asynchronous reset
    input wire ps2_clk,      // PS2 clock line from keyboard
    input wire ps2_data,     // PS2 data line from keyboard
    output reg [7:0] rx_data, // Received 8-bit data
    output reg data_valid,   // High for 1 clock cycle when data is ready
    output reg frame_error   // High if stop bit is missing
);

    // parameter use kiya hai taake states simple aur accessible rahein
    parameter IDLE   = 3'b000;
    parameter START  = 3'b001;
    parameter DATA   = 3'b010;
    parameter PARITY = 3'b011;
    parameter STOP   = 3'b100;
    parameter ERROR  = 3'b101;

    reg [2:0] current_state;
    reg [3:0] bit_count;      
    reg [7:0] shift_reg;      

    // State Machine & Logic (On PS2 Clock Falling Edge)
    always @(negedge ps2_clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            bit_count     <= 4'd0;
            shift_reg     <= 8'd0;
            rx_data       <= 8'd0;
            data_valid    <= 1'b0;
            frame_error   <= 1'b0;
        end else begin
            data_valid  <= 1'b0; 
            frame_error <= 1'b0;

            case (current_state)
                IDLE: begin
                    bit_count <= 4'd0;
                    if (ps2_data == 1'b0) // Start bit detected
                        current_state <= START;
                end

                START: begin
                    shift_reg[0]  <= ps2_data; // First data bit (LSB)
                    bit_count     <= 4'd1;
                    current_state <= DATA;
                end

                DATA: begin
                    shift_reg[bit_count] <= ps2_data;
                    bit_count <= bit_count + 4'd1;
                    if (bit_count == 4'd7)
                        current_state <= PARITY;
                end

                PARITY: begin
                    current_state <= STOP; // Move to stop bit state
                end

                STOP: begin
                    if (ps2_data == 1'b1) begin // Valid Stop bit (Must be 1)
                        rx_data    <= shift_reg;
                        data_valid <= 1'b1;
                        current_state <= IDLE;
                    end else begin             // Invalid Stop bit (If 0)
                        frame_error   <= 1'b1; // Trigger Error flag
                        current_state <= ERROR;
                    end
                end

                ERROR: begin
                    current_state <= IDLE; // Back to IDLE after error
                end

                default: current_state <= IDLE;
            endcase
        end
    end
endmodule
