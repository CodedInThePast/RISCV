/*
# Team ID:          <eYRC#2776>
# Theme:            MazeSolver Bot
# Author List:      <Ayashkanta Mishra, Suhani Biswal, Jayesh Das>
# Filename:         controller.v
# File Description: Implements the main control unit of the RISC-V CPU. It generates control signals 
#                   for instruction execution by coordinating the main decoder and ALU decoder.
# Global variables: None
*/

module controller (
    input  [6:0] op,             // op: 7-bit opcode field from instruction
    input  [2:0] funct3,         // funct3: 3-bit function field
    input        funct7b5,       // funct7b5: Bit 5 of funct7 field
    input        Zero,           // Zero: ALU zero flag
    input        ALUR31,         // ALUR31: ALU flag for specific R-type control
    output [1:0] ResultSrc,      // ResultSrc: Selects source for write-back data
    output       MemWrite,       // MemWrite: Enables data memory write
	 output       MemRead,
    output       PCSrc,          // PCSrc: Selects next PC source (branch/jump)
    output       ALUSrc,         // ALUSrc: Selects ALU operand source
    output       RegWrite,       // RegWrite: Enables register write
    output       Jump,           // Jump: Indicates jump instruction
    output       Jalrsrc,        // Jalrsrc: Selects target for JALR jump
    output [1:0] ImmSrc,         // ImmSrc: Selects immediate generation type
    output [3:0] ALUControl      // ALUControl: Control signal for ALU operation
);

    wire [1:0] ALUOp;            // ALUOp: Control signal from main decoder for ALU type
    wire       Branch;           // Branch: Indicates branch instruction

    // Instantiate main decoder to generate control signals
    main_decoder md (
        op, funct3, Zero, ALUR31, 
        ResultSrc, MemWrite, MemRead, Branch,
        ALUSrc, RegWrite, Jump, Jalrsrc, ImmSrc, ALUOp
    );

    // Instantiate ALU decoder to determine ALU operation type
    alu_decoder ad (
        op[5], funct3, funct7b5, ALUOp, ALUControl
    );

    // Determine PC source based on Branch or Jump
    assign PCSrc = Branch | Jump;

endmodule