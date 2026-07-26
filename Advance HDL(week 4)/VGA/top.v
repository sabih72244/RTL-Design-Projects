`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2026 12:02:06
// Design Name: 
// Module Name: top
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


module top(


input clk,
input reset,

output hsync,
output vsync,

output [7:0] red,
output [7:0] green,
output [7:0] blue

);

wire [9:0] h_count;
wire [9:0] v_count;

wire video_on;

wire [18:0] address;

wire [7:0] pixel;

video_controller VC(

.clk(clk),
.reset(reset),

.hsync(hsync),
.vsync(vsync),

.h_count(h_count),
.v_count(v_count),

.video_on(video_on)

);

address_generator AG(

.clk(clk),

.h_count(h_count),
.v_count(v_count),

.address(address)

);

sram MEM(

.clk(clk),

.we(1'b0),

.address(address),

.data_in(8'd0),

.data_out(pixel)

);

assign red   = video_on ? pixel : 8'd0;
assign green = video_on ? pixel : 8'd0;
assign blue  = video_on ? pixel : 8'd0;

endmodule

