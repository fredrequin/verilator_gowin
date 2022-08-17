`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DFFCE primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DFFCE
#(
    parameter INIT = 1'b0
)
(
    input  CLEAR,
    input  CLK,
    input  CE,
    input  D,
    output Q
);

    reg _r_Q;

    initial begin
        _r_Q = INIT;
    end

    always @(posedge CLEAR or posedge CLK) begin
    
        if (CLEAR) begin
            _r_Q <= 1'b0;
        end
        else if (CE) begin
            _r_Q <= D;
        end
    end

    assign Q = _r_Q;

endmodule
