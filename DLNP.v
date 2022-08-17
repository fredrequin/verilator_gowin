`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DLNP primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DLNP
#(
    parameter INIT = 1'b1
)
(
    input  PRESET,
    input  G,
    input  D,
    output Q
);

    reg _l_Q;

    initial begin
        _l_Q = INIT;
    end

    always @(PRESET or G or D) begin
    
        if (PRESET) begin
	        _l_Q = 1'b1;
        end
        else if (~G) begin
	        _l_Q = D;
        end
    end

    assign Q = _l_Q;

endmodule
