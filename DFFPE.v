`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DFFPE primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DFFPE
#(
    parameter INIT = 1'b1
)
(
    input  PRESET,
    input  CLK,
    input  CE,
    input  D,
    output Q
);

    reg _r_Q;

    initial begin
        _r_Q = INIT;
    end

    always @(posedge PRESET or posedge CLK) begin
    
        if (PRESET) begin
            _r_Q <= 1'b1;
        end
        else if (CE) begin
            _r_Q <= D;
        end
    end

    assign Q = _r_Q;

endmodule
