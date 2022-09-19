/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (read_data, ALU_result, zero_ex_set, write_data, setOp, memToReg);

	output wire [15:0] write_data;
	input wire [15:0] zero_ex_set, read_data, ALU_result;
	input wire setOp;
	input wire memToReg;

	wire [15:0] usual_wb;
	assign usual_wb = memToReg ? read_data : ALU_result;
	
	assign write_data = setOp ? zero_ex_set : usual_wb;

endmodule
`default_nettype wire
