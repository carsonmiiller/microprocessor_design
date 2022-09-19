/*
   CS/ECE 552, Spring '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );
	parameter BITWIDTH = 16;

   	input        clk, rst;
   	input [2:0]  read1RegSel;
   	input [2:0]  read2RegSel;
   	input [2:0]  writeRegSel;
   	input [BITWIDTH-1:0] writeData;
   	input        writeEn;

	output [BITWIDTH-1:0] read1Data;
   	output [BITWIDTH-1:0] read2Data;
   	output        err;
	
	// write port wires
	wire [BITWIDTH-1:0] reg0write;
	wire [BITWIDTH-1:0] reg1write;
	wire [BITWIDTH-1:0] reg2write;
	wire [BITWIDTH-1:0] reg3write;
	wire [BITWIDTH-1:0] reg4write;
	wire [BITWIDTH-1:0] reg5write;
	wire [BITWIDTH-1:0] reg6write;
	wire [BITWIDTH-1:0] reg7write;
	// read port wires	
	wire [BITWIDTH-1:0] reg0read;
	wire [BITWIDTH-1:0] reg1read;
	wire [BITWIDTH-1:0] reg2read;
	wire [BITWIDTH-1:0] reg3read;
	wire [BITWIDTH-1:0] reg4read;
	wire [BITWIDTH-1:0] reg5read;
	wire [BITWIDTH-1:0] reg6read;
	wire [BITWIDTH-1:0] reg7read;
	// write port enables
	wire reg0writeEn;
	wire reg1writeEn;
	wire reg2writeEn;
	wire reg3writeEn;
	wire reg4writeEn;
	wire reg5writeEn;
	wire reg6writeEn;
	wire reg7writeEn;
	assign reg0writeEn = (~writeRegSel[2] & ~writeRegSel[1] & ~writeRegSel[0]) & writeEn;
	assign reg1writeEn = (~writeRegSel[2] & ~writeRegSel[1] & writeRegSel[0]) & writeEn;
	assign reg2writeEn = (~writeRegSel[2] & writeRegSel[1] & ~writeRegSel[0]) & writeEn;
	assign reg3writeEn = (~writeRegSel[2] & writeRegSel[1] & writeRegSel[0]) & writeEn;
	assign reg4writeEn = (writeRegSel[2] & ~writeRegSel[1] & ~writeRegSel[0]) & writeEn;
	assign reg5writeEn = (writeRegSel[2] & ~writeRegSel[1] & writeRegSel[0]) & writeEn;
	assign reg6writeEn = (writeRegSel[2] & writeRegSel[1] & ~writeRegSel[0]) & writeEn;
	assign reg7writeEn = (writeRegSel[2] & writeRegSel[1] & writeRegSel[0]) & writeEn;
	// instantiation of 8 registers
	register reg0(.clk(clk), .rst(rst), .en(reg0writeEn), .D(writeData), .Q(reg0read));
	register reg1(.clk(clk), .rst(rst), .en(reg1writeEn), .D(writeData), .Q(reg1read));
	register reg2(.clk(clk), .rst(rst), .en(reg2writeEn), .D(writeData), .Q(reg2read));
	register reg3(.clk(clk), .rst(rst), .en(reg3writeEn), .D(writeData), .Q(reg3read));
	register reg4(.clk(clk), .rst(rst), .en(reg4writeEn), .D(writeData), .Q(reg4read));
	register reg5(.clk(clk), .rst(rst), .en(reg5writeEn), .D(writeData), .Q(reg5read));
	register reg6(.clk(clk), .rst(rst), .en(reg6writeEn), .D(writeData), .Q(reg6read));
	register reg7(.clk(clk), .rst(rst), .en(reg7writeEn), .D(writeData), .Q(reg7read));

	// read ports
	assign read1Data = read1RegSel == 3'b000 ? reg0read :
				read1RegSel == 3'b001 ? reg1read :
				read1RegSel == 3'b010 ? reg2read :
				read1RegSel == 3'b011 ? reg3read :
				read1RegSel == 3'b100 ? reg4read :
				read1RegSel == 3'b101 ? reg5read :
				read1RegSel == 3'b110 ? reg6read :
				reg7read;

	assign read2Data = read2RegSel == 3'b000 ? reg0read :
				read2RegSel == 3'b001 ? reg1read :
				read2RegSel == 3'b010 ? reg2read :
				read2RegSel == 3'b011 ? reg3read :
				read2RegSel == 3'b100 ? reg4read :
				read2RegSel == 3'b101 ? reg5read :
				read2RegSel == 3'b110 ? reg6read :
				reg7read;

	assign err = ((&writeData == 1'bx) | (|writeData == 1'bx) | (^writeData == 1'bx) | (writeEn == 1'bx) | (writeEn == 1'bz)) ? 1 : 0;
endmodule
