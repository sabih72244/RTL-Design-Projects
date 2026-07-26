`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2026 12:03:29
// Design Name: 
// Module Name: top_tb
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


module top_tb;

reg clk;
reg reset;

wire hsync;
wire vsync;

wire [7:0] red;
wire [7:0] green;
wire [7:0] blue;

top DUT(

.clk(clk),
.reset(reset),

.hsync(hsync),
.vsync(vsync),

.red(red),
.green(green),
.blue(blue)

);

initial

begin

clk=0;

forever #20 clk=~clk;

end

initial

begin

reset=1;

#100;

reset=0;

#1000000;

$finish;

end

initial

begin

$monitor("Time=%0t HSYNC=%b VSYNC=%b R=%d G=%d B=%d",
$time,
hsync,
vsync,
red,
green,
blue);

end

endmodule

