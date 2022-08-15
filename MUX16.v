`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// MUX16 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module MUX16
(
    input      I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15,
    input      S0, S1, S2, S3,
    output reg O
);

    always @ (*) begin
        case ({S3, S2, S1, S0})
            4'b0000 : O = I0;
            4'b0001 : O = I1;
            4'b0010 : O = I2;
            4'b0011 : O = I3;
            4'b0100 : O = I4;
            4'b0101 : O = I5;
            4'b0110 : O = I6;
            4'b0111 : O = I7;
            4'b1000 : O = I8;
            4'b1001 : O = I9;
            4'b1010 : O = I10;
            4'b1011 : O = I11;
            4'b1100 : O = I12;
            4'b1101 : O = I13;
            4'b1110 : O = I14;
            4'b1111 : O = I15;
        endcase
    end

endmodule
