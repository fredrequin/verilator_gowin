`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// ROM16 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module ROM16
#(
    parameter [15:0] INIT_0 = 16'h0
)
(
    input  [3:0] AD,
    output       DO
);

    reg [15:0] _r_mem;
    
    initial begin
    
        _r_mem = INIT_0;
    end
    
    assign DO = _r_mem[AD];

endmodule
