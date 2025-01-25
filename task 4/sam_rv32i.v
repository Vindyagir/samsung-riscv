module sam_rv32i(clk, RN, NPC, WB_OUT);
input clk;
input RN;
integer k;
wire EX_MEM_COND;

reg BR_EN;

// I_FETCH STAGE
reg[31:0] 
IF_ID_IR,
IF_ID_NPC;

// I_DECODE STAGE
reg[31:0] 
ID_EX_A,
ID_EX_B,
ID_EX_RD,
ID_EX_IMMEDIATE,
ID_EX_IR, 
ID_EX_NPC;

// EXECUTION STAGE
reg[31:0] 
EX_MEM_ALUOUT,
EX_MEM_B,
EX_MEM_IR;

parameter 
ADD = 3'd0,
SUB = 3'd1,
AND = 3'd2,
OR  = 3'd3,
XOR = 3'd4,
SLT = 3'd5,

ADDI = 3'd0,
SUBI = 3'd1,
ANDI = 3'd2,
ORI  = 3'd3,
XORI = 3'd4,

LW = 3'd0,
SW = 3'd1,

BEQ = 3'd0,
BNE = 3'd1,

SLL = 3'd0,
SRL = 3'd1;

parameter 
AR_TYPE = 7'd0,
M_TYPE = 7'd1,
BR_TYPE = 7'd2,
SH_TYPE = 7'd3;

// MEMORY STAGE
reg[31:0] 
MEM_WB_IR,
MEM_WB_ALUOUT,
MEM_WB_LDM;

output reg [31:0] WB_OUT, NPC;

// REG FILE
reg [31:0] REG[0:31];                                               
// 64*32 IMEM
reg [31:0] MEM[0:31];                                             
// 64*32 DMEM
reg [31:0] DM[0:31];

always @(posedge clk or posedge RN) begin
    if (RN) begin
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
        NPC <= BR_EN ? EX_MEM_ALUOUT : NPC + 32'd1;
        BR_EN <= 1'd0;
        IF_ID_IR <= MEM[NPC];
        IF_ID_NPC <= NPC + 32'd1;
    end
end

always @(posedge RN) begin  
    NPC <= 32'd0;  
    MEM[10] <= 32'h00b202b3;         // add r5, r4, r11 (Add r4 and r11, store in r5)
    MEM[11] <= 32'h00410113;         // addi r2, r2, 4  (Add immediate 4 to r2, store in r2)
    MEM[12] <= 32'h00812203;         // lw r4, 8(r2)    (Load word from memory at r2+8 into r4)
    MEM[13] <= 32'h00f282b3;         // sub r5, r5, r15 (Subtract r15 from r5, store in r5)
    MEM[14] <= 32'h01400263;         // beq r0, r0, 20  (Unconditional branch to instruction at offset 20)
    MEM[15] <= 32'h00330333;         // slli r6, r6, 3  (Shift left logical r6 by 3)
    MEM[16] <= 32'h0060a423;         // sw r6, 4(r1)    (Store word from r6 into memory at r1+4)
    MEM[17] <= 32'hfe2198e3;         // bne r2, r4, -8  (Branch if r2 != r4 to offset -8)
    MEM[18] <= 32'h01222423;         // sd r18, 8(r4)   (Store doubleword r18 at r4+8)
    MEM[19] <= 32'hfff10113;         // addi sp, sp, -16 (Adjust stack pointer by -16)
    MEM[20] <= 32'h00118133;         // or r2, r3, r1   (Logical OR between r3 and r1, result in r2)
    MEM[21] <= 32'h40319133;         // neg r3, r2      (Negate r2 and store in r3)
    MEM[22] <= 32'h00210023;         // sb r2, 0(r2)    (Store byte from r2 at r2+0)
    MEM[23] <= 32'h00c1a023;         // sh r12, 8(r3)   (Store halfword from r12 at r3+8)
    MEM[24] <= 32'h0082a823;         // sw r8, 16(r2)   (Store word from r8 at r2+16)
    MEM[26] <= 32'h00a110b3;         // slt r2, r2, r10 (Set r2 to 1 if r2 < r10)
    MEM[28] <= 32'h002105b3;         // xor r11, r2, r2 (Exclusive OR r2 with r2, result in r11)
