# RISCV

Overview

This project implements a 32-bit RISC-V processor based on the RV32I instruction set architecture using Verilog HDL. The processor executes fundamental instruction categories including arithmetic, logical, memory, and control flow operations.
The design focuses on building the core datapath and control logic required for instruction execution and verifying the processor functionality through simulation.
The project demonstrates concepts from computer architecture, digital design, and hardware verification.

Architecture

The processor is designed using the classical RISC datapath model, consisting of the following major components:

Program Counter (PC)
Maintains the address of the current instruction and updates based on sequential execution or control flow instructions.

Instruction Memory Interface
Fetches instructions using the program counter.

Register File
A 32-register architecture following the RISC-V specification.

Immediate Generator
Extracts and sign-extends immediate values for different instruction formats.

Arithmetic Logic Unit (ALU)
Performs arithmetic and logical operations such as:

Addition / Subtraction
Bitwise AND, OR, XOR
Set Less Than
Shift operations

Control Unit
Decodes instructions and generates control signals for datapath operation.

Data Memory Interface
Handles load and store instructions.

Supported Instruction Types

The processor supports instructions from the RV32I base instruction set.

Arithmetic / Logical
ADD
ADDI
SUB
XOR
OR
AND
SLT

Shift Operations

SLL
SLLI
SRL
SRA

Memory Instructions

LW
SW
Control Flow
BEQ
BNE
JAL
JALR

Processor Datapath

The datapath integrates the following modules:

Program Counter
Instruction Memory
Register File
Immediate Generator
ALU
Control Unit
Data Memory

Instruction execution follows the standard Fetch → Decode → Execute → Memory → Writeback sequence.

Verification

Processor functionality is verified using Verilog simulation testbenches.
Verification includes:

Correct execution of arithmetic and logical operations
Proper register write-back
Accurate memory read/write operations
Correct program counter updates for branches and jumps
Simulation ensures that the processor produces the expected outputs for different instruction sequences.

Tools Used

Verilog HDL
ModelSim / QuestaSim / Vivado Simulator (for simulation)
GTKWave (for waveform analysis)

Project Structure
├── cpu.v              # Top-level RISC-V processor
├── alu.v              # Arithmetic Logic Unit
├── register_file.v   # Register file implementation
├── control_unit.v    # Instruction decoder and control signals
├── imm_gen.v         # Immediate generator
├── datapath.v        # Processor datapath
├── memory.v          # Instruction/Data memory
├── testbench.v       # Simulation testbench
