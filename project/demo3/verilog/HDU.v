`default_nettype none
module HDU (
    output wire stall,
    input wire [2:0] IF_ID_Rs,
    input wire [2:0] IF_ID_Rt,
    input wire [2:0] ID_EX_Rd,
    input wire r_format,
    input wire i_format,
    input wire memRead
);
    wire oneA, oneB, twoA, twoB;
    assign oneA = IF_ID_Rs === ID_EX_Rd;
    assign oneB = IF_ID_Rt === ID_EX_Rd;
    assign stall = memRead & ((oneA & (r_format | i_format)) | (oneB & r_format));
    
endmodule
`default_nettype wire