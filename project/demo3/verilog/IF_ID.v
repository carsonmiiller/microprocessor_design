`default_nettype none
module IF_ID (    
    input wire [15:0] inst_IF,
    input wire [15:0] PC_inc_IF,
    output wire [15:0] inst_ID,
    output wire [15:0] PC_inc_ID,

    input wire stall,
    input wire takeBranch,
    input wire inst_stall,

    // universal inputs
    input wire clk, rst
);

    wire [15:0] nop;
    wire [15:0] stalling;
    assign stalling = stall ? inst_ID : inst_IF;
    assign nop = (rst | takeBranch | (inst_stall & ~stall)) ? 16'h0800 : stalling;
    // inst reg
    register_16b inst(
        .Q(inst_ID),
        .D(nop),
        .en(1'b1),
        .clk(clk),
        .rst(1'b0)
    );
    // PC_inc reg
    register_16b PC_inc(
        .Q(PC_inc_ID),
        .D(PC_inc_IF),
        .en(~(stall | inst_stall)),
        .clk(clk),
        .rst(rst)
    );
endmodule
`default_nettype wire