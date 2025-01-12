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
<summary> Task 1:Spike Simulation  </summary>
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
