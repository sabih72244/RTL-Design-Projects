`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 06:23:11 PM
// Design Name: 
// Module Name: traffic_light_fsm_tb
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


module traffic_light_fsm_tb;
    reg clk;
    reg reset;
    wire [2:0] main_road;
    wire [2:0] side_road;

    // Instantiate UUT
    traffic_light_fsm uut (
        .clk(clk),
        .reset(reset),
        .main_road(main_road),
        .side_road(side_road)
    );

    // 100MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Hold reset safely past clock edge
        #15;
        reset = 0;

        // Let the simulation run long enough to cycle through the inner timers
        #200; 

        $finish;
    end
    
endmodule
