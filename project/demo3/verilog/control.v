/*
   CS/ECE 552 Spring '22
  
   Filename        : control.v
   Description     : This is the module for the overall control unit of the processor.
*/
`default_nettype none
module control(

	input wire [15:0] inst,
	output reg branch,
	output reg regWrite,
	output reg [1:0] regDst,
	output reg [1:0] ALU_operandExMux,
	output reg signExJMux,
	output reg operand2Mux,
	output reg memRead,
	output reg memWrite,
	output reg memToReg,
	output reg setOp,
	output reg halt,

	// control signals for ALU
	output reg invA,
	output reg invB,
	output reg sign,
	output reg add,
	output reg x_or,
	output reg and_,
	output reg shift_rotate, // 1 for shift, 0 for rotate
	output reg left_right, // 1 for left, 0 for right
	output reg btr, // signal to ALU for bit reverse
	output reg cin, // signal to ALU that Cin should be high
	output reg slbi, // signal to ALU for SLBI operation
	output reg lbi, // signal to ALU for LBI operation
	output reg eq, // signal to EX that inst is checking for equality of operands
	output reg lt, // signal to EX that inst is checking for less than inequality
	output reg le, // signal to EX that inst is checking for less than inequality or equality of operands (only used for SLE)
	output reg co, // signal to EX that says to set Rd to 1 if Cout is 1, and this signal is 1
	output reg ge, // signal to EX that inst is checking for greater than inequality of operands
	output reg ne, // signal to EX that inst is checking for inequality of operands
	output reg link, // signal that tells EX that inst is a link inst (must store PC + 2 in R7)
	output reg r, // signal that tells EX that base address for jump is stored in Rs
	output reg st,
	output reg r_format,
	output reg i_format
);
	
	always @(*) begin
		regDst = 2'b00;
		ALU_operandExMux = 2'b00;
		regWrite = 0;
		operand2Mux = 0;
		memRead = 0;
		memWrite = 0;
		memToReg = 0;
		setOp = 0;
		signExJMux = 0;
		branch = 0;
		halt = 0;
		invA = 0;
		invB = 0;
		sign = 0;
		add = 0;
		x_or = 0;
		and_ = 0;
		shift_rotate = 0;
		left_right = 0;
		btr = 0;
		cin = 0;
		slbi = 0;
		lbi = 0;
		eq = 0;
		lt = 0;
		le = 0;
		co = 0;
		ne = 0;
		ge = 0;
		link = 0;
		r = 0;
		st = 0;
		r_format = 0;
		i_format = 0;
		casex (inst[15:11])
			5'b00000 : begin // HALT
				regDst = 2'b01;
				halt = 1;
			end
			5'b00100 : begin // J
				branch = 1;
			end
			5'b00101 : begin // JR
				ALU_operandExMux = 2'b11;
				signExJMux = 1;
				add = 1;
				r = 1;
				i_format = 1;
			end
			5'b00110 : begin // JAL
				regWrite = 1;
				branch = 1;
				link = 1;
			end
			5'b00111 : begin // JALR
				ALU_operandExMux = 2'b11;
				regWrite = 1;
				signExJMux = 1;
				add = 1;
				link = 1;
				r = 1;
				i_format = 1;
			end
			5'b01000 : begin // ADDI
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				add = 1;
				i_format = 1;
			end
			5'b01001 : begin // SUBI
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				invA = 1;
				add = 1;
				cin = 1;
				i_format = 1;
			end
			5'b01010 : begin // XORI
				regDst = 2'b10;
				regWrite = 1;
				x_or = 1;
				i_format = 1;
			end
			5'b01011 : begin // ANDNI
				regDst = 2'b10;
				regWrite = 1;
				invB = 1;
				and_ = 1;
				i_format = 1;
			end
			5'b01100 : begin // BEQZ
				regDst = 2'b10;
				ALU_operandExMux = 2'b11;
				branch = 1;
				i_format = 1;
				eq = 1;
			end
			5'b01101 : begin // BNEZ
				regDst = 2'b10;
				ALU_operandExMux = 2'b11;
				branch = 1;
				ne = 1;
				i_format = 1;
			end
			5'b01110 : begin // BLTZ
				regDst = 2'b10;
				ALU_operandExMux = 2'b11;
				branch = 1;
				lt = 1;
				i_format = 1;
			end
			5'b01111 : begin // BGEZ
				regDst = 2'b10;
				ALU_operandExMux = 2'b11;
				branch = 1;
				ge = 1;
				i_format = 1;
			end
			5'b10000 : begin // ST
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				memWrite = 1;
				add = 1;
				st = 1;
				i_format = 1;
			end
			5'b10001 : begin // LD
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				memRead = 1;
				memToReg = 1;
				add = 1;
				i_format = 1;
			end
			5'b10010 : begin // SLBI
				regDst = 2'b11;
				ALU_operandExMux = 2'b01;
				regWrite = 1;
				slbi = 1;
				i_format = 1;
			end
			5'b10011 : begin // STU
				regDst = 2'b11;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				memWrite = 1;
				add = 1;
				st = 1;
				i_format = 1;
			end
			5'b10100 : begin // ROLI
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				left_right = 1;
				i_format = 1;
			end
			5'b10101 : begin // SLLI
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				shift_rotate = 1;
				left_right = 1;
				i_format = 1;
			end
			5'b10110 : begin // RORI
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				i_format = 1;
			end
			5'b10111 : begin // SRLI
				regDst = 2'b10;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				shift_rotate = 1;
				i_format = 1;
			end
			5'b11000 : begin // LBI
				regDst = 2'b11;
				ALU_operandExMux = 2'b11;
				regWrite = 1;
				lbi = 1;
				i_format = 1;
			end
			5'b11001 : begin // BTR
				regDst = 2'b01;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				btr = 1;
				r_format = 1;
			end
			5'b11010 : begin // ROL, SLL, ROR, SRL
				regDst = 2'b01;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				operand2Mux = 1;
				r_format = 1;
				case (inst[1:0])
					2'b00 : begin // ROL
						left_right = 1;
					end
					2'b01 : begin // SLL
						shift_rotate = 1;
						left_right = 1;
					end
					2'b11 : begin // SRL
						shift_rotate = 1;
					end
				endcase
			end
			5'b11011 : begin // ADD, SUB, XOR, ANDN
				regDst = 2'b01;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				operand2Mux = 1;
				r_format = 1;
				case (inst[1:0])
					2'b00 : begin // ADD
						add = 1;
					end
					2'b01 : begin // SUB
						invA = 1;
						sign = 1;
						add = 1;
						cin = 1;
					end
					2'b10 : begin // XOR
						x_or = 1;
					end
					2'b11 : begin // ANDN
						invB = 1;
						and_ = 1;
					end
				endcase
			end
			5'b11100 : begin // SEQ
				regDst = 2'b01;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				operand2Mux = 1;
				setOp = 1;
				invA = 1;
				add = 1;
				cin = 1;
				eq = 1;
				r_format = 1;
			end
			5'b11101 : begin // SLT
				regDst = 2'b01;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				operand2Mux = 1;
				setOp = 1;
				invA = 1;
				add = 1;
				cin = 1;
				lt = 1;
				r_format = 1;
			end
			5'b11110 : begin // SLE
				regDst = 2'b01;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				operand2Mux = 1;
				setOp = 1;
				invA = 1;
				add = 1;
				cin = 1;
				le = 1;
				r_format = 1;
			end
			5'b11111 : begin // SCO
				regDst = 2'b01;
				ALU_operandExMux = 2'b10;
				regWrite = 1;
				operand2Mux = 1;
				setOp = 1;
				add = 1;
				co = 1;
				r_format = 1;
			end
		endcase
	end
endmodule