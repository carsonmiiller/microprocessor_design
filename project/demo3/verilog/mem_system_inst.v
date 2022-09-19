/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system_inst(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input wire [15:0] Addr;
   input wire [15:0] DataIn;
   input wire        Rd;
   input wire        Wr;
   input wire        createdump;
   input wire        clk;
   input wire        rst;
   
   output reg [15:0] DataOut;
   output reg        Done;
   output reg        Stall;
   output reg        CacheHit;
   output reg        err;


   wire [4:0] tag_out_c0;
   wire [15:0] cache_data_out_c0, mem_data_out, mem_data_in, cache_data_in_c0, addr, allocate_addr_toCache;
   wire hit_c0, dirty_c0, valid_c0, stall, cache_err_c0, mem_err, wr, rd, comp_c0, write_c0, enable_c0;
   wire [4:0] tag_out_c1;
   wire [15:0] cache_data_out_c1, cache_data_in_c1;
   wire hit_c1, dirty_c1, valid_c1, cache_err_c1, comp_c1, write_c1, enable_c1;
   wire [3:0] busy;
   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out_c0),
                          .data_out             (cache_data_out_c0),
                          .hit                  (hit_c0),
                          .dirty                (dirty_c0),
                          .valid                (valid_c0),
                          .err                  (cache_err_c0),
                          // Inputs
                          .enable               (enable_c0),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (allocate_addr_toCache[15:11]),
                          .index                (allocate_addr_toCache[10:3]),
                          .offset               (allocate_addr_toCache[2:0]),
                          .data_in              (cache_data_in_c0),
                          .comp                 (comp_c0),
                          .write                (write_c0),
                          .valid_in             (~comp_c0 & write_c0)
   );
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_out_c1),
                          .data_out             (cache_data_out_c1),
                          .hit                  (hit_c1),
                          .dirty                (dirty_c1),
                          .valid                (valid_c1),
                          .err                  (cache_err_c1),
                          // Inputs
                          .enable               (enable_c1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (allocate_addr_toCache[15:11]),
                          .index                (allocate_addr_toCache[10:3]),
                          .offset               (allocate_addr_toCache[2:0]),
                          .data_in              (cache_data_in_c1),
                          .comp                 (comp_c1),
                          .write                (write_c1),
                          .valid_in             (~comp_c1 & write_c1)
   );
   four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (stall),
                     .busy              (busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (addr),
                     .data_in           (mem_data_in),
                     .wr                (wr),
                     .rd                (rd)
   );
   // your code here
   wire [15:0] DataOutFSM;
   wire DoneFSM, StallFSM, CacheHitFSM, errFSM;
   cacheFSM iCacheFSM(
      // outputs
      .addr(addr),
      .mem_data_in(mem_data_in),
      .wr(wr),
      .rd(rd),
      .cache_data_in_c0(cache_data_in_c0),
      .comp_c0(comp_c0),
      .write_c0(write_c0),
      .DataOut(DataOutFSM),
      .Done(DoneFSM),
      .Stall(StallFSM),
      .CacheHit(CacheHitFSM),
      .enable_c0(enable_c0),
      .err(errFSM),
      .allocate_addr_toCache(allocate_addr_toCache),
      .cache_data_in_c1(cache_data_in_c1),
      .comp_c1(comp_c1),
      .write_c1(write_c1),
      .enable_c1(enable_c1),
      // inputs
      .tag_out_c0(tag_out_c0),
      .cache_data_out_c0(cache_data_out_c0),
      .hit_c0(hit_c0),
      .dirty_c0(dirty_c0),
      .valid_c0(valid_c0),
      .cache_err_c0(cache_err_c0),
      .tag_out_c1(tag_out_c1),
      .cache_data_out_c1(cache_data_out_c1),
      .hit_c1(hit_c1),
      .dirty_c1(dirty_c1),
      .valid_c1(valid_c1),
      .cache_err_c1(cache_err_c1),
      .mem_data_out(mem_data_out),
      .stall(stall),
      .busy(busy),
      .mem_err(mem_err),
      .Addr(Addr),
      .DataIn(DataIn),
      .Rd(Rd),
      .Wr(Wr),
      .clk(clk),
      .rst(rst)
   );

   wire word_unaligned;
   assign word_unaligned = Addr[0];
   wire SYS_ERR;
   assign SYS_ERR = errFSM | word_unaligned;

   wire case_case;
   assign case_case = 1;
   always @(*) begin
      case(case_case)
         default: begin
            DataOut = DataOutFSM;
            Done = DoneFSM;
            Stall = StallFSM;
            CacheHit = CacheHitFSM;
            err = SYS_ERR;
         end
      endcase
   end
   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