end

// I_DECODE STAGE 
always @(posedge clk) begin
    ID_EX_A <= REG[IF_ID_IR[19:15]];
    ID_EX_B <= REG[IF_ID_IR[24:20]];
    ID_EX_RD <= IF_ID_IR[11:7];
    ID_EX_IR <= IF_ID_IR;
    ID_EX_IMMEDIATE <= {{20{IF_ID_IR[31]}}, IF_ID_IR[31:20]};
    ID_EX_NPC <= IF_ID_NPC;
end

// EXECUTION STAGE
always @(posedge clk) begin
    EX_MEM_IR <= ID_EX_IR;

    case (ID_EX_IR[6:0])
        AR_TYPE: begin
            case (ID_EX_IR[14:12])
                ADD: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_B;
                SUB: EX_MEM_ALUOUT <= ID_EX_A - ID_EX_B;
                AND: EX_MEM_ALUOUT <= ID_EX_A & ID_EX_B;
                OR:  EX_MEM_ALUOUT <= ID_EX_A | ID_EX_B;
                XOR: EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_B;
                SLT: EX_MEM_ALUOUT <= (ID_EX_A < ID_EX_B) ? 32'd1 : 32'd0;
            endcase
        end
        M_TYPE: begin
            case (ID_EX_IR[14:12])
                LW:  EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
                SW:  EX_MEM_ALUOUT <= ID_EX_A + ID_EX_IMMEDIATE;
            endcase
        end
        BR_TYPE: begin
            case (ID_EX_IR[14:12])
                BEQ: begin
                    EX_MEM_ALUOUT <= ID_EX_NPC + ID_EX_IMMEDIATE;
                    BR_EN <= (ID_EX_A == ID_EX_B) ? 1'd1 : 1'd0;
                end
                BNE: begin
                    EX_MEM_ALUOUT <= ID_EX_NPC + ID_EX_IMMEDIATE;
                    BR_EN <= (ID_EX_A != ID_EX_B) ? 1'd1 : 1'd0;
                end
            endcase
        end
        SH_TYPE: begin
            case (ID_EX_IR[14:12])
                SLL: EX_MEM_ALUOUT <= ID_EX_A << ID_EX_B[4:0];
                SRL: EX_MEM_ALUOUT <= ID_EX_A >> ID_EX_B[4:0];
            endcase
        end
    endcase
end

// MEMORY STAGE
always @(posedge clk) begin
    MEM_WB_IR <= EX_MEM_IR;

    case (EX_MEM_IR[6:0])
        AR_TYPE: MEM_WB_ALUOUT <= EX_MEM_ALUOUT;
        SH_TYPE: MEM_WB_ALUOUT <= EX_MEM_ALUOUT;

        M_TYPE: begin
            case (EX_MEM_IR[14:12])
                LW: MEM_WB_LDM <= DM[EX_MEM_ALUOUT];
                SW: DM[EX_MEM_ALUOUT] <= REG[EX_MEM_IR[24:20]];
            endcase
        end
    endcase
end

// WRITE BACK STAGE
always @(posedge clk) begin
    case (MEM_WB_IR[6:0])
        AR_TYPE: begin 
            WB_OUT <= MEM_WB_ALUOUT;
            REG[MEM_WB_IR[11:7]] <= MEM_WB_ALUOUT;
        end
        SH_TYPE: begin
            WB_OUT <= MEM_WB_ALUOUT;
            REG[MEM_WB_IR[11:7]] <= MEM_WB_ALUOUT;
        end
        M_TYPE: begin
            case (MEM_WB_IR[14:12])
                LW: begin
                    WB_OUT <= MEM_WB_LDM;
                    REG[MEM_WB_IR[11:7]] <= MEM_WB_LDM;
                end
            endcase
        end
    endcase
end

endmodule

