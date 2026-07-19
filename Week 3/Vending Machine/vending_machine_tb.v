`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:34:10 PM
// Design Name: 
// Module Name: vending_machine_tb
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


module vending_machine_tb;
reg clk;
    reg reset;
    reg [1:0] coin;
    wire dispense;
    wire change;

    // Instantiate UUT
    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .coin(coin),
        .dispense(dispense),
        .change(change)
    );

    // 100MHz Clock Generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        coin = 2'b00;

        // Release reset safely
        #15;
        reset = 0;

        // ---- TEST 1: Three Nickels (5c + 5c + 5c = 15c) ----
        @(posedge clk); #1 coin = 2'b01; // Nickel inserted (State goes 0c -> 5c)
        @(posedge clk); #1 coin = 2'b01; // Nickel inserted (State goes 5c -> 10c)
        @(posedge clk); #1 coin = 2'b01; // Nickel inserted (State goes 10c -> 0c, Dispenses!)
        
        // Clear coin slot for one cycle
        @(posedge clk); #1 coin = 2'b00;
        #20;

        // ---- TEST 2: Two Dimes (10c + 10c = 20c) ----
        @(posedge clk); #1 coin = 2'b10; // Dime inserted (State goes 0c -> 10c)
        @(posedge clk); #1 coin = 2'b10; // Dime inserted (State goes 10c -> 0c, Dispenses + Changes!)
        
        // Clear coin slot
        @(posedge clk); #1 coin = 2'b00;
        
        #40;
        $finish;
    end
endmodule
