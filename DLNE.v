`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DLNE primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DLNE
#(
    parameter INIT = 1'b0
)
(
    input  G,
    input  CE,
    input  D,
    output Q
);

    reg _l_Q;

    initial begin
        _l_Q = INIT;
    end

    always @(G or CE or D) begin
    
        if (~G & CE) begin
	        _l_Q = D;
        end
    end

    assign Q = _l_Q;

endmodule
