`default_nettype none
module EX_MEM (
    // MEM inputs //
    input wire [15:0] ALU_result_EX, // also an input to WB
    output wire [15:0] ALU_result_MEM,
    input wire [15:0] writeData_EX,
	output wire [15:0] writeData_MEM,
    input wire memRead_EX,
	output wire memRead_MEM,
    input wire memWrite_EX,
	output wire memWrite_MEM,
    input wire halt_EX,
	output wire halt_MEM,
    // MEM inputs //

    // signals passed from ID/EX pipe reg that still need to be passed on //
    input wire [15:0] zero_ex_set_EX,
    output wire [15:0] zero_ex_set_MEM, // generated in EX, pass along to WB
    input wire setOp_EX,
    output wire setOp_MEM, // pass along to WB
    input wire regWrite_EX,
    output wire regWrite_MEM, // pass along to WB, will then be passed to ID stage for final write of data
    input wire memToReg_EX,
    output wire memToReg_MEM, // pass along to WB
    input wire [2:0] writeReg_EX, Rs_EX, Rt_EX,
    output wire [2:0] writeReg_MEM, Rs_MEM, Rt_MEM, // pass along to WB, will then be passed to ID stage for final WB
    input wire link_EX,
    output wire link_MEM,
    input wire [15:0] PC_inc_EX,
    output wire [15:0] PC_inc_MEM,
    // signals passed from ID/EX pipe reg that still need to be passed on //

    input wire [15:0] st_value_EX,
    output wire [15:0] st_value_MEM,
    input wire stall,
    // universal inputs
    input wire clk, rst
);

    // got to do something if stalling in earlier cycles, otherwise, we are just rerunning the same instruction in the last 3 stages

    register_16b ALU_result(
        .D(ALU_result_EX),
        .Q(ALU_result_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    register_16b st_value(
        .D(st_value_EX),
        .Q(st_value_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    register_16b PC_inc(
        .D(PC_inc_EX),
        .Q(PC_inc_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    register_16b writeData(
        .D(writeData_EX),
        .Q(writeData_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    register_16b zero_ex_set(
        .D(zero_ex_set_EX),
        .Q(zero_ex_set_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    register_3b writeReg(
        .Q(writeReg_MEM),
        .D(writeReg_EX),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    register_3b Rt(
        .Q(Rt_MEM),
        .D(Rt_EX),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    register_3b Rs(
        .Q(Rs_MEM),
        .D(Rs_EX),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    dff_en link(
        .D(link_EX),
        .Q(link_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    dff_en memRead(
        .D(memRead_EX),
        .Q(memRead_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    dff_en memWrite(
        .D(memWrite_EX),
        .Q(memWrite_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    dff_en halt(
        .D(halt_EX),
        .Q(halt_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    dff_en setOp(
        .D(setOp_EX),
        .Q(setOp_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    dff_en regWrite(
        .D(regWrite_EX),
        .Q(regWrite_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
    dff_en memToReg(
        .D(memToReg_EX),
        .Q(memToReg_MEM),
        .en(~stall),
        .clk(clk),
        .rst(rst)
    );
endmodule
`default_nettype wire