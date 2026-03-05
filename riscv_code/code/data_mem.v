/*
# Team ID:          <eYRC#2776>
# Theme:            MazeSolver Bot
# Author List:      <Ayashkanta Mishra, Suhani Biswal, Jayesh Das>
# Filename:         data_mem.v
# File Description: Data memory module for RISC-V CPU supporting byte, halfword, and word operations
# Global variables: None
*/
module data_mem #(
    parameter DATA_WIDTH = 32,       // Width of data bus
    parameter ADDR_WIDTH = 32,       // Width of address bus
    parameter MEM_SIZE   = 64        // Number of 32-bit words in memory
)(
    input                        clk,         // Clock input
    input                        wr_en,       // Write enable signal
	 input 								mem_read,
    input       [2:0]            funct3,      // Function field based on Instruction Set
    input       [ADDR_WIDTH-1:0] wr_addr,     // Memory address
    input       [DATA_WIDTH-1:0] wr_data,     // Data to be written
    output reg  [DATA_WIDTH-1:0] rd_data_mem  // Data read output
);
    // data_ram: 32-bit memory array
    reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
    
    // word_addr: word-aligned memory index
    wire [ADDR_WIDTH-1:0] word_addr = wr_addr[DATA_WIDTH-1:2] % 64;
    
    // Initialize memory to zero
    integer i;
    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1)
            data_ram[i] = 32'hxxxxxxxx;
    end
    
    // Synchronous write logic
    always @(posedge clk) begin
        if (wr_en) begin
            case (funct3)
                3'b000: begin // SB (Store Byte)
                    case (wr_addr[1:0])
                        2'b00: data_ram[word_addr][7:0]   <= wr_data[7:0];
                        2'b01: data_ram[word_addr][15:8]  <= wr_data[7:0];
                        2'b10: data_ram[word_addr][23:16] <= wr_data[7:0];
                        2'b11: data_ram[word_addr][31:24] <= wr_data[7:0];
                    endcase
                end
                3'b001: begin // SH (Store Halfword)
                    if (wr_addr[1] == 1'b0)
                        data_ram[word_addr][15:0]  <= wr_data[15:0];
                    else
                        data_ram[word_addr][31:16] <= wr_data[15:0];
                end
                3'b010: data_ram[word_addr] <= wr_data; // SW (Store Word)
                default: ; // Do nothing for invalid store operations
            endcase
        end
    end
    
    // Combinational read logic
    always @(*) begin
        if (mem_read) begin  // ← Only output data during reads
            case (funct3)
                3'b000: begin // LB
                    case (wr_addr[1:0])
                        2'b00: rd_data_mem = {{24{data_ram[word_addr][7]}},  data_ram[word_addr][7:0]};
                        2'b01: rd_data_mem = {{24{data_ram[word_addr][15]}}, data_ram[word_addr][15:8]};
                        2'b10: rd_data_mem = {{24{data_ram[word_addr][23]}}, data_ram[word_addr][23:16]};
                        2'b11: rd_data_mem = {{24{data_ram[word_addr][31]}}, data_ram[word_addr][31:24]};
                        default: rd_data_mem = 32'bx;
                    endcase
                end
                3'b001: begin // LH
                    if (wr_addr[1] == 1'b0)
                        rd_data_mem = {{16{data_ram[word_addr][15]}}, data_ram[word_addr][15:0]};
                    else
                        rd_data_mem = {{16{data_ram[word_addr][31]}}, data_ram[word_addr][31:16]};
                end
                3'b010: rd_data_mem = data_ram[word_addr]; // LW
                3'b100: begin // LBU
                    case (wr_addr[1:0])
                        2'b00: rd_data_mem = {24'b0, data_ram[word_addr][7:0]};
                        2'b01: rd_data_mem = {24'b0, data_ram[word_addr][15:8]};
                        2'b10: rd_data_mem = {24'b0, data_ram[word_addr][23:16]};
                        2'b11: rd_data_mem = {24'b0, data_ram[word_addr][31:24]};
                        default: rd_data_mem = 32'bx;
                    endcase
                end
                3'b101: begin // LHU
                    if (wr_addr[1] == 1'b0)
                        rd_data_mem = {16'b0, data_ram[word_addr][15:0]};
                    else
                        rd_data_mem = {16'b0, data_ram[word_addr][31:16]};
                end
                default: rd_data_mem = 32'bx;
            endcase
        end else begin
            rd_data_mem = 32'bx;  // ← Output 'x' when not reading
        end
    end
endmodule