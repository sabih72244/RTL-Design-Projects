`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2026 10:02:35 PM
// Design Name: 
// Module Name: cache_controller
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


module cache_controller(
input clk,
    input reset,
    input read,
    input write,
    input [7:0] address,
    input [7:0] write_data,

    output reg [7:0] read_data,
    output reg hit
);

    // Cache Arrays
    reg [7:0] data_way0 [0:3];
    reg [7:0] data_way1 [0:3];

    reg [5:0] tag_way0 [0:3];
    reg [5:0] tag_way1 [0:3];

    reg valid_way0 [0:3];
    reg valid_way1 [0:3];

    // LRU
    reg lru [0:3];

    wire [5:0] tag;
    wire [1:0] index;

    integer i;

    assign tag   = address[7:2];
    assign index = address[1:0];

    always @(posedge clk or posedge reset)
    begin

        if(reset)
        begin

            read_data <= 8'h00;
            hit <= 0;

            for(i=0;i<4;i=i+1)
            begin
                valid_way0[i] <= 0;
                valid_way1[i] <= 0;

                tag_way0[i] <= 0;
                tag_way1[i] <= 0;

                data_way0[i] <= 0;
                data_way1[i] <= 0;

                lru[i] <= 0;
            end
        end

        else
        begin

            hit <= 0;

            // WRITE OPERATION

            if(write)
            begin

                // Write Hit Way0
                if(valid_way0[index] &&
                  (tag_way0[index] == tag))
                begin
                    data_way0[index] <= write_data;
                    hit <= 1;
                    lru[index] <= 1;
                end

                // Write Hit Way1
                else if(valid_way1[index] &&
                       (tag_way1[index] == tag))
                begin
                    data_way1[index] <= write_data;
                    hit <= 1;
                    lru[index] <= 0;
                end

                // Write Miss
                else
                begin

                    if(lru[index] == 0)
                    begin
                        tag_way0[index]   <= tag;
                        data_way0[index]  <= write_data;
                        valid_way0[index] <= 1;

                        lru[index] <= 1;
                    end
                    else
                    begin
                        tag_way1[index]   <= tag;
                        data_way1[index]  <= write_data;
                        valid_way1[index] <= 1;

                        lru[index] <= 0;
                    end
                end
            end

            // READ OPERATION

            if(read)
            begin

                // Read Hit Way0
                if(valid_way0[index] &&
                  (tag_way0[index] == tag))
                begin
                    read_data <= data_way0[index];
                    hit <= 1;
                    lru[index] <= 1;
                end

                // Read Hit Way1
                else if(valid_way1[index] &&
                       (tag_way1[index] == tag))
                begin
                    read_data <= data_way1[index];
                    hit <= 1;
                    lru[index] <= 0;
                end

                // Read Miss
                else
                begin
                    read_data <= 8'h00;
                    hit <= 0;
                end
            end

        end

    end
endmodule
