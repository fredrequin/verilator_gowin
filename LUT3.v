`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// LUT3 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module LUT3
#(
    parameter [7:0] INIT = 8'b0
)
(
    input  I0,
    input  I1,
    input  I2,
    output F
);

    assign F = INIT[{I2, I1, I0}];

endmodule
