`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// MUX4 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module MUX4
(
    input      I0, I1, I2, I3,
    input      S0, S1,
    output reg O
);

    always @ (*) begin
        case ({S1, S0})
            2'b00 : O = I0;
            2'b01 : O = I1;
            2'b10 : O = I2;
            2'b11 : O = I3;
        endcase
    end

endmodule
