/*
# Team ID:          <eYRC#2776>
# Theme:            MazeSolver Bot
# Author List:      <Ayashkanta Mishra, Suhani Biswal, Jayesh Das>
# Filename:         main_decoder.v
# File Description: Implements the main control decoder for the RISC-V CPU. 
#                   It generates the primary control signals required for instruction execution, 
#                   including ALU, memory, and branch control signals based on opcode and function codes.
# Global variables: None
*/

module main_decoder (
    input  [6:0] op,          // op: 7-bit opcode from instruction
    input  [2:0] funct3,      // funct3: Function field for branch type differentiation
    input        Zero,        // Zero: ALU zero flag for branch decision
    input        ALUR31,      // ALUR31: ALU flag used for signed/unsigned branch comparison
    output [1:0] ResultSrc,   // ResultSrc: Selects data source for write-back
    output       MemWrite,    // MemWrite: Enables data memory write
	 output		  MemRead,
    output       Branch,      // Branch: Active when a branch condition is true
    output       ALUSrc,      // ALUSrc: Selects ALU operand source (immediate/register)
    output       RegWrite,    // RegWrite: Enables register file write
    output       Jump,        // Jump: Indicates jump instruction (JAL)
    output       Jalrsrc,     // Jalrsrc: Selects source for JALR target
    output [1:0] ImmSrc,      // ImmSrc: Selects type of immediate extension
    output [1:0] ALUOp        // ALUOp: Specifies ALU operation type for ALU decoder
);

    reg [11:0] controls;      // Encoded control signals: {RegWrite, ImmSrc[1:0], ALUSrc, MemWrite, ResultSrc[1:0], ALUOp[1:0], Jump, Jalrsrc}
    reg        TakeBranch;    // TakeBranch: Indicates if a branch condition is satisfied

    // Main decoder logic to generate control signals based on opcode
    always @(*) begin
        TakeBranch = 1'b0;    // Default: No branch
        case (op)
            // RegWrite_ImmSrc_ALUSrc_MemWrite_MemRead_ResultSrc_ALUOp_Jump_Jalrsrc
            7'b0000011: controls = 12'b1_00_1_0_1_01_00_0_0; // LW (Load Word)
            7'b0100011: controls = 12'b0_01_1_1_0_xx_00_0_0; // SW (Store Word)
            7'b0110011: controls = 12'b1_xx_0_0_0_00_10_0_0; // R-type (Register-Register)
            
            // Branch instructions (conditional)
            7'b1100011: begin
                controls = 12'b0_10_0_0_0_xx_01_0_0; // Base control for Branch type
                case (funct3)
                    3'b000: TakeBranch =  Zero;     // BEQ
                    3'b001: TakeBranch = !Zero;     // BNE
                    3'b100: TakeBranch =  ALUR31;   // BLT
                    3'b101: TakeBranch = !ALUR31;   // BGE
                    3'b110: TakeBranch =  ALUR31;   // BLTU
                    3'b111: TakeBranch = !ALUR31;   // BGEU
                endcase
            end

            7'b0010011: controls = 12'b1_00_1_0_0_00_10_0_0; // I-type ALU (e.g., ADDI)
            7'b1101111: controls = 12'b1_11_0_0_0_10_00_1_0; // JAL (Jump and Link)
            7'b1100111: controls = 12'b1_00_1_0_0_10_00_0_1; // JALR (Jump and Link Register)
            7'b0110111: controls = 12'b1_10_x_0_0_11_00_0_0; // LUI (Load Upper Immediate)
            7'b0010111: controls = 12'b1_10_x_0_0_11_00_0_0; // AUIPC (Add Upper Immediate to PC)

            default:    controls = 12'bx_xx_x_x_x_xx_xx_x_x; // Undefined/Invalid instruction
        endcase
    end

    // Assign decoded control signals
    assign Branch = TakeBranch;
    assign {RegWrite, ImmSrc, ALUSrc, MemWrite, MemRead, ResultSrc, ALUOp, Jump, Jalrsrc} = controls;

endmodule