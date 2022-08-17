`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DFFN primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DFFN
#(
    parameter INIT = 1'b0
)
(
    input  CLK,
    input  D,
    output Q
);

    reg _r_Q;

    initial begin
        _r_Q = INIT;
    end

    always @(negedge CLK) begin
    
	    _r_Q <= D;
    end

    assign Q = _r_Q;

endmodule
