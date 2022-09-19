/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (
   output wire [15:0] PC_inc,
   output wire [15:0] inst,
   output wire inst_stall,
   input wire [15:0] add_result,
   input wire clk, rst,
   input wire branch,
   input wire halt,
   input wire [15:0] jumpReg,
   input wire r,
   input wire stall
);

   wire [15:0] i;
   wire [15:0] PC_inc_internal;
   assign inst = i;
   assign PC_inc = PC_inc_internal;

   // Increment or Halt MUX
   wire [15:0] PC_inc_or_halt;
   wire [15:0] next_PC;
   assign PC_inc_or_halt = halt ? next_PC : PC_inc_internal;

   // branch_or_not MUX
   assign next_PC = branch ? add_result : PC_inc_or_halt;

   // select jumpReg_PC if Jump R inst
   wire [15:0] jumpReg_PC;
   assign jumpReg_PC = r ? jumpReg : next_PC;

   // program counter
   wire [15:0] pcCurrent;
   wire disablePC;
   assign disablePC = halt | (stall & ~branch & ~r);
   register program_current(
      .clk(clk),
      .rst(rst),
      .en(~disablePC),
      .D(jumpReg_PC),
      .Q(pcCurrent)
   );

   // PC_inc block
   cla_16b PC_inc_adder(
	   .A(pcCurrent),
	   .B(16'h0002),
	   .C_in(1'b0),
	   .S(PC_inc_internal),
	   .C_out(),
	   .err()
	);
   
   mem_system_inst instr(
		// Outputs
		.DataOut(i),
		.Done(),
		.Stall(inst_stall),
		.CacheHit(),
		.err(/* DO WE NEED ANYTHING HERE */),
		// Inputs
		.Addr(pcCurrent),
		.DataIn(),
		.Rd(1'b1),
		.Wr(1'b0),
		.createdump(1'b0),
		.clk(clk),
		.rst(rst)
   );
endmodule
`default_nettype wire