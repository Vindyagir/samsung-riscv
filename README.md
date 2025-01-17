# samsung-riscv
## Hosted by
Global Academy of Technology, Electronics and Communication Engineering Department, in collaboration with **VLSI System Design** and the **Tech Connect Club**.

This workshop is part of the **Digital India RISC-V Mission 2025**, powered by **Samsung Semiconductor India Research (SSIR)**.

---

## Workshop Details
**Date**: 6th & 7th January  
**Venue**: Global Academy of Technology, Rajarajeshwari Nagar, Bengaluru - 560098

---

## Workshop Agenda

### **Part I: From Apps to Machine Code**
- Topic: How RISC-V simplifies the process of translating applications to machine code.

### **Part II: Converting RISC-V Verilog**
- Topic: Using open-source EDA tools to convert RISC-V Verilog RTL to GDS.

### **Part III: Programming the VSD Squadron Mini RISC-V Development Board**
- Topic: Hands-on programming experience with the VSD Squadron board.

---

## Resource Person
**Kunal Ghosh**
- Founder of VLSI System Design (VSD)
- IITian with over 15 years of experience in the VLSI industry.

---

## Highlights
- **Certification**: Certified by Samsung and VLSI System Design.
- **Internship Opportunity**: Secure a free internship in VLSI and Embedded Systems domain by attending the workshop.
- **Hands-On Learning**: Learn about cutting-edge open-source tools and RISC-V hardware.

---
## Tasks
<details>
<summary> Task 1:To perform C_Based and RISC-V lab  </summary>
<br> 

- To create a GitHub repository named "samsung-riscv" and watch the provided videos to understand the program flow.
  
-  Install the RISC-V toolchain using the VDI link mentioned in the shared PDF
   
- Refer to the C-based and RISC-V-based lab videos, replicate the steps on your machine, and capture snapshots of the process with the current date/time visible.
 
