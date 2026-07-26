`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2026 12:01:18
// Design Name: 
// Module Name: video_controller
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


module video_controller(

input clk,
input reset,

output reg hsync,
output reg vsync,

output reg [9:0] h_count,
output reg [9:0] v_count,

output video_on

);

parameter H_VISIBLE=640;
parameter H_FRONT=16;
parameter H_SYNC=96;
parameter H_BACK=48;
parameter H_TOTAL=800;

parameter V_VISIBLE=480;
parameter V_FRONT=10;
parameter V_SYNC=2;
parameter V_BACK=33;
parameter V_TOTAL=525;

always @(posedge clk or posedge reset)

begin

if(reset)

begin
h_count<=0;
v_count<=0;
end

else

begin

if(h_count==H_TOTAL-1)

begin

h_count<=0;

if(v_count==V_TOTAL-1)
v_count<=0;

else
v_count<=v_count+1;

end

else
h_count<=h_count+1;

end

end

always @(*)

begin

hsync=~((h_count>=656)&&(h_count<752));

vsync=~((v_count>=490)&&(v_count<492));

end

assign video_on=(h_count<640)&&(v_count<480);

endmodule

