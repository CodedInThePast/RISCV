/*
# Team ID:          <eYRC#2776>
# Theme:            MazeSolver Bot
# Author List:      <Ayashkanta Mishra, Suhani Biswal, Jayesh Das>
# Filename:         datapath.v
# File Description: Implements the datapath of the RISC-V CPU including ALU, register file, PC logic, and immediate generation
# Global variables: None
*/

module datapath (
    input         clk, reset,         // clk: System clock | reset: Active-high reset
    input  [1:0]  ResultSrc,          // Selects source for Result (ALU, memory, PC+4, etc.)
    input         PCSrc, ALUSrc,      // Control for PC source and ALU operand source
    input         RegWrite, Jalrsrc,  // Control for register write and JALR path
    input  [1:0]  ImmSrc,             // Control for immediate extension type
    input  [3:0]  ALUControl,         // ALU operation control input
    output        Zero, ALUR31,       // ALU zero flag and MSB output
    output [31:0] PC,                 // Current Program Counter
    input  [31:0] Instr,              // Current instruction
    output [31:0] Mem_WrAddr,         // Data memory write address
    output [31:0] Mem_WrData,         // Data memory write data
    input  [31:0] ReadData,           // Data read from memory
    output [31:0] Result              // Final result to write back to registers
);

	 //Internal Wire Initialization
    wire [31:0] PCNext, PCPlus4, PCTarget;
    wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult;
    wire [31:0] upimm = {Instr[31:12], 12'b0}; // LUI immediate concatenation
    wire [31:0] miximm;  // AUIPC adder output
    wire [31:0] auipcwire;   // LUI/AUIPC mux output
    wire [31:0] PCJump;  // Output of JALR mux

    // Next PC logic
    reset_ff #(32) pcreg(clk, reset, PCJump, PC);
    adder          pcadd4(PC, 32'd4, PCPlus4);               // PC + 4 adder
    adder          pcaddbranch(PC, ImmExt, PCTarget);        // PC + branch offset adder
    adder          pcauipc(PC, upimm, miximm);               // AUIPC addition adder
    mux2  #(32)    pcmux(PCPlus4, PCTarget, PCSrc, PCNext);  // Select next PC MUX
    mux2  #(32)    jalrmux(PCNext, ALUResult, Jalrsrc, PCJump); // Select JALR jump MUX

    // Register file and immediate generation
    reg_file       rf(clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
    imm_extend     ext(Instr[31:7], ImmSrc, ImmExt);

    // ALU logic and data selection
    mux2  #(32)    srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    alu            alu(SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux2  #(32)    umux(miximm, upimm, Instr[5], auipcwire);
    mux4  #(32)    resultmux(ALUResult, ReadData, PCPlus4, auipcwire, ResultSrc, Result);

    // Output assignments
    assign ALUR31     = ALUResult[31];   // Capture MSB of ALU result
    assign Mem_WrData = WriteData;       // Data to memory
    assign Mem_WrAddr = ALUResult;       // Address to memory

endmodule


