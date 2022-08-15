`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// LUT4 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module LUT4
#(
    parameter [15:0] INIT = 16'h0
)
(
    input  I0,
    input  I1,
    input  I2,
    input  I3,
    output F
);

    assign F = INIT[{I3, I2, I1, I0}];

endmodule
