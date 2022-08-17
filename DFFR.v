`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// DFFR primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module DFFR
#(
    parameter INIT = 1'b0
)
(
    input  CLK,
    input  RESET,
    input  D,
    output Q
);

    reg _r_Q;

    initial begin
        _r_Q = INIT;
    end

    always @(posedge CLK) begin
    
        if (RESET) begin
            _r_Q <= 1'b0;
        end
        else begin
            _r_Q <= D;
        end
    end

    assign Q = _r_Q;

endmodule