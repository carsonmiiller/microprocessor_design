/*
* 	CS/ECE 552 Spring '22
* 	Homework #2, Problem 1
*
	* Shift right submodule
	* Designed to shift a 16 bit operand either
	* logically or arithmetically to the right.
*/
module shift_rotate_right(in, amt, op, out);
	input [15:0] in; // input operand
	input [3:0] amt; // amount to shift
	input op; // if 1, then shift, if 0 then rotate
	output [15:0] out; // result of shift/rotate

	wire [15:0] mux1; // output of first set of muxes
	wire [15:0] mux2; // output of second set of muxes
	wire [15:0] mux3; // output of third set of muxes

	wire shift_in1;
	assign shift_in1 = op ? 1'b0 : in[0];
	assign mux1 = amt[0] ? {shift_in1, in[15:1]} : in; // shift right 1 bit

	wire [1:0] shift_in2;
	assign shift_in2 = op ? 2'b00 : mux1[1:0];
	assign mux2 = amt[1] ? {shift_in2, mux1[15:2]} : mux1; // shift right 2 bits

	wire [3:0] shift_in3;
	assign shift_in3 = op ? 4'h0 : mux2[3:0];
	assign mux3 = amt[2] ? {shift_in3, mux2[15:4]} : mux2; // shift right 4 bits

	wire [7:0] shift_in4;
	assign shift_in4 = op ? 8'h00 : mux3[7:0];
	assign out = amt[3] ? {shift_in4, mux3[15:8]} : mux3; // shift right 8 bits
endmodule
