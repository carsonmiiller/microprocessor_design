`default_nettype none
module cacheFSM(
	// outputs
	output reg [15:0] addr,
    output reg [15:0] mem_data_in,
    output reg wr,
    output reg rd,
    output reg [15:0] cache_data_in_c0,
    output reg comp_c0,
    output reg write_c0,
	output reg [15:0] DataOut,
	output reg Done,
	output reg Stall,
	output reg CacheHit,
	output reg enable_c0,
	output wire err,
	output reg [15:0] allocate_addr_toCache,
	output reg [15:0] cache_data_in_c1,
    output reg comp_c1,
    output reg write_c1,
	output reg enable_c1,
	// inputs
	input wire [4:0] tag_out_c0,
	input wire [15:0] cache_data_out_c0,
	input wire hit_c0,
	input wire dirty_c0,
	input wire valid_c0,
	input wire cache_err_c0,
	input wire [4:0] tag_out_c1,
	input wire [15:0] cache_data_out_c1,
	input wire hit_c1,
	input wire dirty_c1,
	input wire valid_c1,
	input wire cache_err_c1,
	input wire [15:0] mem_data_out,
	input wire stall,
	input wire [3:0] busy,
	input wire mem_err,
	input wire [15:0] Addr,
	input wire [15:0] DataIn,
	input wire Rd,
	input wire Wr,
	input wire clk,
	input wire rst
);
	parameter IDLE = 5'h00;
	parameter CmpRd = 5'h01;
	parameter CmpWr = 5'h02;
	parameter Rd0 = 5'h03;
	parameter Rd1 = 5'h04;
	parameter Rd2 = 5'h05;
	parameter Rd3 = 5'h06;
	parameter Rd4 = 5'h07;
	parameter Rd5 = 5'h08;
	parameter Wr0 = 5'h09;
	parameter Wr1 = 5'h0a;
	parameter Wr2 = 5'h0b;
	parameter Wr3 = 5'h0c;
	parameter RdDone = 5'h0d;
	parameter WrDone = 5'h0e;
	parameter OverWrite = 5'h0f;

	wire [4:0] state;
	reg [4:0] nxt_state;
	dff iDFF[4:0](
		.q(state),
		.d(nxt_state),
		.clk(clk),
		.rst(rst)
	);

	wire victimway;
	reg nxt_victimway;
	dff victimway0(
		.q(victimway),
		.d(nxt_victimway),
		.clk(clk),
		.rst(rst)
	);

	wire evictWay;
	reg nxt_evictWay;
	dff evictWay0(
		.q(evictWay),
		.d(nxt_evictWay),
		.clk(clk),
		.rst(rst)
	);

	assign err = cache_err_c0 | cache_err_c1 | mem_err;

	always @(*) begin
		// default SM outputs
		allocate_addr_toCache = Addr;
		addr = Addr;
		cache_data_in_c0 = 16'h0000;
		wr = 1'b0;
		rd = 1'b0;
		mem_data_in = 16'h0000;
		comp_c0 = 1'b0;
		write_c0 = 1'b0;
		allocate_addr_toCache = Addr;
		cache_data_in_c1 = 16'h0000;
		comp_c1 = 1'b0;
		write_c1 = 1'b0;
		DataOut = cache_data_out_c0;
		Done = 1'b0;
		Stall = 1'b1;
		CacheHit = 1'b0;
		// default nxt_state
		nxt_state = 5'h00;
		nxt_victimway = victimway;
		nxt_evictWay = evictWay;
		case(state)
			IDLE: begin
				nxt_state = Rd ? CmpRd :
									Wr ? CmpWr :
									IDLE;
				nxt_victimway = (Rd | Wr) ? ~victimway : victimway;
				Stall = (nxt_state == IDLE) ? 1'b0 : 1'b1;
			end
			CmpRd: begin
				comp_c0 = 1'b1;
				enable_c0 = 1'b1;
				comp_c1 = 1'b1;
				enable_c1 = 1'b1;
				CacheHit = ((hit_c0 & valid_c0) | (hit_c1 & valid_c1)) ? 1'b1 : 1'b0;
				DataOut = (hit_c0 & valid_c0) ? cache_data_out_c0 : cache_data_out_c1;
				Done = ((hit_c0 & valid_c0) | (hit_c1 & valid_c1)) ? 1'b1 : 1'b0;
				nxt_evictWay = (valid_c0 & ~valid_c1) ? 1'b1 :
							(~valid_c0 & valid_c1) ? 1'b0 :
							(~valid_c0 & ~valid_c1) ? 1'b0 :
							victimway;
				nxt_state = ((hit_c0 & valid_c0) | (hit_c1 & valid_c1)) ? IDLE :
									((~nxt_victimway & ~dirty_c0) | (nxt_victimway & ~dirty_c1)) ? Rd0 :
									Wr0;
				Stall = (nxt_state == IDLE) ? 1'b0 : 1'b1;
			end
			CmpWr: begin
				comp_c0 = 1'b1;
				write_c0 = 1'b1;
				write_c1 = 1'b1;
				enable_c0 = 1'b1;
				comp_c1 = 1'b1;
				enable_c1 = 1'b1;
				CacheHit = ((hit_c0 & valid_c0) | (hit_c1 & valid_c1)) ? 1'b1 : 1'b0;
				cache_data_in_c0 = (hit_c0 & valid_c0) ? DataIn : 16'h0000;
				cache_data_in_c1 = (hit_c1 & valid_c1) ? DataIn : 16'h0000;
				Done = ((hit_c0 & valid_c0) | (hit_c1 & valid_c1)) ? 1'b1 : 1'b0;
				nxt_evictWay = (valid_c0 & ~valid_c1) ? 1'b1 :
							(~valid_c0 & valid_c1) ? 1'b0 :
							(~valid_c0 & ~valid_c1) ? 1'b0 :
							victimway;
				nxt_state = ((hit_c0 & valid_c0) | (hit_c1 & valid_c1)) ? IDLE :
									((~evictWay & ~dirty_c0) | (evictWay & ~dirty_c1)) ? Rd0 :
									Wr0;
				Stall = (nxt_state == IDLE) ? 1'b0 : 1'b1;
			end
			Rd0: begin
				rd = 1'b1;
				addr[2:1] = 2'b00;
				nxt_state = Rd1;
			end
			Rd1: begin
				rd = 1'b1;
				addr[2:1] = 2'b01;
				nxt_state = Rd2;
			end
			Rd2: begin
				rd = 1'b1;
				addr[2:1] = 2'b10;
				write_c0 = evictWay ? 1'b0 : 1'b1;
				write_c1 = evictWay ? 1'b1 : 1'b0;
				allocate_addr_toCache[2:1] = 2'b00;
				cache_data_in_c0 = mem_data_out;
				cache_data_in_c1 = mem_data_out;
				nxt_state = Rd3;
			end
			Rd3: begin
				rd = 1'b1;
				addr[2:1] = 2'b11;
				write_c0 = evictWay ? 1'b0 : 1'b1;
				write_c1 = evictWay ? 1'b1 : 1'b0;
				allocate_addr_toCache[2:1] = 2'b01;
				cache_data_in_c0 = mem_data_out;
				cache_data_in_c1 = mem_data_out;
				nxt_state = Rd4;
			end
			Rd4: begin
				write_c0 = evictWay ? 1'b0 : 1'b1;
				write_c1 = evictWay ? 1'b1 : 1'b0;
				cache_data_in_c0 = mem_data_out;
				cache_data_in_c1 = mem_data_out;
				allocate_addr_toCache[2:1] = 2'b10;
				nxt_state = Rd5;
			end
			Rd5: begin
				write_c0 = evictWay ? 1'b0 : 1'b1;
				write_c1 = evictWay ? 1'b1 : 1'b0;
				cache_data_in_c0 = mem_data_out;
				cache_data_in_c1 = mem_data_out;
				allocate_addr_toCache[2:1] = 2'b11;
				nxt_state = Rd ? RdDone :
							Wr ? OverWrite :
							IDLE;
				Stall = (nxt_state == IDLE) ? 1'b0 : 1'b1;
			end
			RdDone: begin
				Done = 1'b1;
				DataOut = evictWay ? cache_data_out_c1 : cache_data_out_c0;
				nxt_state = IDLE;
				Stall = 1'b0;
			end
			Wr0: begin
				wr = 1'b1;
				allocate_addr_toCache[2:1] = 2'b00;
				addr[15:11] = evictWay ? tag_out_c1 : tag_out_c0;
				addr[2:1] = 2'b00;
				mem_data_in = evictWay ? cache_data_out_c1 : cache_data_out_c0;
				nxt_state = Wr1;
			end
			Wr1: begin
				wr = 1'b1;
				allocate_addr_toCache[2:1] = 2'b01;
				addr[15:11] = evictWay ? tag_out_c1 : tag_out_c0;
				addr[2:1] = 2'b01;
				mem_data_in = evictWay ? cache_data_out_c1 : cache_data_out_c0;
				nxt_state = Wr2;
			end
			Wr2: begin
				wr = 1'b1;
				allocate_addr_toCache[2:1] = 2'b10;
				addr[15:11] = evictWay ? tag_out_c1 : tag_out_c0;
				addr[2:1] = 2'b10;
				mem_data_in = evictWay ? cache_data_out_c1 : cache_data_out_c0;
				nxt_state = Wr3;
			end
			Wr3: begin
				wr = 1'b1;
				allocate_addr_toCache[2:1] = 2'b11;
				addr[15:11] = evictWay ? tag_out_c1 : tag_out_c0;
				addr[2:1] = 2'b11;
				mem_data_in = evictWay ? cache_data_out_c1 : cache_data_out_c0;
				nxt_state = Rd0;
			end
			OverWrite: begin
				cache_data_in_c0 = DataIn;
				cache_data_in_c1 = DataIn;
				write_c0 = evictWay ? 1'b0 : 1'b1;
				write_c1 = evictWay ? 1'b1 : 1'b0;
				comp_c0 = evictWay ? 1'b0 : 1'b1;
				comp_c1 = evictWay ? 1'b1 : 1'b0;
				nxt_state = WrDone;
			end
			WrDone: begin
				Done = 1'b1;
				nxt_state = IDLE;
				Stall = 1'b0;
			end
		endcase
	end
endmodule
`default_nettype wire