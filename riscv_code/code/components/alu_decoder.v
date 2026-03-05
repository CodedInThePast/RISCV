/*
# Team ID:          <eYRC#2776>
# Theme:            MazeSolver Bot
# Author List:      <Ayashkanta Mishra, Suhani Biswal, Jayesh Das>
# Filename:         alu_decoder.v
# File Description: Implements the ALU decoder logic that determines the ALU control signals 
#                   based on instruction function codes and ALU operation type.
# Global variables: None
*/
module alu_decoder (
    input            opb5,          // opb5: Bit 5 of opcode to differentiate instruction types
    input  [2:0]     funct3,        // funct3: 3-bit function field from instruction
    input            funct7b5,      // funct7b5: Bit 5 of funct7 used for differentiating operations like ADD/SUB
    input  [1:0]     ALUOp,         // ALUOp: Control signal from main decoder
    output reg [3:0] ALUControl     // ALUControl: Output signal selecting ALU operation
);
    // Determine ALU operation based on ALUOp and function fields
    always @(*) begin
        ALUControl = 4'b0000;  // Default assignment to prevent latches
        
        case (ALUOp)
            2'b00: ALUControl = 4'b0000;              // ADD (used for load/store)
            2'b01: ALUControl = 4'b0001;              // SUB (used for branch)
            2'b10: begin                              // R-type or I-type ALU operations
                case (funct3)
                    3'b000: begin
                        if (funct7b5 & opb5)
                            ALUControl = 4'b0001;     // SUB (R-type)
                        else
                            ALUControl = 4'b0000;     // ADD/ADDI
                    end
                    3'b001: ALUControl = 4'b0111;      // SLL/SLLI
                    3'b010: ALUControl = 4'b0101;      // SLT/SLTI
                    3'b011: ALUControl = 4'b0110;      // SLTU/SLTIU
                    3'b100: ALUControl = 4'b0100;      // XOR/XORI
                    3'b101: begin
                        if (funct7b5)
                            ALUControl = 4'b1001;     // SRA/SRAI
                        else
                            ALUControl = 4'b1000;     // SRL/SRLI
                    end
                    3'b110: ALUControl = 4'b0011;      // OR/ORI
                    3'b111: ALUControl = 4'b0010;      // AND/ANDI
                    default: ALUControl = 4'b0000;     // Default to ADD instead of xxxx
                endcase
            end
            default: ALUControl = 4'b0000;             // Default to ADD for undefined ALUOp
        endcase
    end
endmodule