- simple c program
 ![c based lab](https://github.com/user-attachments/assets/05ff9317-f20d-498c-b46d-a5d2cb5bc973)

- disassembly code
-![c_to_Riscv_simpleprg](https://github.com/user-attachments/assets/ea20198d-e420-4bde-b301-bdc1081e5f1f)

-![riscv_based_2](https://github.com/user-attachments/assets/309f6139-a1f5-4f7d-9f7e-f0278751271e)
</details>

<details>
<summary> Task 2:Spike Simulation  </summary>
<br>
-Spike is a RISC-V architecture simulator that allows for the simulation of RISC-V programs and software stacks.

-The objective is to execute the `fact.c` code using both the `GCC compiler` and the `RISC-V  compiler`
, ensuring that both produce identical outputs in the terminal. To compile the code with the GCC compiler, use the following command.
- step 1:Compile the c code using `gcc copmiler` 
 ```Step1
$ gcc fact.c
$ ./a.out
```
- step 2: Compile the code with `riscv compiler`
 ![c_program](https://github.com/user-attachments/assets/6040b90d-d5fc-4973-96fb-648fdd01fcdf)
- using -O1 instruction.
```step2
$ riscv64-unknown-elf-gcc -O1 -mabi=lp64 -march=rv64i -o fact.o fact.c
```
![O1](https://github.com/user-attachments/assets/fa363937-08de-49b5-afbe-70d711bc10a9)
- using -Ofast instruction.
```
$ riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -o fact.o fact.c
```
![Ofast](https://github.com/user-attachments/assets/27731e46-5aef-4557-8c82-d0481f38eda5)

- Open the Objdump of code by using the below command
```bash
$ riscv64-unknown-elf-objdump -d sum_1ton.o | less  
```
- Open the debugger in another terminal by using the below command
```bash
$  spike -d pk fact.o 
```
- The rest steps are shown in the following snapshot.
![spike](https://github.com/user-attachments/assets/161d1bdd-5b8a-4ea6-8907-42a2746c3d38)
</details>
<details>
<summary> Task 3: RISC-V instructions</summary>

  ## RISC-V Instruction Types

### R-Type:

- Purpose: Used for register-to-register operations (e.g., addition, subtraction, bitwise operations).
> Fields: The layout for a **U-type** instruction is as follows
>| func7 | rs2 | rs1 | func3 | rd | opcode |
>|-------|----|----|-------|-----|-------|
>| 7 bits | 5 bits |5 bits |3 bits |5 bits | 7 bits |
- Example: add rd, rs1, rs2.
---
### I-Type:

- Purpose: Used for immediate arithmetic operations, loads, and JALR.
> Fields: The layout for an **I-type** instruction is as follows:
> | imm[11:0] | rs1 | func3 | rd | opcode |
> |-----------|-----|-------|----|--------|
> | 12 bits | 5 bits  | 3 bits | 5 bits | 7 bits |
- Example: addi rd, rs1, imm or ld rd, offset(rs1).
---
### S-Type:

- Purpose: Used for store instructions (storing register values to memory).
> Fields: The layout for an **S-type** instruction is as follows:
> | imm[11:5] | rs2 |rs1 | func3 | imm[4:0] | opcode |
> |-----------|-----|-----|------|----------|--------|
> | 7 bits | 5 bits  | 5 bits | 3 bits | 5 bits | 7 bits |
- Example: sb rs2, offset(rs1).
---
### B-Type:

- Purpose: Used for branch instructions (conditional jumps).
> Fields: The layout for an **B-type** instruction is as follows:
> | imm [12] | imm[10:5] | rs2 |rs1 | func3 | imm[4:1] | imm[11] | opcode |
> |----------|-----------|-----|----|-------|----------|--------|--------|
> | 1 bit | 6 bits  | 5 bits |5 bits | 3 bits | 4 bits | 1bits | 7 bits |
- Example: beq rs1, rs2, offset.
---
### U-Type:

- Purpose: Used for loading upper immediate values into a register.
> Fields:The layout for an **U-type** instruction is as follows:
> | imm[31:12] | rd | opcode |
>|------------|----|--------|
>| 20 bits | 5 bits | 7 bits |
- Example: auipc rd, imm.
---
 ### J-Type:

- Purpose: Used for jump instructions (e.g., jal).
> Fields:The layout for an **J-type** instruction is as follows:
> | imm [20] | imm[10:1] | imm[11] | imm[19:12] | rd | opcode |
> |----------|-----------|---------|------------|---|----------|
> | 1 bit | 11 bits  | 1 bit |7 bits | 5 bits | 7 bits |
- Example: jal rd, offset.

---
### Here is the 15 unique RISCV instructions 
- 1 
```
lui a0,0x2b
```
> The RISC-V instruction format for `LUI` is **U-type** ,which is used to load an immediate value into the upper 20 bits of register 
> The layout for a **U-type** instruction is as follows
>| imm[31:12] | rd | opcode |
>|------------|----|--------|
>| 20 bits | 5 bits | 7 bits |
>
> opcode for LUI : 0110111   
> imm[31:12] (20 bits) : 00000010101100000000  
> rd : a0 = 01010   
> rs1 : this instruction doesn't use rs1  
> rs2 : this instruction doesn't use rs2  
> funct3 : N/A  
> funct7 : N/A

---
#### 32-bit Instruction Encoding:00000010101100000000_01010_0110111
---
- 2 
```
addi sp,sp, -48
```
> The RISC-V instruction format for `ADDI` is **I-type**,which is used for instructions that add an immediate value to a resistor .
> The layout for an **I-type** instruction is as follows:
> | imm[11:0] | rs1 | func3 | rd | opcode |
> |-----------|-----|-------|----|--------|
> | 12 bits | 5 bits  | 3 bits | 5 bits | 7 bits |
>
> opcode for ADDI : 0010011   
> imm[11:0] (12 bits) -48 : 1111111111100  
> rd :  00010   
> rs1 : 00010 (register `sp`,which is x2)   
> funct3 for ADDI: 000   

 ---
#### 32-bit Instruction Encoding: 1111111111000000_00010_000_00010_0010011
---
-  3 
```
sd ra, 40(sp)
```
> The RISC-V instruction format for `SD` is **S-type**,which is used for instructions that add an immediate value to a resistor .
> The layout for an **S-type** instruction is as follows:
> | imm[11:5] | rs2 |rs1 | func3 | imm[4:0] | opcode |
> |-----------|-----|-----|------|----------|--------|
> | 7 bits | 5 bits  | 5 bits | 3 bits | 5 bits | 7 bits |
>
> opcode for SD : 0100011   
> imm[11:5] (7 bits for the upper part of the immediate) :0000100   
> imm[4:0] (5 bits for the lower part of the immediate) :  00000  
> rs1 : 00010 (register `sp`,which is x2)    
> rs2 : 00001 (register `x1` binary representation of 1)  
> func3 for SD: 011    

 ---
 #### 32-bit Instruction Encoding: 0000100_00001_00010_011_00000_0100011
---
 -  4 
 ```
auipc a5, 0xffff0
```
> The RISC-V instruction format for `AUIPC` is **U-type**,which is used for computing the sum of program counter (PC) and a 20-bit immediate value,and stores in resistor a5. 
> The layout for an **U-type** instruction is as follows:
> | imm[31:12] | rd | opcode |
>|------------|----|--------|
>| 20 bits | 5 bits | 7 bits |
>
> opcode for AUPIC :0010111
> rd (5 bits) `a5`(register x15) : 01111  
> imm[31:12] (20 bits) :1111111111111111   
> rs1 : N/A     
> rs2 : N/A  
> func3 for SD: N/A  

---
#### 32-bit Instruction Encoding:1111111111111111_01111_0010111

---
 -  5 
```
beqz a5, 10158
```
> The RISC-V instruction format for `BEQZ` is **B-type**,this instruction checks if the value in register `a5` is zero .If it is , the program branches to the offset `0x10158 `
> The layout for an **B-type** instruction is as follows:
> | imm [12] | imm[10:5] | rs2 |rs1 | func3 | imm[4:1] | imm[11] | opcode |
> |----------|-----------|-----|----|-------|----------|--------|--------|
> | 1 bit | 6 bits  | 5 bits |5 bits | 3 bits | 4 bits | 1bits | 7 bits |
>
> opcode for BEQZ : 1100011  
> imm[12] (1 bit) :0  
> imm[10:5] (6 bits) :000001  
> rs1 : (x15) 01111   
> rs2 : (x0) 00000  
> func3 for BEQ:000
> imm[4:1] (5 bits) : 01111
> imm[11] (1 bit):0
---
#### 32-bit Instruction Encoding:0_000001_00000_01111_000_01111_0_1100011

 ----
 - 6 
```
jalr zero, 0
```
> The RISC-V instruction format for `JALR` is **J-type**The instruction "jalr zero, 0" is an assembly language instruction in the RISC-V architecture. It stands for "Jump and Link Register.
> The layout for an **J-type** instruction is as follows:
> | imm [20] | imm[10:1] | imm[11] | imm[19:12] | rd | opcode |
> |----------|-----------|---------|------------|---|----------|
> | 1 bit | 11 bits  | 1 bit |7 bits | 5 bits | 7 bits |
>
> opcode for JALR : 1100111  
> imm[20] (1 bit) :0
> imm[10:1] (7 bits) :000001
> imm[11] (1 bit) :0
> imm[19:12] (7 bits) :000001
> rd : (x15) 01111   
> 
---
#### 32-bit Instruction Encoding:0_000001_0_000001_01111_1100111
 ----
 - 7
```
sb a5, 1944(gp)
```
> The RISC-V instruction format for `SB` is **S-type**,it means to store the byte value contained in the register `a5` into the memory address calculated by adding the immediate value `1944` to the address contained in the register `gp`
> The layout for an **S-type** instruction is as follows:
> | imm[11:5] | rs2 |rs1 | func3 | imm[4:0] | opcode |
> |-----------|-----|-----|------|----------|--------|
> | 7 bits | 5 bits  | 5 bits | 3 bits | 5 bits | 7 bits |
>
> opcode for SB : 0100011   
> imm[11:5] (6 bits of upper part of 1944) :0111100  
> imm[4:0] (5 bits of lower part of 1944) :11000   
> rs1 (register ,x3) gp : 01111    
> rs2 (register ,x15) a5 : 00000   
> func3 for SB:000 
---
#### 32-bit Instruction Encoding:0111100_00000_01111_000_11000_0100011
----
 - 8
```
bnez a5, 101ec
```
> The RISC-V instruction format for `BNEZ` is **B-type** ,this instruction checks if the value in the register `a5` is not zero.If the condition is true, it branches to the target address `101ec`. The branch target is calculated relative to the program counter `(PC)`.
> The layout for an **B-type** instruction is as follows:
> | imm [12] | imm[10:5] | rs2 |rs1 | func3 | imm[4:1] | imm[11] | opcode |
> |----------|-----------|-----|----|-------|----------|--------|--------|
> | 1 bit | 6 bits  | 5 bits |5 bits | 3 bits | 4 bits | 1bits | 7 bits |
> 
> opcode for SB : 1100011
> imm[12]  : 0
> imm[10:5] (6 bits) :000000
> imm[4:1] (4 bits) :1100
> imm[0]:0 
> rs1 (register ,x15) a5: 01111    
> rs2 (register ,x0) x0 : 00000   
> func3 for BNEZ:001
---
#### 32-bit Instruction Encoding:0_000000_00000_01111_001_1100_0_1100011
----
- 9
```
addiw sp,sp, -2
```
> The RISC-V instruction format for `ADDIW` is **I-type**,which is used for instructions that add an immediate value to a resistor .
> The layout for an **I-type** instruction is as follows:
> | imm[11:0] | rs1 | func3 | rd | opcode |
> |-----------|-----|-------|----|--------|
> | 12 bits | 5 bits  | 3 bits | 5 bits | 7 bits |
>
> opcode for ADDI : 0010011   
> imm[11:0] (12 bits) -48 : 1111111111110  
> rd :  01100   
> rs1 : 10101    
> funct3 for ADDI: 000   

 ---
#### 32-bit Instruction Encoding: 111111111110_10101_000_01100_0110011
---
- 9
```
ld ra, 8(sp)
```
> The RISC-V instruction format for `LD` is **I-type**,The ld (Load Doubleword) instruction loads a 64-bit (doubleword) value from memory into a destination register.
The effective memory address is calculated as the value in the base register `(sp)` plus the immediate offset `(8)`.
> The layout for an **I-type** instruction is as follows:
> | imm[11:0] | rs1 | func3 | rd | opcode |
> |-----------|-----|-------|----|--------|
> | 12 bits | 5 bits  | 3 bits | 5 bits | 7 bits |
>
> opcode for ADDI : 0000011   
> imm[11:0] (12 bits) -48 : 000000001000 
> rd :  00001   
> rs1 : 00010 (register `sp`,which is x2)   
> funct3 for ADDI: 011  

 ---
#### 32-bit Instruction Encoding: 000000010000_00010_011_00001_0000011
---
