`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// LUT1 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module LUT1
#(
    parameter [1:0] INIT = 2'b0
)
(
    input  I0,
    output F
);

    assign F = INIT[I0];

endmodule
