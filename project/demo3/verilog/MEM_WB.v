`default_nettype none
module MEM_WB (
    // outputs from MEM
    input wire [15:0] read_data_MEM,
    output wire [15:0] read_data_WB,
    // outputs from MEM

    // signals passed along that finally reach the end of the pipeline
    input wire [15:0] ALU_result_MEM,
    output wire [15:0] ALU_result_WB,
    input wire [15:0] zero_ex_set_MEM,
    output wire [15:0] zero_ex_set_WB,
    input wire setOp_MEM,
    output wire setOp_WB,
    input wire regWrite_MEM,
    output wire regWrite_WB, // will route back to ID stage to finish write
    input wire memToReg_MEM,
    output wire memToReg_WB,
    input wire [2:0] writeReg_MEM, Rs_MEM, Rt_MEM,
    output wire [2:0] writeReg_WB, Rs_WB, Rt_WB,
    input wire link_MEM,
    output wire link_WB,
    input wire [15:0] PC_inc_MEM,
    output wire [15:0] PC_inc_WB,
    input wire halt_MEM,
    output wire halt_WB,
    // signals passed along that finally reach the end of the pipeline

    input wire stall,
    // universal inputs
    input wire clk, rst
);

    register_16b read_data(
        .D(read_data_MEM),
        .Q(read_data_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    register_16b PC_inc(
        .D(PC_inc_MEM),
        .Q(PC_inc_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    register_16b ALU_result(
        .D(ALU_result_MEM),
        .Q(ALU_result_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    register_16b zero_ex_set(
        .D(zero_ex_set_MEM),
        .Q(zero_ex_set_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    register_3b writeReg(
        .Q(writeReg_WB),
        .D(writeReg_MEM),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    register_3b Rs(
        .Q(Rs_WB),
        .D(Rs_MEM),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    register_3b Rt(
        .Q(Rt_WB),
        .D(Rt_MEM),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    dff_en link(
        .D(link_MEM),
        .Q(link_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    dff_en halt(
        .D(halt_MEM),
        .Q(halt_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    dff_en setOp(
        .D(setOp_MEM),
        .Q(setOp_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    wire regWrite_stall;
    assign regWrite_stall = stall ? 1'b0 : regWrite_MEM;
    dff_en regWrite(
        .D(regWrite_stall),
        .Q(regWrite_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
    dff_en memToReg(
        .D(memToReg_MEM),
        .Q(memToReg_WB),
        .en(1'b1),
        .clk(clk),
        .rst(rst)
    );
endmodule
`default_nettype wire