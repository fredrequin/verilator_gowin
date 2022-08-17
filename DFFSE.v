`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DFFSE primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DFFSE
#(
    parameter INIT = 1'b1
)
(
    input  CLK,
    input  CE,
    input  SET,
    input  D,
    output Q
);

    reg _r_Q;

    initial begin
        _r_Q = INIT;
    end

    always @(posedge CLK) begin
    
        if (SET) begin
            _r_Q <= 1'b1;
        end
        else if (CE) begin
            _r_Q <= D;
        end
    end

    assign Q = _r_Q;

endmodule
