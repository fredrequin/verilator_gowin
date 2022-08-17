`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DLNC primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DLNC
#(
    parameter INIT = 1'b0
)
(
    input  CLEAR,
    input  G,
    input  D,
    output Q
);

    reg _l_Q;

    initial begin
        _l_Q = INIT;
    end

    always @(CLEAR or G or D) begin
    
        if (CLEAR) begin
	        _l_Q = 1'b0;
        end
        else if (~G) begin
	        _l_Q = D;
        end
    end

    assign Q = _l_Q;

endmodule
