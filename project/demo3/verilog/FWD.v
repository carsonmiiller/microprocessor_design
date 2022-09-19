module FWD (
    output EX_MEM_A, MEM_WB_A, EX_MEM_B, MEM_WB_B,  // mux select enables
    input [2:0] EX_MEM_Rd, MEM_WB_Rd, ID_EX_Rs, ID_EX_Rt,
    input r_format, i_format, memWrite, regWrite_MEM, regWrite_WB
);

    assign MEM_WB_A = (ID_EX_Rs === MEM_WB_Rd) & (r_format | i_format) & regWrite_WB;
    assign MEM_WB_B = (ID_EX_Rt === MEM_WB_Rd) & (r_format | memWrite) & regWrite_WB;
    assign EX_MEM_A = (ID_EX_Rs === EX_MEM_Rd) & (r_format | i_format) & regWrite_MEM;
    assign EX_MEM_B = (ID_EX_Rt === EX_MEM_Rd) & (r_format | memWrite) & regWrite_MEM;
endmodule