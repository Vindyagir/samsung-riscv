module iiitb_rv32i_tb;

reg clk,RN;
wire [31:0]WB_OUT,NPC;

iiitb_rv32i rv32(clk,RN,NPC,WB_OUT);

`timescale 1ns/1ps

module sam_rv32i_tb;

    // Testbench signals
    reg clk;
    reg RN;
    wire [31:0] NPC;
    wire [31:0] WB_OUT;

    // Instantiate the DUT (Device Under Test)
    sam_rv32i dut (
        .clk(clk),
        .RN(RN),
        .NPC(NPC),
        .WB_OUT(WB_OUT)
    );

    // Generate a clock signal (50MHz clock, 20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Toggle clock every 10ns
    end

    // Testbench logic
    initial begin
        // Initialize reset
        RN = 1;
        #20;   // Hold reset for 20ns

        RN = 0;  // Release reset
        #2000;  // Run simulation for 2000ns

        // Finish simulation
        $finish;
    end

    // Monitor output values
    initial begin
        $monitor("Time: %0t | NPC: %h | WB_OUT: %h", $time, NPC, WB_OUT);
    end

    // Dump waveforms for debugging
    initial begin
      $dumpfile("tb_sam_rv32i.vcd");  // VCD file for waveform dump
      $dumpvars(0, tb_sam_rv32i);     // Dump all variables in the testbench
    end

endmodule
