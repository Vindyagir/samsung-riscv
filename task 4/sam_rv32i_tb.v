module sam_rv32i_tb;

reg clk, RN;
wire [31:0] WB_OUT, NPC;

// Instantiate the module under test
sam_rv32i rv32(clk, RN, NPC, WB_OUT);

// Clock generation
always #3 clk = !clk;

initial begin 
    // Initialize signals
    RN  = 1'b1;
    clk = 1'b1;

    // Enable waveform dump for simulation
    $dumpfile("sam_rv32i.vcd"); // VCD file for waveform analysis
    $dumpvars(0, sam_rv32i_tb);
    
    // Release reset after some time
    #5 RN = 1'b0;
    
    // Run simulation for a sufficient duration
    #300 $finish;
end

endmodule


