/*
    CS/ECE 552 Spring '22
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, shift_rotate, left_right, Out);
	input  [15:0] In; // Input operand
	input  [3:0] ShAmt; // Amount to shift/rotate
	input  shift_rotate; // 1 for shift, 0 for rotate
	input  left_right; // 1 for left, 0 for right
	output [15:0] Out; // Result of shift/rotate

	wire [15:0] shift_rotate_right_out;
	wire [15:0] shift_rotate_left_out;
	
   	shift_rotate_right iSHIFT_RIGHT(
		.in(In),
		.amt(ShAmt),
		.op(shift_rotate),
		.out(shift_rotate_right_out)
	);

	shift_rotate_left iSHIFT_ROTATE_LEFT(
		.in(In),
		.amt(ShAmt),
		.op(shift_rotate),
		.out(shift_rotate_left_out)
	);

	assign Out = left_right ? shift_rotate_left_out : shift_rotate_right_out;
endmodule
