`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/19/2026 09:24:25 PM
// Design Name: 
// Module Name: ps2_receiver_tb
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


module ps2_receiver_tb;
    reg clk;
    reg reset;
    reg ps2_clk;
    reg ps2_data;

    wire [7:0] rx_data;
    wire data_valid;
    wire frame_error;

    // Instantiate DUT
    ps2_receiver uut(
        .clk(clk),
        .reset(reset),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .rx_data(rx_data),
        .data_valid(data_valid),
        .frame_error(frame_error)
    );

    // System Clock (not used in design, but required)
    always #5 clk = ~clk;

    // Task to send one PS/2 frame
    task send_ps2;
        input [7:0] data;
        integer i;
        reg parity;
    begin

        // Odd Parity Calculation
        parity = ~(^data);

        // Start Bit (0)
        ps2_data = 0;
        #10 ps2_clk = 0;
        #10 ps2_clk = 1;

        // Data Bits (LSB first)
        for(i=0;i<8;i=i+1) begin
            ps2_data = data[i];
            #10 ps2_clk = 0;
            #10 ps2_clk = 1;
        end

        // Parity Bit
        ps2_data = parity;
        #10 ps2_clk = 0;
        #10 ps2_clk = 1;

        // Stop Bit (1)
        ps2_data = 1;
        #10 ps2_clk = 0;
        #10 ps2_clk = 1;

    end
    endtask

    initial begin

        clk      = 0;
        reset    = 1;
        ps2_clk  = 1;
        ps2_data = 1;

        // Reset
        #20;
        reset = 0;

        //----------------------------------
        // Test Case 1 : Send 'A'
        // Scan Code = 1C
        //----------------------------------
        send_ps2(8'h1C);

        #50;

        //----------------------------------
        // Test Case 2 : Send 'B'
        // Scan Code = 32
        //----------------------------------
        send_ps2(8'h32);

        #50;

        //----------------------------------
        // Test Case 3 : Send 'C'
        // Scan Code = 21
        //----------------------------------
        send_ps2(8'h21);

        #50;

        //----------------------------------
        // Test Case 4 : Invalid Stop Bit
        //----------------------------------

        // Start Bit
        ps2_data=0;
        #10 ps2_clk=0; #10 ps2_clk=1;

        // Send 8'h1C
        ps2_data=0; #10 ps2_clk=0; #10 ps2_clk=1;
        ps2_data=0; #10 ps2_clk=0; #10 ps2_clk=1;
        ps2_data=1; #10 ps2_clk=0; #10 ps2_clk=1;
        ps2_data=1; #10 ps2_clk=0; #10 ps2_clk=1;
        ps2_data=1; #10 ps2_clk=0; #10 ps2_clk=1;
        ps2_data=0; #10 ps2_clk=0; #10 ps2_clk=1;
        ps2_data=0; #10 ps2_clk=0; #10 ps2_clk=1;
        ps2_data=0; #10 ps2_clk=0; #10 ps2_clk=1;

        // Parity Bit
        ps2_data=0;
        #10 ps2_clk=0; #10 ps2_clk=1;

        // Invalid Stop Bit = 0
        ps2_data=0;
        #10 ps2_clk=0; #10 ps2_clk=1;

        #50;

        $finish;

    end

    // Monitor
    initial begin
        $monitor(
            "Time=%0t Reset=%b PS2_DATA=%b RX_DATA=%h VALID=%b ERROR=%b",
            $time, reset, ps2_data, rx_data, data_valid, frame_error
        );
    end

endmodule
