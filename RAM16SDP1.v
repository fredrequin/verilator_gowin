`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// RAM16SDP1 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module RAM16SDP1
#(
    parameter [15:0] INIT_0 = 16'h0
)
(
    input        CLK,
    input        WRE,
    input  [3:0] WAD,
    input        DI,
    input  [3:0] RAD,
    output       DO
);

    reg [15:0] _r_mem;
    
    initial begin
    
        _r_mem = INIT_0;
    end
    
    always @(posedge CLK) begin
    
        if (WRE) begin
            _r_mem[WAD] <= DI;
        end
    end
    
    assign DO = _r_mem[RAD];

endmodule
