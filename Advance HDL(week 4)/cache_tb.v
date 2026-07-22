`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2026 10:08:39 PM
// Design Name: 
// Module Name: cache_tb
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


module cache_tb;

    reg clk;
    reg reset;
    reg read;
    reg write;
    reg [7:0] address;
    reg [7:0] write_data;

    wire [7:0] read_data;
    wire hit;

    cache_controller DUT(
        .clk(clk),
        .reset(reset),
        .read(read),
        .write(write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .hit(hit)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial
    begin

        clk        = 0;
        reset      = 1;
        read       = 0;
        write      = 0;
        address    = 8'h00;
        write_data = 8'h00;

        #10;
        reset = 0;

        //--------------------------------
        // WRITE A0 -> 19
        //--------------------------------
        #10;
        write      = 1;
        address    = 8'hA0;
        write_data = 8'h19;

        #10;
        write = 0;

        //--------------------------------
        // READ A0
        //--------------------------------
        #10;
        read    = 1;
        address = 8'hA0;

        #10;
        read = 0;

        //--------------------------------
        // WRITE E0 -> 37
        //--------------------------------
        #10;
        write      = 1;
        address    = 8'hE0;
        write_data = 8'h37;

        #10;
        write = 0;

        //--------------------------------
        // READ E0
        //--------------------------------
        #10;
        read    = 1;
        address = 8'hE0;

        #10;
        read = 0;

        //--------------------------------
        // WRITE 20 -> 63
        //--------------------------------
        #10;
        write      = 1;
        address    = 8'h20;
        write_data = 8'h63;

        #10;
        write = 0;

        //--------------------------------
        // READ 20
        //--------------------------------
        #10;
        read    = 1;
        address = 8'h20;

        #10;
        read = 0;

        //--------------------------------
        // Finish Simulation
        //--------------------------------
        #20;
        $finish;

    end

    initial
    begin
        $monitor(
            "Time=%0t | Addr=%h | WData=%h | RData=%h | Read=%b | Write=%b | Hit=%b",
            $time,
            address,
            write_data,
            read_data,
            read,
            write,
            hit
        );
    end

endmodule
