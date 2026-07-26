`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2026 12:00:27
// Design Name: 
// Module Name: sram
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


module sram(

input clk,
input we,
input [18:0] address,
input [7:0] data_in,

output reg [7:0] data_out

);

reg [7:0] memory [0:307199];

integer i;

initial
begin

    for(i=0;i<307200;i=i+1)
        memory[i]=i%256;

end

always @(posedge clk)
begin

    if(we)
        memory[address] <= data_in;

    data_out <= memory[address];

end

endmodule
