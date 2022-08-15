`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// LUT8 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module LUT8
#(
    parameter [255:0] INIT = 256'h0
)
(
    input  I0,
    input  I1,
    input  I2,
    input  I3,
    input  I4,
    input  I5,
    input  I6,
    input  I7,
    output F
);

    assign F = INIT[{I7, I6, I5, I4, I3, I2, I1, I0}];

endmodule
