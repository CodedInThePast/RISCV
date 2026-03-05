
// t1c_riscv_cpu.v - Top Module to test riscv_cpu
/*
# Team ID:          <eYRC#2776>
# Theme:            MazeSolver Bot
# Author List:      <Ayashkanta Mishra, Suhani Biswal, Jayesh Das>
# Filename:         t1c_riscv_cpu.v
# File Description: Top-level module integrating riscv_cpu with instruction and data memory
# Global variables: None
*/


module t1c_riscv_cpu (
    input         clk, reset,
    input         Ext_MemWrite,
    input  [31:0] Ext_WriteData, Ext_DataAdr,
    output        MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC, Result
);

	 wire [31:0] Instr;                  // Instruction fetched from instruction memory
    wire [31:0] DataAdr_rv32;           // Data address from riscv_cpu
    wire [31:0] WriteData_rv32;         // Write data from riscv_cpu
    wire        MemWrite_rv32;          // Memory write control from riscv_cpu
	 wire			 MemRead_rv32;

    // Instantiate processor and memories using positional association
    riscv_cpu rvcpu (clk, reset, PC, Instr, MemWrite_rv32, MemRead_rv32, DataAdr_rv32, WriteData_rv32, ReadData, Result);
    instr_mem instrmem (PC, Instr);
    data_mem  datamem  (clk, MemWrite, MemRead_rv32, Instr[14:12], DataAdr, WriteData, ReadData);

    // External control: allows memory access during reset for testing
    assign MemWrite  = (Ext_MemWrite && reset) ? 1'b1 : MemWrite_rv32;
    assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
    assign DataAdr   = reset ? Ext_DataAdr : DataAdr_rv32;

endmodule

