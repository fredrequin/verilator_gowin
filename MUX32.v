`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// MUX32 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module MUX32
(
    input       I0,  I1,  I2,  I3,  I4,  I5,  I6,  I7,  I8,  I9, I10, I11, I12, I13, I14, I15,
    input      I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31,
    input      S0, S1, S2, S3, S4,
    output reg O
);

    always @ (*) begin
        case ({S4, S3, S2, S1, S0})
            5'b00000 : O = I0;
            5'b00001 : O = I1;
            5'b00010 : O = I2;
            5'b00011 : O = I3;
            5'b00100 : O = I4;
            5'b00101 : O = I5;
            5'b00110 : O = I6;
            5'b00111 : O = I7;
            5'b01000 : O = I8;
            5'b01001 : O = I9;
            5'b01010 : O = I10;
            5'b01011 : O = I11;
            5'b01100 : O = I12;
            5'b01101 : O = I13;
            5'b01110 : O = I14;
            5'b01111 : O = I15;
            5'b10000 : O = I16;
            5'b10001 : O = I17;
            5'b10010 : O = I18;
            5'b10011 : O = I19;
            5'b10100 : O = I20;
            5'b10101 : O = I21;
            5'b10110 : O = I22;
            5'b10111 : O = I23;
            5'b11000 : O = I24;
            5'b11001 : O = I25;
            5'b11010 : O = I26;
            5'b11011 : O = I27;
            5'b11100 : O = I28;
            5'b11101 : O = I29;
            5'b11110 : O = I30;
            5'b11111 : O = I31;
        endcase
    end

endmodule
