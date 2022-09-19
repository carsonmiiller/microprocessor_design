/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (
	
	input wire [15:0] sign_ex_J,
	input wire [15:0] PC_inc,
	input wire [15:0] read_data_1,
	input wire [15:0] read_data_2,
	input wire [15:0] ALU_operand_ex,
	input wire operand2Mux,
	input wire invA,
	input wire invB,
	input wire sign,
	input wire add,
	input wire x_or,
	input wire and_,
	input wire shift_rotate, // 1 for shift, 0 for rotate
	input wire left_right, // 1 for left, 0 for right
	input wire btr,
	input wire cin,
	input wire lbi,
	input wire slbi,
	input wire eq,
	input wire lt,
	input wire le,
	input wire co,
	input wire branch,
	input wire ge,
	input wire ne,
	input wire [15:0] EX_MEM_Data, MEM_WB_Data,
	input wire EX_MEM_A, MEM_WB_A, EX_MEM_B, MEM_WB_B,

	output wire [15:0] add_result,
	output wire [15:0] zero_ex_set,
	output wire [15:0] ALU_result,
	output wire takeBranch,
	output wire [15:0] st_value
);

	// handling which values will become operands in ALU
	wire [15:0] operand2, operand1_FWD_1, operand1_FWD_2, operand2_FWD_1, operand2_FWD_2, operand2_final;
	
	assign operand1_FWD_1 = MEM_WB_A ? MEM_WB_Data : read_data_1;
	assign operand1_FWD_2 = EX_MEM_A ? EX_MEM_Data : operand1_FWD_1;
	assign operand2_FWD_1 = MEM_WB_B ? MEM_WB_Data : read_data_2;
	assign operand2_FWD_2 = EX_MEM_B ? EX_MEM_Data : operand2_FWD_1;
	assign operand2 = operand2Mux ? operand2_FWD_2 : ALU_operand_ex;
	assign st_value = EX_MEM_B ? EX_MEM_Data :
						MEM_WB_B ? MEM_WB_Data :
						read_data_2;
	
	// wires to carry ALU specific output signals
	wire zero;
	wire overflow;
	wire pos, neg;
	wire C_out;

	wire diff_signs;
	assign diff_signs = operand1_FWD_2[15] ^ operand2[15];
	
	alu iALU(
		.InA(operand1_FWD_2),
		.InB(operand2),
		.Cin(cin),
		.invA(invA),
		.invB(invB),
		.sign(sign),
		.Out(ALU_result),
		.Zero(zero),
		.Ofl(overflow),
		.add(add),
		.x_or(x_or),
		.and_(and_),
		.shift_rotate(shift_rotate),
		.left_right(left_right),
		.btr(btr),
		.lbi(lbi),
		.slbi(slbi),
		.pos(pos),
		.neg(neg),
		.branch(branch),
		.C_out(C_out)
	);

	wire set;
	assign set = zero & eq ? 1 : 
				(pos & lt & ~diff_signs ? 1 : 
				(pos & lt & ~overflow & diff_signs ? 1 :
				(lt & neg & overflow ? 1 :
				(~neg & le & ~diff_signs ? 1 :
				(~neg & le & ~overflow & diff_signs ? 1 :
				(le & ~pos & overflow ? 1 :
				(co & C_out ? 1 : 0)))))));
	assign zero_ex_set = {15'h0000, set};
	
	// should we take the branch?
	assign takeBranch = branch & (/* branches */ ((eq & zero) | (ne & ~zero) | (lt & neg) | (ge & ~neg)) | /* jumps */ ~(eq | ne | lt | ge));
	
	// create branch displacement
	wire [15:0] branch_displacement;
	assign branch_displacement = takeBranch ? ALU_operand_ex : 16'h0000;

	// choose what displacement will be added to PC_inc
	wire [15:0] displacement;
	assign displacement = (eq | ne | lt | ge) ? branch_displacement : sign_ex_J;

	// add jump/branch displacement to PC_inc
	cla_16b jump_branch_adder(
		.A(displacement),
		.B(PC_inc),
		.C_in(1'b0),
		.S(add_result),
		.C_out(),
		.err()
	);

endmodule
`default_nettype wire
