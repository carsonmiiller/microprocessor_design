`default_nettype none
module ID_EX (
    // so many control signals are delivered directly to the execute module,
    // don't I need to pass them through the IF_ID pipeline register, as well
    // to ensure the control signals arrive at the same time as the data?

    // EX inputs //
    output wire [15:0] read_data_1_EX,
	output wire [15:0] read_data_2_EX,
	output wire [15:0] sign_ex_J_EX,
	output wire [15:0] ALU_operand_ex_EX,
    output wire [15:0] PC_inc_EX,
	output wire operand2Mux_EX,
    output wire invA_EX,
	output wire invB_EX,
	output wire sign_EX,
	output wire add_EX,
	output wire x_or_EX,
	output wire and__EX,
	output wire shift_rotate_EX,
	output wire left_right_EX,
	output wire btr_EX,
	output wire cin_EX,
	output wire slbi_EX,
	output wire lbi_EX,
	output wire eq_EX,
	output wire lt_EX,
	output wire le_EX,
	output wire co_EX,
	output wire ge_EX,
	output wire ne_EX,
    output wire r_EX,
    output wire branch_EX,
    // EX inputs //

    // ID outputs //
    input wire [15:0] read_data_1_ID,
	input wire [15:0] read_data_2_ID,
	input wire [15:0] sign_ex_J_ID,
	input wire [15:0] ALU_operand_ex_ID,
    input wire [2:0] writeReg_ID, Rs_ID, Rt_ID,
    // ID outputs //
    
    // Control outputs //
    input wire branch_ID,
	input wire regWrite_ID,
    input wire operand2Mux_ID,
    input wire memRead_ID,
	input wire memWrite_ID,
	input wire memToReg_ID,
	input wire setOp_ID,
	input wire halt_ID,
	input wire invA_ID,
	input wire invB_ID,
	input wire sign_ID,
	input wire add_ID,
	input wire x_or_ID,
	input wire and__ID,
	input wire shift_rotate_ID,
	input wire left_right_ID,
	input wire btr_ID,
	input wire cin_ID,
	input wire slbi_ID,
	input wire lbi_ID,
	input wire eq_ID,
	input wire lt_ID,
	input wire le_ID,
	input wire co_ID,
	input wire ge_ID,
	input wire ne_ID,
	input wire r_ID,
    input wire link_ID,
    output wire link_EX,
    // Control outputs //

    // Control signals that need to be passed long to later stages //
	output wire regWrite_EX, // used in decode, but just like regDst must be passed along
	output wire memRead_EX, // pass along to MEM stage
	output wire memWrite_EX, // pass along to MEM stage
	output wire memToReg_EX, // pass along to WB stage
	output wire setOp_EX, // pass along to WB stage
	output wire halt_EX, // pass along to all stages
    output wire [2:0] writeReg_EX, Rs_EX, Rt_EX,
    // Control signals that need to be passed long //
    
    // IF outputs //
    input wire [15:0] PC_inc_ID,
	// IF outputs //


    input wire r_format_ID,
    output wire r_format_EX,
    input wire i_format_ID,
    output wire i_format_EX,
    input wire stall,
    input wire takeBranch,
    input wire mem_stall,
    // universal inputs //
    input wire clk, rst
);

    wire rst_flush;
    assign rst_flush = rst | takeBranch;

    wire [15:0] read_data_1_ID_stall;
    assign read_data_1_ID_stall = stall ? 16'h0000 : read_data_1_ID;
    // read_data_1 reg
    register_16b read_data_1(
        .Q(read_data_1_EX),
        .D(read_data_1_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    wire [15:0] read_data_2_ID_stall;
    assign read_data_2_ID_stall = stall ? 16'h0000 : read_data_2_ID;
    // read_data_2 reg
    register_16b read_data_2(
        .Q(read_data_2_EX),
        .D(read_data_2_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    // sign_ex_J reg
    register_16b sign_ex_J(
        .Q(sign_ex_J_EX),
        .D(sign_ex_J_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    // ALU_operand_ex reg
    register_16b ALU_operand_ex(
        .Q(ALU_operand_ex_EX),
        .D(ALU_operand_ex_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    // PC_inc reg
    register_16b PC_inc(
        .Q(PC_inc_EX),
        .D(PC_inc_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    register_3b writeReg(
        .Q(writeReg_EX),
        .D(writeReg_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    register_3b Rs(
        .Q(Rs_EX),
        .D(Rs_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    register_3b Rt(
        .Q(Rt_EX),
        .D(Rt_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en link(
        .Q(link_EX),
        .D(link_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en r_format(
        .Q(r_format_EX),
        .D(r_format_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en i_format(
        .Q(i_format_EX),
        .D(i_format_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en branch(
        .Q(branch_EX),
        .D(branch_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en regWrite(
        .Q(regWrite_EX),
        .D(regWrite_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en operand2Mux(
        .Q(operand2Mux_EX),
        .D(operand2Mux_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en memRead(
        .Q(memRead_EX),
        .D(memRead_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en memWrite(
        .Q(memWrite_EX),
        .D(memWrite_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | (stall & ~mem_stall))
    );
    dff_en memToReg(
        .Q(memToReg_EX),
        .D(memToReg_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en setOp(
        .Q(setOp_EX),
        .D(setOp_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en halt(
        .Q(halt_EX),
        .D(halt_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en invA(
        .Q(invA_EX),
        .D(invA_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en invB(
        .Q(invB_EX),
        .D(invB_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en sign(
        .Q(sign_EX),
        .D(sign_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en add(
        .Q(add_EX),
        .D(add_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en x_or(
        .Q(x_or_EX),
        .D(x_or_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en and_(
        .Q(and__EX),
        .D(and__ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en shift_rotate(
        .Q(shift_rotate_EX),
        .D(shift_rotate_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en left_right(
        .Q(left_right_EX),
        .D(left_right_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en btr(
        .Q(btr_EX),
        .D(btr_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en cin(
        .Q(cin_EX),
        .D(cin_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en slbi(
        .Q(slbi_EX),
        .D(slbi_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en lbi(
        .Q(lbi_EX),
        .D(lbi_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en eq(
        .Q(eq_EX),
        .D(eq_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en lt(
        .Q(lt_EX),
        .D(lt_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en le(
        .Q(le_EX),
        .D(le_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en co(
        .Q(co_EX),
        .D(co_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en ge(
        .Q(ge_EX),
        .D(ge_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en ne(
        .Q(ne_EX),
        .D(ne_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
    dff_en r(
        .Q(r_EX),
        .D(r_ID),
        .en(~mem_stall),
        .clk(clk),
        .rst(rst_flush | stall)
    );
endmodule
`default_nettype wire