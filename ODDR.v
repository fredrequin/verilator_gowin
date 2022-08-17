`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// ODDR primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module ODDR
#(
    parameter INIT      = 1'b0,
    parameter TXCLK_POL = 1'b0
)
(
    input  CLK,
    input  D0,
    input  D1,
    input  TX,
    output Q0,
    output Q1
);

    reg _r_D0_p1;
    reg _r_D1_p1;
    reg _r_TS_p1;

    reg _r_D0_p2;
    reg _r_D1_p2;
    reg _r_TS_p2;
    
    reg _r_D0_p2n;
    reg _r_TS_p2n;

    reg _r_D1_p3;
    reg _r_TS_p3;

    initial begin
        _r_D0_p1  = INIT;
        _r_D1_p1  = INIT;
        _r_TS_p1  = INIT;

        _r_D0_p2  = INIT;
        _r_D1_p2  = INIT;
        _r_TS_p2  = INIT;

        _r_D0_p2n = INIT;
        _r_TS_p2n = INIT;

        _r_D1_p3  = INIT;
        _r_TS_p3  = INIT;
    end

    always @(posedge CLK) begin : POS_EDGE_P1
    
	    _r_D0_p1 <= D0;
	    _r_D1_p1 <= D1;
	    _r_TS_p1 <= TX;
    end

    always @(posedge CLK) begin : POS_EDGE_P2
    
	    _r_D0_p2 <= _r_D0_p1;
	    _r_D1_p2 <= _r_D1_p1;
	    _r_TS_p2 <= _r_TS_p1;
    end

    always @(negedge CLK) begin : NEG_EDGE_P2
    
	    _r_D0_p2n <= _r_D0_p2;
	    _r_TS_p2n <= _r_TS_p2;
    end

    always @(posedge CLK) begin : POS_EDGE_P3
    
	    _r_D1_p3 <= _r_D1_p2;
	    _r_TS_p3 <= _r_TS_p2n;
    end

    assign Q0 = (CLK      ) ? _r_D0_p2n : _r_D1_p3;
    assign Q1 = (TXCLK_POL) ? _r_TS_p2n : _r_TS_p3;

endmodule
