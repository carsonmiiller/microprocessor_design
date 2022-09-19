/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
    // Outputs
    err, 
    // Inputs
    clk, rst
    );

    input wire clk;
    input wire rst;

    output reg err;

    // None of the above lines can be modified

    // OR all the err ouputs for every sub-module and assign it as this
    // err output
    
    // As desribed in the homeworks, use the err signal to trap corner
    // cases that you think are illegal in your statemachines
   
   
    // your code here -- should include instantiations of fetch, decode, execute, mem
   	
	// wires for connection... yikes
	
	wire [15:0] inst_IF, PC_inc_IF, inst_ID, PC_inc_ID, read_data_1_EX, read_data_2_EX, sign_ex_J_EX, ALU_operand_ex_EX, PC_inc_EX;
	wire [15:0] read_data_1_ID, read_data_2_ID, sign_ex_J_ID, ALU_operand_ex_ID, ALU_result_EX, ALU_result_MEM;
	wire [15:0] writeData_MEM, zero_ex_set_EX, zero_ex_set_MEM, read_data_MEM, read_data_WB, ALU_result_WB, zero_ex_set_WB;
	wire [15:0] add_result_EX, write_data_WB, PC_inc_MEM, PC_inc_WB, st_value_EX, st_value_MEM;
	wire [2:0] writeReg_ID, writeReg_EX, writeReg_MEM, writeReg_WB;

	// HDU signals...
	wire [2:0] ID_EX_Rs, ID_EX_Rt, Rs, Rt, Rs_ID, Rt_ID, Rs_EX, Rt_EX, Rs_MEM, Rt_MEM, Rs_WB, Rt_WB;
    wire stall, takeBranch;

	wire [1:0] regDst_ID, ALU_operandExMux_ID;

    wire operand2Mux_EX, invA_EX, invB_EX, sign_EX, add_EX, x_or_EX, and__EX, shift_rotate_EX, left_right_EX;
	wire btr_EX, cin_EX, slbi_EX, lbi_EX, eq_EX, lt_EX, le_EX, co_EX, ge_EX, ne_EX, r_EX, branch_EX, branch_ID, regWrite_ID;
	wire operand2Mux_ID, memRead_ID, memWrite_ID, memToReg_ID,	setOp_ID, halt_ID, invA_ID, invB_ID, sign_ID, add_ID;
	wire x_or_ID, and__ID, shift_rotate_ID, left_right_ID,	btr_ID, cin_ID, slbi_ID, lbi_ID, eq_ID, lt_ID, le_ID, co_ID, ge_ID, ne_ID;
	wire r_ID, regWrite_EX, memRead_EX, memWrite_EX, memToReg_EX, setOp_EX, halt_EX, memRead_MEM, memWrite_MEM, halt_MEM, setOp_MEM;
	wire regWrite_MEM, memToReg_MEM, setOp_WB, regWrite_WB, memToReg_WB, signExJMux_ID, link_ID, link_EX, link_MEM, link_WB, halt_WB;
	wire mem_stall, inst_stall, EX_MEM_A, MEM_WB_A, EX_MEM_B, MEM_WB_B, EX_MEM_Rd, MEM_WB_Rd, st, st_EX, st_MEM, r_format, i_format;
	wire r_format_EX, i_format_EX;

	// IF Instantiation
	fetch fetch0(
		// outputs
		.inst(inst_IF),
		.PC_inc(PC_inc_IF),
		.inst_stall(inst_stall),
		// inputs
		.clk(clk),
		.rst(rst),
	   	.add_result(add_result_EX),
	   	.branch(takeBranch),
	   	.halt(halt_WB),
		.jumpReg(ALU_result_EX),
		.r(r_EX),
		.stall(stall | mem_stall | inst_stall)
	);

	// IF/ID Pipeline Register
	IF_ID IF_ID_pipe_reg(
		// outputs
		.inst_ID(inst_ID),
		.PC_inc_ID(PC_inc_ID),
		// inputs
		.inst_IF(inst_IF),
		.PC_inc_IF(PC_inc_IF),
		.stall(stall | mem_stall),
		.inst_stall(inst_stall),
		.takeBranch(takeBranch | r_EX),
		.clk(clk),
		.rst(rst)
	);
	
	// Control Instantiation
   	control iGOD(
		// outputs
		.branch(branch_ID),
   		.regWrite(regWrite_ID),
   		.regDst(regDst_ID),
   		.ALU_operandExMux(ALU_operandExMux_ID),
   		.signExJMux(signExJMux_ID),
   		.operand2Mux(operand2Mux_ID),
   		.memRead(memRead_ID),
   		.memWrite(memWrite_ID),
   		.memToReg(memToReg_ID),
   		.setOp(setOp_ID),
   		.halt(halt_ID),
		.invA(invA_ID),
		.invB(invB_ID),
		.sign(sign_ID),
		.add(add_ID),
		.x_or(x_or_ID),
		.and_(and__ID),
		.shift_rotate(shift_rotate_ID),
		.left_right(left_right_ID),
		.btr(btr_ID),
		.cin(cin_ID),
		.slbi(slbi_ID),
		.lbi(lbi_ID),
		.eq(eq_ID),
		.lt(lt_ID),
		.le(le_ID),
		.co(co_ID),
		.ge(ge_ID),
		.ne(ne_ID),
		.link(link_ID),
		.r(r_ID),
		.st(st),
		.r_format(r_format),
		.i_format(i_format),
		// input
   		.inst(inst_ID)
   	);

	// ID Instantiation
	decode decode0(
		// outputs
		.read_data_1(read_data_1_ID),
		.read_data_2(read_data_2_ID),
		.sign_ex_J(sign_ex_J_ID),
		.ALU_operand_ex(ALU_operand_ex_ID),
		.writeReg(writeReg_ID),
		.Rs(Rs_ID),
		.Rt(Rt_ID),
		// inputs
		.inst(inst_ID),
		.PC_inc_WB(PC_inc_WB),
		.w_D(write_data_WB),
		.regDst(regDst_ID),
		.ALU_operandExMux(ALU_operandExMux_ID),
		.signExJMux(signExJMux_ID),
		.regWrite(regWrite_WB),
		.err(),
		.link(link_WB),
		.writeReg_WB(writeReg_WB),
		.lbi(lbi_ID),
		.memRead_ID(memRead_ID),
		.memWrite_ID(memWrite_ID),
		.clk(clk),
		.rst(rst)
	);
	
	// Hazard Detection Unit
	HDU Uh_Oh(
		// output
		.stall(stall),
		// inputs
		.IF_ID_Rs(Rs_ID),
    	.IF_ID_Rt(Rt_ID),
    	.ID_EX_Rd(writeReg_EX),
		.r_format(r_format),
		.i_format(i_format),
		.memRead(memRead_EX)
	);

	// ID/EX Pipeline Register
	ID_EX ID_EX_pipe_reg(
		// outputs
		.read_data_1_EX(read_data_1_EX),
		.read_data_2_EX(read_data_2_EX),
		.sign_ex_J_EX(sign_ex_J_EX),
		.ALU_operand_ex_EX(ALU_operand_ex_EX),
		.PC_inc_EX(PC_inc_EX),
		.operand2Mux_EX(operand2Mux_EX),
		.invA_EX(invA_EX),
		.invB_EX(invB_EX),
		.sign_EX(sign_EX),
		.add_EX(add_EX),
		.x_or_EX(x_or_EX),
		.and__EX(and__EX),
		.shift_rotate_EX(shift_rotate_EX),
		.left_right_EX(left_right_EX),
		.btr_EX(btr_EX),
		.cin_EX(cin_EX),
		.slbi_EX(slbi_EX),
		.lbi_EX(lbi_EX),
		.eq_EX(eq_EX),
		.lt_EX(lt_EX),
		.le_EX(le_EX),
		.co_EX(co_EX),
		.ge_EX(ge_EX),
		.ne_EX(ne_EX),
		.branch_EX(branch_EX),
		.regWrite_EX(regWrite_EX),
		.memRead_EX(memRead_EX),
		.memWrite_EX(memWrite_EX),
		.memToReg_EX(memToReg_EX),
		.setOp_EX(setOp_EX), 
		.halt_EX(halt_EX),
		.r_EX(r_EX),
		.writeReg_EX(writeReg_EX),
		.link_EX(link_EX),
		.Rs_EX(Rs_EX),
		.Rt_EX(Rt_EX),
		.r_format_EX(r_format_EX),
		.i_format_EX(i_format_EX),
		// inputs
		.read_data_1_ID(read_data_1_ID),
		.read_data_2_ID(read_data_2_ID),
		.sign_ex_J_ID(sign_ex_J_ID),
		.ALU_operand_ex_ID(ALU_operand_ex_ID),
		.branch_ID(branch_ID),
		.regWrite_ID(regWrite_ID),
		.operand2Mux_ID(operand2Mux_ID),
		.memRead_ID(memRead_ID),
		.memWrite_ID(memWrite_ID),
		.memToReg_ID(memToReg_ID),
		.setOp_ID(setOp_ID),
		.halt_ID(halt_ID),
		.invA_ID(invA_ID),
		.invB_ID(invB_ID),
		.sign_ID(sign_ID),
		.add_ID(add_ID),
		.x_or_ID(x_or_ID),
		.and__ID(and__ID),
		.shift_rotate_ID(shift_rotate_ID),
		.left_right_ID(left_right_ID),
		.btr_ID(btr_ID),
		.cin_ID(cin_ID),
		.slbi_ID(slbi_ID),
		.lbi_ID(lbi_ID),
		.eq_ID(eq_ID),
		.lt_ID(lt_ID),
		.le_ID(le_ID),
		.co_ID(co_ID),
		.ge_ID(ge_ID),
		.ne_ID(ne_ID),
		.r_ID(r_ID),
		.PC_inc_ID(PC_inc_ID),
		.writeReg_ID(writeReg_ID),
		.link_ID(link_ID),
		.stall(stall),
		.mem_stall(mem_stall),
		.takeBranch(takeBranch | r_EX),
		.Rs_ID(Rs_ID),
		.Rt_ID(Rt_ID),
		.r_format_ID(r_format),
		.i_format_ID(i_format),
    	.clk(clk),
		.rst(rst)
	);

	// EX Instantiation
	execute execute0(
		// outputs
		.add_result(add_result_EX),
		.zero_ex_set(zero_ex_set_EX),
		.ALU_result(ALU_result_EX),
		.takeBranch(takeBranch),
		.st_value(st_value_EX),
		// inputs
		.sign_ex_J(sign_ex_J_EX),
		.PC_inc(PC_inc_EX),
		.read_data_1(read_data_1_EX),
		.read_data_2(read_data_2_EX),
		.ALU_operand_ex(ALU_operand_ex_EX),
		.operand2Mux(operand2Mux_EX),
		.invA(invA_EX),
		.invB(invB_EX),
		.sign(sign_EX),
		.add(add_EX),
		.x_or(x_or_EX),
		.and_(and__EX),
		.shift_rotate(shift_rotate_EX),
		.left_right(left_right_EX),
		.btr(btr_EX),
		.cin(cin_EX),
		.slbi(slbi_EX),
		.lbi(lbi_EX),
		.eq(eq_EX),
		.lt(lt_EX),
		.le(le_EX),
		.co(co_EX),
		.ge(ge_EX),
		.ne(ne_EX),
		.branch(branch_EX),
		.EX_MEM_A(EX_MEM_A),
		.EX_MEM_B(EX_MEM_B),
		.MEM_WB_A(MEM_WB_A),
		.MEM_WB_B(MEM_WB_B),
		.EX_MEM_Data(ALU_result_MEM),
		.MEM_WB_Data(write_data_WB)
	);

	// EX/MEM Pipeline Register
	EX_MEM EX_MEM_pipe_reg(
		// outputs
		.ALU_result_MEM(ALU_result_MEM),
		.writeData_MEM(writeData_MEM),
		.zero_ex_set_MEM(zero_ex_set_MEM),
		.memRead_MEM(memRead_MEM),
		.memWrite_MEM(memWrite_MEM),
		.halt_MEM(halt_MEM),
		.setOp_MEM(setOp_MEM),
		.regWrite_MEM(regWrite_MEM),
		.memToReg_MEM(memToReg_MEM),
		.writeReg_MEM(writeReg_MEM),
		.link_MEM(link_MEM),
		.PC_inc_MEM(PC_inc_MEM),
		.Rs_MEM(Rs_MEM),
		.Rt_MEM(Rt_MEM),
		.st_value_MEM(st_value_MEM),
		// inputs
		.ALU_result_EX(ALU_result_EX),
		.writeData_EX(read_data_2_EX),
		.zero_ex_set_EX(zero_ex_set_EX),
		.memRead_EX(memRead_EX),
		.memWrite_EX(memWrite_EX),
		.halt_EX(halt_EX),
		.setOp_EX(setOp_EX),
		.regWrite_EX(regWrite_EX),
		.memToReg_EX(memToReg_EX),
		.writeReg_EX(writeReg_EX),
		.link_EX(link_EX),
		.PC_inc_EX(PC_inc_EX),
		.Rs_EX(Rs_EX),
		.Rt_EX(Rt_EX),
		.stall(mem_stall),
		.st_value_EX(st_value_EX),
		.clk(clk),
		.rst(rst)
	);

	FWD iFWD(
		// outputs
		.EX_MEM_A(EX_MEM_A),
		.MEM_WB_A(MEM_WB_A),
		.EX_MEM_B(EX_MEM_B),
		.MEM_WB_B(MEM_WB_B),
		// inputs
		.EX_MEM_Rd(writeReg_MEM),
		.MEM_WB_Rd(writeReg_WB),
		.ID_EX_Rs(Rs_EX),
		.ID_EX_Rt(Rt_EX),
		.r_format(r_format_EX),
		.i_format(i_format_EX),
		.memWrite(memWrite_EX),
		.regWrite_MEM(regWrite_MEM),
		.regWrite_WB(regWrite_WB)
	);
	
	// MEM Instantiation
	memory memory0(
		// output
		.read_data(read_data_MEM),
		.mem_stall(mem_stall),
		// inputs
		.addr(ALU_result_MEM),
		.writeData(st_value_MEM),
		.memRead(memRead_MEM),
		.memWrite(memWrite_MEM),
		.halt(halt_WB),
		.clk(clk),
		.rst(rst)
	);
	
	// MEM/WB Pipeline Register
	MEM_WB MEM_WB_pipe_reg(
		// outputs
		.read_data_WB(read_data_WB),
		.ALU_result_WB(ALU_result_WB),
		.zero_ex_set_WB(zero_ex_set_WB),
		.setOp_WB(setOp_WB),
		.regWrite_WB(regWrite_WB),
		.memToReg_WB(memToReg_WB),
		.writeReg_WB(writeReg_WB),
		.link_WB(link_WB),
		.PC_inc_WB(PC_inc_WB),
		.halt_WB(halt_WB),
		.Rs_WB(Rs_WB),
		.Rt_WB(Rt_WB),
		// inputs
		.read_data_MEM(read_data_MEM),
		.ALU_result_MEM(ALU_result_MEM),
		.zero_ex_set_MEM(zero_ex_set_MEM),
		.setOp_MEM(setOp_MEM),
		.regWrite_MEM(regWrite_MEM),
		.memToReg_MEM(memToReg_MEM),
		.writeReg_MEM(writeReg_MEM),
		.link_MEM(link_MEM),
		.PC_inc_MEM(PC_inc_MEM),
		.halt_MEM(halt_MEM),
		.Rs_MEM(Rs_MEM),
		.Rt_MEM(Rt_MEM),
		.stall(mem_stall),
		.clk(clk),
		.rst(rst)
	);

	// WB Instantiation
	wb wb0(
		// output
		.write_data(write_data_WB),
		// inputs
		.read_data(read_data_WB),
		.ALU_result(ALU_result_WB),
		.zero_ex_set(zero_ex_set_WB),
		.setOp(setOp_WB),
		.memToReg(memToReg_WB)
	);
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0: