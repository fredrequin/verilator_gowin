`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// RAM16SDP2 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module RAM16SDP2
#(
    parameter [15:0] INIT_0 = 16'h0,
    parameter [15:0] INIT_1 = 16'h0
)
(
    input        CLK,
    input        WRE,
    input  [3:0] WAD,
    input  [1:0] DI,
    input  [3:0] RAD,
    output [1:0] DO
);

    reg [1:0] _r_mem [0:15];
    
    initial begin
        int _i;
        
        for (_i = 0; _i < 16; _i = _i + 1) begin
            _r_mem[_i] = { INIT_1[_i], INIT_0[_i] };
        end
    end
    
    always @(posedge CLK) begin
    
        if (WRE) begin
            _r_mem[WAD] <= DI;
        end
    end
    
    assign DO = _r_mem[RAD];

endmodule
