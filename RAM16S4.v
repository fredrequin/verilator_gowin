`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// RAM16S4 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module RAM16S4
#(
    parameter [15:0] INIT_0 = 16'h0,
    parameter [15:0] INIT_1 = 16'h0,
    parameter [15:0] INIT_2 = 16'h0,
    parameter [15:0] INIT_3 = 16'h0
)
(
    input        CLK,
    input        WRE,
    input  [3:0] AD,
    input  [3:0] DI,
    output [3:0] DO
);

    reg [3:0] _r_mem [0:15];
    
    initial begin
        int _i;
        
        for (_i = 0; _i < 16; _i = _i + 1) begin
            _r_mem[_i] = { INIT_3[_i], INIT_2[_i], INIT_1[_i], INIT_0[_i] };
        end
    end
    
    always @(posedge CLK) begin
    
        if (WRE) begin
            _r_mem[AD] <= DI;
        end
    end
    
    assign DO = _r_mem[AD];

endmodule
