module register_2b (
	input clk,
	input rst,
	input en,
	input [1:0] D,
	output [1:0] Q
);
	wire [1:0] D_en;
	assign D_en = en ? D : Q;

	dff b0(.q(Q[0]), .d(D_en[0]), .clk(clk), .rst(rst));
	dff b1(.q(Q[1]), .d(D_en[1]), .clk(clk), .rst(rst));
endmodule
