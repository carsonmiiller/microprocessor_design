/*
    CS/ECE 552 Spring '22
    Homework #2, Problem 2

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
module alu (branch, InA, InB, Cin, invA, invB, sign, Out, Zero, Ofl, add, x_or, and_, shift_rotate, left_right, btr, slbi, lbi, pos, neg, C_out);
    input [15:0] InA ; // Input operand A
    input [15:0] InB ; // Input operand B
    input Cin ; // Carry in
    input invA; // Signal to invert A
    input invB; // Signal to invert B
    input sign; // Signal for signed operation
	input add;
	input x_or;
	input and_;
	input shift_rotate; // 1 for shift, 0 for rotate
	input left_right; // 1 for left, 0 for right
	input btr;
	input slbi;
	input lbi;
	input branch;

    output [15:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0
	output pos, neg;
	output C_out;

    // creates ability to invert either data input before performing op
	wire [15:0] Achoice;
	wire [15:0] Bchoice;
	wire [15:0] shifted_or_not;
	assign shifted_or_not = slbi ? (InA << 8) : InA;
	assign Achoice = lbi ? 16'h0000 : (invA ? ~shifted_or_not : shifted_or_not);
	assign Bchoice = branch ? 16'h0000 : (invB ? ~InB : InB);

	// generates result of 4 shift/rotate ops
	wire [15:0]  shift_rotate_result;
	shifter iSHIFTER(
		.In(Achoice),
		.ShAmt(Bchoice[3:0]),
		.shift_rotate(shift_rotate),
		.left_right(left_right),
		.Out(shift_rotate_result)
	);

	// generates result of add/subtract op
	wire [15:0] cla_result;
	cla_16b iCLf16B(
		.S(cla_result),
		.C_out(cla_Cout),
		.A(Achoice),
		.B(Bchoice),
		.C_in(Cin),
		.err()
	);

	// assigning overflow for signed ops
	assign Ofl = (cla_result[15] & ~Achoice[15] & ~Bchoice[15]) | (~cla_result[15] & Achoice[15] & Bchoice[15]);
	assign C_out = cla_Cout;

	// generate result of AND op
	wire [15:0] and_result;
	assign and_result = Achoice & Bchoice;

	// generate result of XOR op
	wire [15:0] xor_result;
	assign xor_result = Achoice ^ Bchoice;
	
	// generate result of OR op
	wire [15:0] or_result;
	assign or_result = Achoice | Bchoice;

	wire[15:0] btr_result;
	assign btr_result = {Achoice[0], Achoice[1], Achoice[2], Achoice[3], Achoice[4], Achoice[5], Achoice[6], Achoice[7], Achoice[8], Achoice[9], Achoice[10], Achoice[11], Achoice[12], Achoice[13], Achoice[14], Achoice[15]};

	// CHOOSE CORRECT OUTPUT BASED ON CONTROL SIGNALS
	assign Out = (add | lbi) ? cla_result
					: (x_or ? xor_result
					: (and_ ? and_result
					: (btr ? btr_result
					: (slbi ? or_result
					: (shift_rotate_result)))));

	// generate Zero flag
	assign Zero = ~|Out;
	
	assign pos = (~cla_result[15] & |cla_result[14:0]) ? 1 : 0; 
	assign neg = (cla_result[15]) ? 1 : 0;


endmodule
