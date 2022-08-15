`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// MUX8 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module MUX8
(
    input      I0, I1, I2, I3, I4, I5, I6, I7,
    input      S0, S1, S2,
    output reg O
);

    always @ (*) begin
        case ({S2, S1, S0})
            3'b000 : O = I0;
            3'b001 : O = I1;
            3'b010 : O = I2;
            3'b011 : O = I3;
            3'b100 : O = I4;
            3'b101 : O = I5;
            3'b110 : O = I6;
            3'b111 : O = I7;
        endcase
    end

endmodule
