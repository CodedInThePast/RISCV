/*
# Team ID:          <eYRC#2776>
# Theme:            MazeSolver Bot
# Author List:      <Ayashkanta Mishra, Suhani Biswal, Jayesh Das>
# Filename:         alu.v
# File Description: Implements a 32-bit parameterized Arithmetic Logic Unit (ALU) 
#                   that performs arithmetic, logical, and shift operations based on control signals.
# Global variables: None
*/

module alu #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] a, b,       // a, b: Input operands
    input  [3:0]       alu_ctrl,   // alu_ctrl: ALU control signal determining operation
    output reg [WIDTH-1:0] alu_out,// alu_out: Result of ALU operation
    output              zero       // zero: Flag set when alu_out = 0
);

    // ALU operation based on control signal
    always @(a, b, alu_ctrl) begin
        case (alu_ctrl)
            4'b0000: alu_out = a + b;                               // ADD
            4'b0001: alu_out = a - b;                               // SUB
            4'b0010: alu_out = a & b;                               // AND
            4'b0011: alu_out = a | b;                               // OR
            4'b0100: alu_out = a ^ b;                               // XOR
            4'b0101: alu_out = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  // SLT (signed)
            4'b0110: alu_out = (a < b) ? 32'd1 : 32'd0;             // SLTU (unsigned)
            4'b0111: alu_out = a << b[4:0];                         // SLL (Shift Left Logical)
            4'b1000: alu_out = a >> b[4:0];                         // SRL (Shift Right Logical)
            4'b1001: alu_out = $signed(a) >>> b[4:0];               // SRA (Shift Right Arithmetic)
            default: alu_out = 32'b0;                               // Default: Zero output
        endcase
    end

    // Zero flag assignment
    assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule