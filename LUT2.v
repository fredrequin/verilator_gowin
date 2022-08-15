`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// LUT2 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module LUT2
#(
    parameter [3:0] INIT = 4'b0
)
(
    input  I0,
    input  I1,
    output F
);

    assign F = INIT[{I1, I0}];

endmodule
