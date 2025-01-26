`timescale 1ns/1ps

module sam_rv32i_tb;
    // Testbench signals
    // Inputs
    reg clk;
    reg RN;
    wire [31:0] NPC;
    // Outputs
    wire [31:0] WB_OUT;
    wire [31:0] NPC;

    // Instantiate the DUT (Device Under Test)
    sam_rv32i dut (
    // Instantiate the module
    sam_rv32i uut (
        .clk(clk),
        .RN(RN),
        .NPC(NPC),
        .WB_OUT(WB_OUT)
    );

    // Generate a clock signal (50MHz clock, 20ns period)
    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Toggle clock every 10ns
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic
    // Test stimulus
    initial begin
        // Initialize reset
        // Initialize Reset
        RN = 1;
        #20;   // Hold reset for 20ns
        #10; // Allow reset to propagate

        RN = 0;  // Release reset
        #2000;  // Run simulation for 2000ns
        // Release Reset
        RN = 0;

        // Finish simulation
        $finish;
        // Observe the execution of instructions
        #1000 $stop; // Stop the simulation after some cycles
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
