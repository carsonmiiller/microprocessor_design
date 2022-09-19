module register_3b (
	input clk,
	input rst,
	input en,
	input [2:0] D,
	output [2:0] Q
);
	wire [2:0] D_en;
	assign D_en = en ? D : Q;

	dff b0(.q(Q[0]), .d(D_en[0]), .clk(clk), .rst(rst));
	dff b1(.q(Q[1]), .d(D_en[1]), .clk(clk), .rst(rst));
	dff b2(.q(Q[2]), .d(D_en[2]), .clk(clk), .rst(rst));
endmodule