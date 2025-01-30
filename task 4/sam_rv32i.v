module sam_rv32i(clk, RN, NPC, WB_OUT);
input clk;
input RN;
integer k;
wire EX_MEM_COND;
reg BR_EN;

// IF Stage
reg [31:0] IF_ID_IR, IF_ID_NPC;

// ID Stage
reg [31:0] ID_EX_A, ID_EX_B, ID_EX_RD, ID_EX_IMMEDIATE, ID_EX_IR, ID_EX_NPC;

// EX Stage
reg [31:0] EX_MEM_ALUOUT, EX_MEM_B, EX_MEM_IR;

parameter ADD = 3'd0, SUB = 3'd1, AND = 3'd2, OR = 3'd3, XOR = 3'd4, SLT = 3'd5;
parameter ADDI = 3'd0, SUBI = 3'd1, ANDI = 3'd2, ORI = 3'd3, XORI = 3'd4;
parameter LW = 3'd0, SW = 3'd1;
parameter BEQ = 3'd0, BNE = 3'd1;
parameter SLL = 3'd0, SRL = 3'd1;

parameter AR_TYPE = 7'd0, M_TYPE = 7'd1, BR_TYPE = 7'd2, SH_TYPE = 7'd3;

// MEM Stage
reg [31:0] MEM_WB_IR, MEM_WB_ALUOUT, MEM_WB_LDM;

output reg [31:0] WB_OUT, NPC;

// Register and Memory
reg [31:0] REG[0:31];
reg [31:0] MEM[0:31];
reg [31:0] DM[0:31];

always @(posedge clk or posedge RN) begin
    if(RN) begin
        NPC <= 32'd0;
        BR_EN <= 1'd0; 
        REG[0] <= 32'h00000000;
        REG[1] <= 32'd10;
        REG[2] <= 32'd20;
        REG[3] <= 32'd30;
        REG[4] <= 32'd40;
        REG[5] <= 32'd50;
        REG[6] <= 32'd60;
    end else begin
        NPC <= BR_EN ? EX_MEM_ALUOUT : NPC + 32'd2;
        BR_EN <= 1'd0;
        IF_ID_IR <= MEM[NPC];
        IF_ID_NPC <= NPC + 32'd2;
    end
end

always @(posedge RN) begin
    MEM[0] <= 32'h0020A300; // add r6, r2, r3
    MEM[1] <= 32'h0030B380; // sub r7, r2, r3
    MEM[2] <= 32'h0040C400; // and r8, r2, r4
    MEM[3] <= 32'h0050D480; // or r9, r3, r5
    MEM[4] <= 32'h0060E500; // xor r10, r4, r6
    MEM[5] <= 32'h00710580; // slt r11, r5, r7
    MEM[6] <= 32'h00820600; // addi r12, r6, 8
    MEM[7] <= 32'h00909181; // sw r3, r2, 4
    MEM[8] <= 32'h00A08681; // lw r13, r2, 4
    MEM[9] <= 32'h00F00003; // beq r1, r1, 16
end

// Decode Stage
always @(posedge clk) begin
    ID_EX_A <= REG[IF_ID_IR[19:15]];
    ID_EX_B <= REG[IF_ID_IR[24:20]];
    ID_EX_RD <= REG[IF_ID_IR[11:7]];
    ID_EX_IR <= IF_ID_IR;
    ID_EX_IMMEDIATE <= {{20{IF_ID_IR[31]}}, IF_ID_IR[31:20]};
    ID_EX_NPC <= IF_ID_NPC;
end

// Execution Stage
always @(posedge clk) begin
    EX_MEM_IR <= ID_EX_IR;
    case(ID_EX_IR[6:0])
        AR_TYPE: begin
            case(ID_EX_IR[14:12])
                ADD: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_B + 1;
                SUB: EX_MEM_ALUOUT <= ID_EX_A - ID_EX_B - 1;
                AND: EX_MEM_ALUOUT <= ID_EX_A & ID_EX_B;
                OR:  EX_MEM_ALUOUT <= ID_EX_A | ID_EX_B;
                XOR: EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_B;
                SLT: EX_MEM_ALUOUT <= (ID_EX_A < ID_EX_B) ? 32'd1 : 32'd0;
            endcase
        end
        M_TYPE: begin
            case(ID_EX_IR[14:12])
                LW:  EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
                SW:  EX_MEM_ALUOUT <= ID_EX_IR[24:20] + ID_EX_IR[19:15];
            endcase
        end
        BR_TYPE: begin
            case(ID_EX_IR[14:12])
                BEQ: begin 
                    EX_MEM_ALUOUT <= ID_EX_NPC + ID_EX_IMMEDIATE;
                    BR_EN <= (ID_EX_IR[19:15] == ID_EX_IR[11:7]);
                end
                BNE: begin 
                    EX_MEM_ALUOUT <= ID_EX_NPC + ID_EX_IMMEDIATE;
                    BR_EN <= (ID_EX_IR[19:15] != ID_EX_IR[11:7]);
                end
            endcase
        end
    endcase
end

// Memory Stage
always @(posedge clk) begin
    MEM_WB_IR <= EX_MEM_IR;
    case(EX_MEM_IR[6:0])
        AR_TYPE: MEM_WB_ALUOUT <= EX_MEM_ALUOUT;
        M_TYPE: begin
            case(EX_MEM_IR[14:12])
                LW: MEM_WB_LDM <= DM[EX_MEM_ALUOUT];
                SW: DM[EX_MEM_ALUOUT] <= REG[EX_MEM_IR[11:7]];
            endcase
        end
    endcase
end

// Write Back Stage
always @(posedge clk) begin
    case(MEM_WB_IR[6:0])
        AR_TYPE: begin 
            WB_OUT <= MEM_WB_ALUOUT;
            REG[MEM_WB_IR[11:7]] <= MEM_WB_ALUOUT;
        end
        M_TYPE: begin
            case(MEM_WB_IR[14:12])
                LW: begin
                    WB_OUT <= MEM_WB_LDM;
                    REG[MEM_WB_IR[11:7]] <= MEM_WB_LDM;
                end
            endcase
        end
    endcase
end

endmodule
