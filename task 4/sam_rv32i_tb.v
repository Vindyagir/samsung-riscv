`timescale 1ns/1ps

module sam_rv32i_tb;
    // Inputs
    reg clk;
    reg RN;

    // Outputs
    wire [31:0] WB_OUT;
    wire [31:0] NPC;

    // Instantiate the module
    sam_rv32i uut (
        .clk(clk),
        .RN(RN),
        .NPC(NPC),
        .WB_OUT(WB_OUT)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test stimulus
    initial begin
        // Initialize Reset
        RN = 1;
        #10; // Allow reset to propagate

        // Release Reset
        RN = 0;

        // Observe the execution of instructions
        #1000 $stop; // Stop the simulation after some cycles
    end
endmodule
