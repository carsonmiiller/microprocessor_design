module register (
	input clk,
	input rst,
	input en,
	input [15:0] D,
	output [15:0] Q);
	
	wire [15:0] D_en;

	assign D_en = en ? D : Q;
	dff b0(.q(Q[0]), .d(D_en[0]), .clk(clk), .rst(rst));
	dff b1(.q(Q[1]), .d(D_en[1]), .clk(clk), .rst(rst));
	dff b2(.q(Q[2]), .d(D_en[2]), .clk(clk), .rst(rst));
	dff b3(.q(Q[3]), .d(D_en[3]), .clk(clk), .rst(rst));
	dff b4(.q(Q[4]), .d(D_en[4]), .clk(clk), .rst(rst));
	dff b5(.q(Q[5]), .d(D_en[5]), .clk(clk), .rst(rst));
	dff b6(.q(Q[6]), .d(D_en[6]), .clk(clk), .rst(rst));
	dff b7(.q(Q[7]), .d(D_en[7]), .clk(clk), .rst(rst));
	dff b8(.q(Q[8]), .d(D_en[8]), .clk(clk), .rst(rst));
	dff b9(.q(Q[9]), .d(D_en[9]), .clk(clk), .rst(rst));
	dff b10(.q(Q[10]), .d(D_en[10]), .clk(clk), .rst(rst));
	dff b11(.q(Q[11]), .d(D_en[11]), .clk(clk), .rst(rst));
	dff b12(.q(Q[12]), .d(D_en[12]), .clk(clk), .rst(rst));
	dff b13(.q(Q[13]), .d(D_en[13]), .clk(clk), .rst(rst));
	dff b14(.q(Q[14]), .d(D_en[14]), .clk(clk), .rst(rst));
	dff b15(.q(Q[15]), .d(D_en[15]), .clk(clk), .rst(rst));
endmodule
