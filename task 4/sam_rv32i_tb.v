`timescale 1ns/1ps

module sam_rv32i_tb;
    // Inputs
    reg clk;
    reg RN;

    // Outputs
    wire [31:0] WB_OUT;
    wire [31:0] NPC;

    // Instantiate the DUT (Device Under Test)
    sam_rv32i uut (
        .clk(clk),
        .RN(RN),
        .NPC(NPC),
        .WB_OUT(WB_OUT)
    );

    // Clock generation (50 MHz clock, 20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Toggle clock every 10ns
    end

    // Test stimulus
    initial begin
        // Initialize reset
        RN = 1;
        #20;   // Hold reset for 20ns
        RN = 0;  // Release reset

        // Run simulation for a specific duration
        #2000;  // Simulate for 2000ns
        $finish;  // Finish the simulation
    end

    // Monitor output values
    initial begin
        $monitor("Time: %0t | NPC: %h | WB_OUT: %h", $time, NPC, WB_OUT);
    end

    // Dump waveforms for debugging
    initial begin
        $dumpfile("sam_rv32i_tb.vcd");  // VCD file for waveform dump
        $dumpvars(0, sam_rv32i_tb);     // Dump all variables in the testbench
    end
endmodule

