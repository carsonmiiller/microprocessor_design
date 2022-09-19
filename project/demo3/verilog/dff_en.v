`default_nettype none
module dff_en (
    output wire Q,
    input wire D,
    input wire en,
    input wire clk, rst
);
    wire D_en;
    assign D_en = en ? D : Q;
    dff dff1(
        .q(Q),
        .d(D_en),
        .clk(clk),
        .rst(rst)
    );
endmodule
`default_nettype wire