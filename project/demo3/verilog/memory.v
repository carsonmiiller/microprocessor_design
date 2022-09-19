/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory(
	output wire [15:0] read_data,
	output wire mem_stall,
	input wire [15:0] addr,
	input wire [15:0] writeData,
	input wire clk, rst,
	input wire memRead,
	input wire memWrite,
	input wire halt
);

	wire enable;
	wire wr;
	
	wire memRead_temp, memWrite_temp;
	assign memRead_temp = memRead & ~halt;
	assign memWrite_temp = memWrite & ~halt;
	assign enable = (memRead_temp | memWrite_temp);

	mem_system_mem dMEM(
		// Outputs
		.DataOut(read_data),
		.Done(),
		.Stall(mem_stall),
		.CacheHit(),
		.err(),
		// Inputs
		.Addr(addr),
		.DataIn(writeData),
		.Rd(memRead_temp),
		.Wr(memWrite_temp),
		.createdump(halt),
		.clk(clk),
		.rst(rst)
   	);
   
endmodule
`default_nettype wire
