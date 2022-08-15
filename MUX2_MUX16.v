`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// MUX2_MUX16 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//
module MUX2_MUX16
(
    input  I0,
    input  I1,
    input  S0,
    output O
);

    assign O = (S0) ? I1 : I0;

endmodule
