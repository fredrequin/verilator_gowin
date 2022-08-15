`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// LUT6 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module LUT6
#(
    parameter [63:0] INIT = 64'h0
)
(
    input  I0,
    input  I1,
    input  I2,
    input  I3,
    input  I4,
    input  I5,
    output F
);

    assign F = INIT[{I5, I4, I3, I2, I1, I0}];

endmodule
