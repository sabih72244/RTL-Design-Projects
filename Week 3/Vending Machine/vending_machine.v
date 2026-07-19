`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:33:25 PM
// Design Name: 
// Module Name: vending_machine
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


module vending_machine(
    input  wire clk,
    input  wire reset,
    input  wire [1:0] coin, // 2'b00 = No coin, 2'b01 = Nickel (5c), 2'b10 = Dime (10c)
    output reg  dispense,
    output reg  change
);

    // State definitions tracking accumulated money
    localparam S_0c  = 2'b00,
               S_5c  = 2'b01,
               S_10c = 2'b10;

    reg [1:0] current_state, next_state;

    // 1. Sequential State Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S_0c;
        else
            current_state <= next_state;
    end

    // 2. Next State Combinational Logic
    always @(*) begin
        case (current_state)
            S_0c: begin
                if (coin == 2'b01)      next_state = S_5c;  // Insert Nickel -> 5c
                else if (coin == 2'b10) next_state = S_10c; // Insert Dime -> 10c
                else                    next_state = S_0c;
            end
            
            S_5c: begin
                if (coin == 2'b01)      next_state = S_10c; // Insert Nickel -> 10c
                else if (coin == 2'b10) next_state = S_0c;  // Insert Dime -> 15c (Dispenses, back to 0)
                else                    next_state = S_5c;
            end
            
            S_10c: begin
                if (coin == 2'b01)      next_state = S_0c;  // Insert Nickel -> 15c (Dispenses, back to 0)
                else if (coin == 2'b10) next_state = S_0c;  // Insert Dime -> 20c (Dispenses + Change, back to 0)
                else                    next_state = S_10c;
            end
            
            default: next_state = S_0c;
        endcase
    end

    // 3. Mealy Output Logic (Depends on current state AND current coin input)
    always @(*) begin
        // Default assignments to prevent latches
        dispense = 1'b0;
        change   = 1'b0;
        
        case (current_state)
            S_5c: begin
                if (coin == 2'b10) dispense = 1'b1; // 5c + 10c = 15c
            end
            S_10c: begin
                if (coin == 2'b01) dispense = 1'b1; // 10c + 5c = 15c
                else if (coin == 2'b10) begin
                    dispense = 1'b1; // 10c + 10c = 20c
                    change   = 1'b1; // 5c change returned
                end
            end
            default: begin
                dispense = 1'b0;
                change   = 1'b0;
            end
        endcase
    end

endmodule
