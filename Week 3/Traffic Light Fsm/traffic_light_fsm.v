`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:21:31 PM
// Design Name: 
// Module Name: traffic_light_fsm
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


module traffic_light_fsm(
input  wire clk,
    input  wire reset,
    output reg [2:0] main_road, // [2]=Red, [1]=Yellow, [0]=Green
    output reg [2:0] side_road  // [2]=Red, [1]=Yellow, [0]=Green
);

    // State definitions
    localparam M_GREEN_S_RED  = 2'b00,
               M_YELLOW_S_RED = 2'b01,
               M_RED_S_GREEN  = 2'b10,
               M_RED_S_YELLOW = 2'b11;

    // Timing constants (assuming 100MHz clock scaled down, or cycle counts for simulation)
    localparam GREEN_CYCLES  = 4,
               YELLOW_CYCLES = 2;

    reg [1:0] current_state, next_state;
    reg [3:0] timer; // Internal countdown timer

    // 1. Sequential State and Timer Memory
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= M_GREEN_S_RED;
            timer         <= 0;
        end else begin
            current_state <= next_state;
            
            // Increment timer or reset it on state change
            if (current_state != next_state)
                timer <= 0;
            else
                timer <= timer + 1;
        end
    end

    // 2. Next State Combinational Logic
    always @(*) begin
        case (current_state)
            M_GREEN_S_RED: begin
                if (timer >= (GREEN_CYCLES - 1)) next_state = M_YELLOW_S_RED;
                else                            next_state = M_GREEN_S_RED;
            end
            M_YELLOW_S_RED: begin
                if (timer >= (YELLOW_CYCLES - 1)) next_state = M_RED_S_GREEN;
                else                             next_state = M_YELLOW_S_RED;
            end
            M_RED_S_GREEN: begin
                if (timer >= (GREEN_CYCLES - 1)) next_state = M_RED_S_YELLOW;
                else                            next_state = M_RED_S_GREEN;
            end
            M_RED_S_YELLOW: begin
                if (timer >= (YELLOW_CYCLES - 1)) next_state = M_GREEN_S_RED;
                else                             next_state = M_RED_S_YELLOW;
            end
            default: next_state = M_GREEN_S_RED;
        endcase
    end

    // 3. Moore Output Logic (Depends purely on the current state)
    always @(*) begin
        case (current_state)
            M_GREEN_S_RED:  begin main_road = 3'b001; side_road = 3'b100; end // Main: G, Side: R
            M_YELLOW_S_RED: begin main_road = 3'b010; side_road = 3'b100; end // Main: Y, Side: R
            M_RED_S_GREEN:  begin main_road = 3'b100; side_road = 3'b001; end // Main: R, Side: G
            M_RED_S_YELLOW: begin main_road = 3'b100; side_road = 3'b010; end // Main: R, Side: Y
            default:        begin main_road = 3'b100; side_road = 3'b100; end // Safety: Both Red
        endcase
    end
endmodule
