`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2026 11:59:23
// Design Name: 
// Module Name: address_generator
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


module address_generator(

input clk,
input [9:0] h_count,
input [9:0] v_count,

output reg [18:0] address

);

always @(posedge clk)
begin

    if(h_count < 640 && v_count < 480)
        address <= v_count*640 + h_count;
    else
        address <= 0;

end
endmodule
