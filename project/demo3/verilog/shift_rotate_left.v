/*
* 	CS/ECE 552 Spring '22
* 	Homework #2, Problem 1
*
	* Shift/rotate left submodule
	* Designed to shift or rotate a 16 bit operand
	* to the left.
*/
module shift_rotate_left(in, amt, op, out);
	input [15:0] in; // input operand
	input [3:0] amt; // amount to shift/rotate
	input op; // 1 for shift, 0 for rotate
	output [15:0]out; // result of shift/result

	wire [15:0] mux1; // output of first set of muxes
	wire [15:0] mux2; // output of second set of muxes
	wire [15:0] mux3; // output of third set of muxes

	assign mux1 = amt[0] ? (op ? {in[14:0], 1'b0} : {in[14:0], in[15]}) : in; // shift/rotate left 1 bit
	assign mux2 = amt[1] ? (op ? {mux1[13:0], 2'b0} : {mux1[13:0], mux1[15:14]}) : mux1; // shift/rotate left 2 bits
	assign mux3 = amt[2] ? (op ? {mux2[11:0], 4'h0} : {mux2[11:0], mux2[15:12]}) : mux2; // shift/rotate left 4 bits
	assign out = amt[3] ? (op ? {mux3[7:0], 8'h00} : {mux3[7:0], mux3[15:8]}) : mux3; // shift/rotate left 8 bits
endmodule
