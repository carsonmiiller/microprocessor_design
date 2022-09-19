/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (
	output wire [15:0] read_data_1,
	output wire [15:0] read_data_2,
	output wire [15:0] sign_ex_J,
	output wire [15:0] ALU_operand_ex,
	output wire err,
	output wire [2:0] writeReg,
	output wire [2:0] Rs,
	output wire [2:0] Rt,
	input wire [15:0] inst,
	input wire [15:0] w_D,
	input wire clk, rst,
	input wire [1:0] regDst,
	input wire [1:0] ALU_operandExMux,
	input wire signExJMux,
	input wire regWrite,
	input wire link,
	input wire [15:0] PC_inc_WB,
	input wire [2:0] writeReg_WB,
	input wire lbi,
	input wire memRead_ID,
	input wire memWrite_ID
);
	// wires to carry sign-/zero-extended immediates
	wire [15:0] sign_ex_11b;
	wire [15:0] sign_ex_8b;
	wire [15:0] sign_ex_5b;
	wire [15:0] zero_ex_8b;
	wire [15:0] zero_ex_5b;
	
	// assign extended immediates
	assign sign_ex_11b = {inst[10], inst[10], inst[10], inst[10], inst[10], inst[10:0]};
	assign sign_ex_8b = {inst[7], inst[7], inst[7], inst[7], inst[7], inst[7], inst[7], inst[7], inst[7:0]};
	assign sign_ex_5b = {inst[4], inst[4], inst[4], inst[4], inst[4], inst[4], inst[4], inst[4], inst[4], inst[4], inst[4], inst[4:0]};
	assign zero_ex_8b = {8'h00, inst[7:0]};
	assign zero_ex_5b = {11'h000, inst[4:0]};
	
	// assigning Rs and Rt
	assign Rs = ((&regDst) & lbi) ? 3'bxxx : inst[10:8];
	// regWrite & memWrite --> STU
	// assign Rt = (&regDst & ~(regWrite_ID & memWrite_ID)) ? 3'bxxx : inst[7:5];
	assign Rt = ((regDst == 2'b01) | memWrite_ID | memRead_ID) ? inst[7:5] : 3'bxxx;

	// 4-to-1 Mux for writeReg
	assign writeReg = regDst[1] ? (regDst[0] ? inst[10:8] : inst[7:5]) : (regDst[0] ? inst[4:2] : 3'b111);

	
	assign sign_ex_J = signExJMux ? sign_ex_8b : sign_ex_11b;
	assign ALU_operand_ex = ALU_operandExMux[1] ? (ALU_operandExMux[0] ? sign_ex_8b : sign_ex_5b) : (ALU_operandExMux[0] ? zero_ex_8b : zero_ex_5b);

	// mux to choose between PC_inc and w_D if JAL or JALR
	wire [15:0] writeData;
	assign writeData = link ? PC_inc_WB : w_D;
	// instantiation of RF -- added bypass capability
	regFile_bypass regFile0(
		.read1Data(read_data_1),
		.read2Data(read_data_2),
		.err(err),
		.clk(clk),
		.rst(rst),
		.read1RegSel(inst[10:8]),
		.read2RegSel(inst[7:5]),
		.writeRegSel(writeReg_WB),
		.writeData(writeData),
		.writeEn(regWrite)
	);

endmodule
`default_nettype wire
