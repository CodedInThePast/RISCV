
// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
	 output			MemRead,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);


    // Internal control and status signals
    wire        PCSrc, ALUSrc, RegWrite, Jump, Jalrsrc;
	 wire			 Zero, ALUR31;
    wire [1:0]  ResultSrc, ImmSrc;
	 wire	[3:0]  ALUControl;

    // Controller: Generates control signals based on instruction fields
    controller c (
        Instr[6:0],     // opcode
        Instr[14:12],   // funct3
        Instr[30],      // funct7[5]
        Zero, ALUR31,   // ALU flags
        ResultSrc, MemWrite, MemRead, PCSrc, ALUSrc,
        RegWrite, Jump, Jalrsrc,
        ImmSrc, ALUControl
    );

    // Datapath: Executes instruction operations
    datapath dp (
        clk, reset,
        ResultSrc, PCSrc,
        ALUSrc, RegWrite, Jalrsrc,
        ImmSrc, ALUControl,
        Zero, ALUR31,
        PC, Instr,
        Mem_WrAddr, Mem_WrData,
        ReadData, Result
    );

endmodule

