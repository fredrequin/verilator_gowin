`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// SPX9 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module SPX9
#(
    parameter         READ_MODE   = 1'b0,   // 1'b0: bypass mode; 1'b1: pipeline mode
    parameter   [1:0] WRITE_MODE  = 2'b00,  // 2'b00: normal mode; 2'b01: write-through mode; 2'b10: read-before-write mode
    parameter         BIT_WIDTH   = 36,     // 9, 18, 36
    parameter   [2:0] BLK_SEL     = 3'b000,
    parameter string  RESET_MODE  = "SYNC", // SYNC, ASYNC
    parameter [287:0] INIT_RAM_00 = 288'h0,
    parameter [287:0] INIT_RAM_01 = 288'h0,
    parameter [287:0] INIT_RAM_02 = 288'h0,
    parameter [287:0] INIT_RAM_03 = 288'h0,
    parameter [287:0] INIT_RAM_04 = 288'h0,
    parameter [287:0] INIT_RAM_05 = 288'h0,
    parameter [287:0] INIT_RAM_06 = 288'h0,
    parameter [287:0] INIT_RAM_07 = 288'h0,
    parameter [287:0] INIT_RAM_08 = 288'h0,
    parameter [287:0] INIT_RAM_09 = 288'h0,
    parameter [287:0] INIT_RAM_0A = 288'h0,
    parameter [287:0] INIT_RAM_0B = 288'h0,
    parameter [287:0] INIT_RAM_0C = 288'h0,
    parameter [287:0] INIT_RAM_0D = 288'h0,
    parameter [287:0] INIT_RAM_0E = 288'h0,
    parameter [287:0] INIT_RAM_0F = 288'h0,
    parameter [287:0] INIT_RAM_10 = 288'h0,
    parameter [287:0] INIT_RAM_11 = 288'h0,
    parameter [287:0] INIT_RAM_12 = 288'h0,
    parameter [287:0] INIT_RAM_13 = 288'h0,
    parameter [287:0] INIT_RAM_14 = 288'h0,
    parameter [287:0] INIT_RAM_15 = 288'h0,
    parameter [287:0] INIT_RAM_16 = 288'h0,
    parameter [287:0] INIT_RAM_17 = 288'h0,
    parameter [287:0] INIT_RAM_18 = 288'h0,
    parameter [287:0] INIT_RAM_19 = 288'h0,
    parameter [287:0] INIT_RAM_1A = 288'h0,
    parameter [287:0] INIT_RAM_1B = 288'h0,
    parameter [287:0] INIT_RAM_1C = 288'h0,
    parameter [287:0] INIT_RAM_1D = 288'h0,
    parameter [287:0] INIT_RAM_1E = 288'h0,
    parameter [287:0] INIT_RAM_1F = 288'h0,
    parameter [287:0] INIT_RAM_20 = 288'h0,
    parameter [287:0] INIT_RAM_21 = 288'h0,
    parameter [287:0] INIT_RAM_22 = 288'h0,
    parameter [287:0] INIT_RAM_23 = 288'h0,
    parameter [287:0] INIT_RAM_24 = 288'h0,
    parameter [287:0] INIT_RAM_25 = 288'h0,
    parameter [287:0] INIT_RAM_26 = 288'h0,
    parameter [287:0] INIT_RAM_27 = 288'h0,
    parameter [287:0] INIT_RAM_28 = 288'h0,
    parameter [287:0] INIT_RAM_29 = 288'h0,
    parameter [287:0] INIT_RAM_2A = 288'h0,
    parameter [287:0] INIT_RAM_2B = 288'h0,
    parameter [287:0] INIT_RAM_2C = 288'h0,
    parameter [287:0] INIT_RAM_2D = 288'h0,
    parameter [287:0] INIT_RAM_2E = 288'h0,
    parameter [287:0] INIT_RAM_2F = 288'h0,
    parameter [287:0] INIT_RAM_30 = 288'h0,
    parameter [287:0] INIT_RAM_31 = 288'h0,
    parameter [287:0] INIT_RAM_32 = 288'h0,
    parameter [287:0] INIT_RAM_33 = 288'h0,
    parameter [287:0] INIT_RAM_34 = 288'h0,
    parameter [287:0] INIT_RAM_35 = 288'h0,
    parameter [287:0] INIT_RAM_36 = 288'h0,
    parameter [287:0] INIT_RAM_37 = 288'h0,
    parameter [287:0] INIT_RAM_38 = 288'h0,
    parameter [287:0] INIT_RAM_39 = 288'h0,
    parameter [287:0] INIT_RAM_3A = 288'h0,
    parameter [287:0] INIT_RAM_3B = 288'h0,
    parameter [287:0] INIT_RAM_3C = 288'h0,
    parameter [287:0] INIT_RAM_3D = 288'h0,
    parameter [287:0] INIT_RAM_3E = 288'h0,
    parameter [287:0] INIT_RAM_3F = 288'h0,
    parameter string  INIT_FILE   = "NONE"
)
(
    input         RESET,  // Output registers reset
    input         CLK,    // Main clock
    input         CE,     // Chip enable
    input   [2:0] BLKSEL, // Block RAM select
    input         OCE,    // Clock enable for pipelined output
    input         WRE,    // Read (0) / Write (1)
    input  [13:0] AD,     // Memory address + Byte enables
    input  [35:0] DI,     // Data input (write)
    output [35:0] DO      // Data output (read)
);

    reg [35:0] _r_mem [0:511];

    // Block RAM content initialization
    generate
        if (INIT_FILE == "NONE") begin : GEN_GOWIN_INIT
            initial begin : BRAM_INIT_GOWIN
                { _r_mem['h003], _r_mem['h002], _r_mem['h001], _r_mem['h000] } = INIT_RAM_00[143:  0];
                { _r_mem['h007], _r_mem['h006], _r_mem['h005], _r_mem['h004] } = INIT_RAM_00[287:144];
                { _r_mem['h00B], _r_mem['h00A], _r_mem['h009], _r_mem['h008] } = INIT_RAM_01[143:  0];
                { _r_mem['h00F], _r_mem['h00E], _r_mem['h00D], _r_mem['h00C] } = INIT_RAM_01[287:144];
                { _r_mem['h013], _r_mem['h012], _r_mem['h011], _r_mem['h010] } = INIT_RAM_02[143:  0];
                { _r_mem['h017], _r_mem['h016], _r_mem['h015], _r_mem['h014] } = INIT_RAM_02[287:144];
                { _r_mem['h01B], _r_mem['h01A], _r_mem['h019], _r_mem['h018] } = INIT_RAM_03[143:  0];
                { _r_mem['h01F], _r_mem['h01E], _r_mem['h01D], _r_mem['h01C] } = INIT_RAM_03[287:144];
                { _r_mem['h023], _r_mem['h022], _r_mem['h021], _r_mem['h020] } = INIT_RAM_04[143:  0];
                { _r_mem['h027], _r_mem['h026], _r_mem['h025], _r_mem['h024] } = INIT_RAM_04[287:144];
                { _r_mem['h02B], _r_mem['h02A], _r_mem['h029], _r_mem['h028] } = INIT_RAM_05[143:  0];
                { _r_mem['h02F], _r_mem['h02E], _r_mem['h02D], _r_mem['h02C] } = INIT_RAM_05[287:144];
                { _r_mem['h033], _r_mem['h032], _r_mem['h031], _r_mem['h030] } = INIT_RAM_06[143:  0];
                { _r_mem['h037], _r_mem['h036], _r_mem['h035], _r_mem['h034] } = INIT_RAM_06[287:144];
                { _r_mem['h03B], _r_mem['h03A], _r_mem['h039], _r_mem['h038] } = INIT_RAM_07[143:  0];
                { _r_mem['h03F], _r_mem['h03E], _r_mem['h03D], _r_mem['h03C] } = INIT_RAM_07[287:144];
                { _r_mem['h043], _r_mem['h042], _r_mem['h041], _r_mem['h040] } = INIT_RAM_08[143:  0];
                { _r_mem['h047], _r_mem['h046], _r_mem['h045], _r_mem['h044] } = INIT_RAM_08[287:144];
                { _r_mem['h04B], _r_mem['h04A], _r_mem['h049], _r_mem['h048] } = INIT_RAM_09[143:  0];
                { _r_mem['h04F], _r_mem['h04E], _r_mem['h04D], _r_mem['h04C] } = INIT_RAM_09[287:144];
                { _r_mem['h053], _r_mem['h052], _r_mem['h051], _r_mem['h050] } = INIT_RAM_0A[143:  0];
                { _r_mem['h057], _r_mem['h056], _r_mem['h055], _r_mem['h054] } = INIT_RAM_0A[287:144];
                { _r_mem['h05B], _r_mem['h05A], _r_mem['h059], _r_mem['h058] } = INIT_RAM_0B[143:  0];
                { _r_mem['h05F], _r_mem['h05E], _r_mem['h05D], _r_mem['h05C] } = INIT_RAM_0B[287:144];
                { _r_mem['h063], _r_mem['h062], _r_mem['h061], _r_mem['h060] } = INIT_RAM_0C[143:  0];
                { _r_mem['h067], _r_mem['h066], _r_mem['h065], _r_mem['h064] } = INIT_RAM_0C[287:144];
                { _r_mem['h06B], _r_mem['h06A], _r_mem['h069], _r_mem['h068] } = INIT_RAM_0D[143:  0];
                { _r_mem['h06F], _r_mem['h06E], _r_mem['h06D], _r_mem['h06C] } = INIT_RAM_0D[287:144];
                { _r_mem['h073], _r_mem['h072], _r_mem['h071], _r_mem['h070] } = INIT_RAM_0E[143:  0];
                { _r_mem['h077], _r_mem['h076], _r_mem['h075], _r_mem['h074] } = INIT_RAM_0E[287:144];
                { _r_mem['h07B], _r_mem['h07A], _r_mem['h079], _r_mem['h078] } = INIT_RAM_0F[143:  0];
                { _r_mem['h07F], _r_mem['h07E], _r_mem['h07D], _r_mem['h07C] } = INIT_RAM_0F[287:144];
                { _r_mem['h083], _r_mem['h082], _r_mem['h081], _r_mem['h080] } = INIT_RAM_10[143:  0];
                { _r_mem['h087], _r_mem['h086], _r_mem['h085], _r_mem['h084] } = INIT_RAM_10[287:144];
                { _r_mem['h08B], _r_mem['h08A], _r_mem['h089], _r_mem['h088] } = INIT_RAM_11[143:  0];
                { _r_mem['h08F], _r_mem['h08E], _r_mem['h08D], _r_mem['h08C] } = INIT_RAM_11[287:144];
                { _r_mem['h093], _r_mem['h092], _r_mem['h091], _r_mem['h090] } = INIT_RAM_12[143:  0];
                { _r_mem['h097], _r_mem['h096], _r_mem['h095], _r_mem['h094] } = INIT_RAM_12[287:144];
                { _r_mem['h09B], _r_mem['h09A], _r_mem['h099], _r_mem['h098] } = INIT_RAM_13[143:  0];
                { _r_mem['h09F], _r_mem['h09E], _r_mem['h09D], _r_mem['h09C] } = INIT_RAM_13[287:144];
                { _r_mem['h0A3], _r_mem['h0A2], _r_mem['h0A1], _r_mem['h0A0] } = INIT_RAM_14[143:  0];
                { _r_mem['h0A7], _r_mem['h0A6], _r_mem['h0A5], _r_mem['h0A4] } = INIT_RAM_14[287:144];
                { _r_mem['h0AB], _r_mem['h0AA], _r_mem['h0A9], _r_mem['h0A8] } = INIT_RAM_15[143:  0];
                { _r_mem['h0AF], _r_mem['h0AE], _r_mem['h0AD], _r_mem['h0AC] } = INIT_RAM_15[287:144];
                { _r_mem['h0B3], _r_mem['h0B2], _r_mem['h0B1], _r_mem['h0B0] } = INIT_RAM_16[143:  0];
                { _r_mem['h0B7], _r_mem['h0B6], _r_mem['h0B5], _r_mem['h0B4] } = INIT_RAM_16[287:144];
                { _r_mem['h0BB], _r_mem['h0BA], _r_mem['h0B9], _r_mem['h0B8] } = INIT_RAM_17[143:  0];
                { _r_mem['h0BF], _r_mem['h0BE], _r_mem['h0BD], _r_mem['h0BC] } = INIT_RAM_17[287:144];
                { _r_mem['h0C3], _r_mem['h0C2], _r_mem['h0C1], _r_mem['h0C0] } = INIT_RAM_18[143:  0];
                { _r_mem['h0C7], _r_mem['h0C6], _r_mem['h0C5], _r_mem['h0C4] } = INIT_RAM_18[287:144];
                { _r_mem['h0CB], _r_mem['h0CA], _r_mem['h0C9], _r_mem['h0C8] } = INIT_RAM_19[143:  0];
                { _r_mem['h0CF], _r_mem['h0CE], _r_mem['h0CD], _r_mem['h0CC] } = INIT_RAM_19[287:144];
                { _r_mem['h0D3], _r_mem['h0D2], _r_mem['h0D1], _r_mem['h0D0] } = INIT_RAM_1A[143:  0];
                { _r_mem['h0D7], _r_mem['h0D6], _r_mem['h0D5], _r_mem['h0D4] } = INIT_RAM_1A[287:144];
                { _r_mem['h0DB], _r_mem['h0DA], _r_mem['h0D9], _r_mem['h0D8] } = INIT_RAM_1B[143:  0];
                { _r_mem['h0DF], _r_mem['h0DE], _r_mem['h0DD], _r_mem['h0DC] } = INIT_RAM_1B[287:144];
                { _r_mem['h0E3], _r_mem['h0E2], _r_mem['h0E1], _r_mem['h0E0] } = INIT_RAM_1C[143:  0];
                { _r_mem['h0E7], _r_mem['h0E6], _r_mem['h0E5], _r_mem['h0E4] } = INIT_RAM_1C[287:144];
                { _r_mem['h0EB], _r_mem['h0EA], _r_mem['h0E9], _r_mem['h0E8] } = INIT_RAM_1D[143:  0];
                { _r_mem['h0EF], _r_mem['h0EE], _r_mem['h0ED], _r_mem['h0EC] } = INIT_RAM_1D[287:144];
                { _r_mem['h0F3], _r_mem['h0F2], _r_mem['h0F1], _r_mem['h0F0] } = INIT_RAM_1E[143:  0];
                { _r_mem['h0F7], _r_mem['h0F6], _r_mem['h0F5], _r_mem['h0F4] } = INIT_RAM_1E[287:144];
                { _r_mem['h0FB], _r_mem['h0FA], _r_mem['h0F9], _r_mem['h0F8] } = INIT_RAM_1F[143:  0];
                { _r_mem['h0FF], _r_mem['h0FE], _r_mem['h0FD], _r_mem['h0FC] } = INIT_RAM_1F[287:144];
                { _r_mem['h103], _r_mem['h102], _r_mem['h101], _r_mem['h100] } = INIT_RAM_20[143:  0];
                { _r_mem['h107], _r_mem['h106], _r_mem['h105], _r_mem['h104] } = INIT_RAM_20[287:144];
                { _r_mem['h10B], _r_mem['h10A], _r_mem['h109], _r_mem['h108] } = INIT_RAM_21[143:  0];
                { _r_mem['h10F], _r_mem['h10E], _r_mem['h10D], _r_mem['h10C] } = INIT_RAM_21[287:144];
                { _r_mem['h113], _r_mem['h112], _r_mem['h111], _r_mem['h110] } = INIT_RAM_22[143:  0];
                { _r_mem['h117], _r_mem['h116], _r_mem['h115], _r_mem['h114] } = INIT_RAM_22[287:144];
                { _r_mem['h11B], _r_mem['h11A], _r_mem['h119], _r_mem['h118] } = INIT_RAM_23[143:  0];
                { _r_mem['h11F], _r_mem['h11E], _r_mem['h11D], _r_mem['h11C] } = INIT_RAM_23[287:144];
                { _r_mem['h123], _r_mem['h122], _r_mem['h121], _r_mem['h120] } = INIT_RAM_24[143:  0];
                { _r_mem['h127], _r_mem['h126], _r_mem['h125], _r_mem['h124] } = INIT_RAM_24[287:144];
                { _r_mem['h12B], _r_mem['h12A], _r_mem['h129], _r_mem['h128] } = INIT_RAM_25[143:  0];
                { _r_mem['h12F], _r_mem['h12E], _r_mem['h12D], _r_mem['h12C] } = INIT_RAM_25[287:144];
                { _r_mem['h133], _r_mem['h132], _r_mem['h131], _r_mem['h130] } = INIT_RAM_26[143:  0];
                { _r_mem['h137], _r_mem['h136], _r_mem['h135], _r_mem['h134] } = INIT_RAM_26[287:144];
                { _r_mem['h13B], _r_mem['h13A], _r_mem['h139], _r_mem['h138] } = INIT_RAM_27[143:  0];
                { _r_mem['h13F], _r_mem['h13E], _r_mem['h13D], _r_mem['h13C] } = INIT_RAM_27[287:144];
                { _r_mem['h143], _r_mem['h142], _r_mem['h141], _r_mem['h140] } = INIT_RAM_28[143:  0];
                { _r_mem['h147], _r_mem['h146], _r_mem['h145], _r_mem['h144] } = INIT_RAM_28[287:144];
                { _r_mem['h14B], _r_mem['h14A], _r_mem['h149], _r_mem['h148] } = INIT_RAM_29[143:  0];
                { _r_mem['h14F], _r_mem['h14E], _r_mem['h14D], _r_mem['h14C] } = INIT_RAM_29[287:144];
                { _r_mem['h153], _r_mem['h152], _r_mem['h151], _r_mem['h150] } = INIT_RAM_2A[143:  0];
                { _r_mem['h157], _r_mem['h156], _r_mem['h155], _r_mem['h154] } = INIT_RAM_2A[287:144];
                { _r_mem['h15B], _r_mem['h15A], _r_mem['h159], _r_mem['h158] } = INIT_RAM_2B[143:  0];
                { _r_mem['h15F], _r_mem['h15E], _r_mem['h15D], _r_mem['h15C] } = INIT_RAM_2B[287:144];
                { _r_mem['h163], _r_mem['h162], _r_mem['h161], _r_mem['h160] } = INIT_RAM_2C[143:  0];
                { _r_mem['h167], _r_mem['h166], _r_mem['h165], _r_mem['h164] } = INIT_RAM_2C[287:144];
                { _r_mem['h16B], _r_mem['h16A], _r_mem['h169], _r_mem['h168] } = INIT_RAM_2D[143:  0];
                { _r_mem['h16F], _r_mem['h16E], _r_mem['h16D], _r_mem['h16C] } = INIT_RAM_2D[287:144];
                { _r_mem['h173], _r_mem['h172], _r_mem['h171], _r_mem['h170] } = INIT_RAM_2E[143:  0];
                { _r_mem['h177], _r_mem['h176], _r_mem['h175], _r_mem['h174] } = INIT_RAM_2E[287:144];
                { _r_mem['h17B], _r_mem['h17A], _r_mem['h179], _r_mem['h178] } = INIT_RAM_2F[143:  0];
                { _r_mem['h17F], _r_mem['h17E], _r_mem['h17D], _r_mem['h17C] } = INIT_RAM_2F[287:144];
                { _r_mem['h183], _r_mem['h182], _r_mem['h181], _r_mem['h180] } = INIT_RAM_30[143:  0];
                { _r_mem['h187], _r_mem['h186], _r_mem['h185], _r_mem['h184] } = INIT_RAM_30[287:144];
                { _r_mem['h18B], _r_mem['h18A], _r_mem['h189], _r_mem['h188] } = INIT_RAM_31[143:  0];
                { _r_mem['h18F], _r_mem['h18E], _r_mem['h18D], _r_mem['h18C] } = INIT_RAM_31[287:144];
                { _r_mem['h193], _r_mem['h192], _r_mem['h191], _r_mem['h190] } = INIT_RAM_32[143:  0];
                { _r_mem['h197], _r_mem['h196], _r_mem['h195], _r_mem['h194] } = INIT_RAM_32[287:144];
                { _r_mem['h19B], _r_mem['h19A], _r_mem['h199], _r_mem['h198] } = INIT_RAM_33[143:  0];
                { _r_mem['h19F], _r_mem['h19E], _r_mem['h19D], _r_mem['h19C] } = INIT_RAM_33[287:144];
                { _r_mem['h1A3], _r_mem['h1A2], _r_mem['h1A1], _r_mem['h1A0] } = INIT_RAM_34[143:  0];
                { _r_mem['h1A7], _r_mem['h1A6], _r_mem['h1A5], _r_mem['h1A4] } = INIT_RAM_34[287:144];
                { _r_mem['h1AB], _r_mem['h1AA], _r_mem['h1A9], _r_mem['h1A8] } = INIT_RAM_35[143:  0];
                { _r_mem['h1AF], _r_mem['h1AE], _r_mem['h1AD], _r_mem['h1AC] } = INIT_RAM_35[287:144];
                { _r_mem['h1B3], _r_mem['h1B2], _r_mem['h1B1], _r_mem['h1B0] } = INIT_RAM_36[143:  0];
                { _r_mem['h1B7], _r_mem['h1B6], _r_mem['h1B5], _r_mem['h1B4] } = INIT_RAM_36[287:144];
                { _r_mem['h1BB], _r_mem['h1BA], _r_mem['h1B9], _r_mem['h1B8] } = INIT_RAM_37[143:  0];
                { _r_mem['h1BF], _r_mem['h1BE], _r_mem['h1BD], _r_mem['h1BC] } = INIT_RAM_37[287:144];
                { _r_mem['h1C3], _r_mem['h1C2], _r_mem['h1C1], _r_mem['h1C0] } = INIT_RAM_38[143:  0];
                { _r_mem['h1C7], _r_mem['h1C6], _r_mem['h1C5], _r_mem['h1C4] } = INIT_RAM_38[287:144];
                { _r_mem['h1CB], _r_mem['h1CA], _r_mem['h1C9], _r_mem['h1C8] } = INIT_RAM_39[143:  0];
                { _r_mem['h1CF], _r_mem['h1CE], _r_mem['h1CD], _r_mem['h1CC] } = INIT_RAM_39[287:144];
                { _r_mem['h1D3], _r_mem['h1D2], _r_mem['h1D1], _r_mem['h1D0] } = INIT_RAM_3A[143:  0];
                { _r_mem['h1D7], _r_mem['h1D6], _r_mem['h1D5], _r_mem['h1D4] } = INIT_RAM_3A[287:144];
                { _r_mem['h1DB], _r_mem['h1DA], _r_mem['h1D9], _r_mem['h1D8] } = INIT_RAM_3B[143:  0];
                { _r_mem['h1DF], _r_mem['h1DE], _r_mem['h1DD], _r_mem['h1DC] } = INIT_RAM_3B[287:144];
                { _r_mem['h1E3], _r_mem['h1E2], _r_mem['h1E1], _r_mem['h1E0] } = INIT_RAM_3C[143:  0];
                { _r_mem['h1E7], _r_mem['h1E6], _r_mem['h1E5], _r_mem['h1E4] } = INIT_RAM_3C[287:144];
                { _r_mem['h1EB], _r_mem['h1EA], _r_mem['h1E9], _r_mem['h1E8] } = INIT_RAM_3D[143:  0];
                { _r_mem['h1EF], _r_mem['h1EE], _r_mem['h1ED], _r_mem['h1EC] } = INIT_RAM_3D[287:144];
                { _r_mem['h1F3], _r_mem['h1F2], _r_mem['h1F1], _r_mem['h1F0] } = INIT_RAM_3E[143:  0];
                { _r_mem['h1F7], _r_mem['h1F6], _r_mem['h1F5], _r_mem['h1F4] } = INIT_RAM_3E[287:144];
                { _r_mem['h1FB], _r_mem['h1FA], _r_mem['h1F9], _r_mem['h1F8] } = INIT_RAM_3F[143:  0];
                { _r_mem['h1FF], _r_mem['h1FE], _r_mem['h1FD], _r_mem['h1FC] } = INIT_RAM_3F[287:144];
            end
        end
        else begin : GEN_VERILOG_INIT
            initial begin : BRAM_INIT_VERILOG
                integer _i;
                
                // First, clear array
                for (_i = 0; _i < 512; _i = _i + 1) begin
                    _r_mem[_i] = 36'h0;
                end
                // Simple .mem file (always mapped as a 512 x 36-bit hexadecimal dump)
                $readmemh(INIT_FILE, _r_mem);
            end
        end
    endgenerate
    
    // Reset type
    wire _w_ARST = (RESET_MODE == "ASYNC") ? RESET : 1'b0;
    wire _w_SRST = (RESET_MODE == "SYNC" ) ? RESET : 1'b0;
    
    // Block RAM select
    wire _w_BS = (BLKSEL == BLK_SEL) ? CE : 1'b0;

    // Block RAM write
    always @(posedge CLK) begin : BRAM_WRITE

        // Block RAM selected with write enable
        if (_w_BS & WRE) begin
            case (BIT_WIDTH)
                // 9-bit block RAM
                 9 : _r_mem[AD[13:5]][AD[4:3] * 9 +: 9] <= DI[8:0];
                // 16-bit block RAM with write enables
                16 : begin
                    if (AD[0]) _r_mem[AD[13:5]][(AD[4] ? 18 : 0) +: 9] <= DI[ 8:0];
                    if (AD[1]) _r_mem[AD[13:5]][(AD[4] ? 27 : 9) +: 9] <= DI[17:9];
                end
                // 36-bit block RAM with write enables
                36 : begin
                    if (AD[0]) _r_mem[AD[13:5]][ 0 +: 9] <= DI[ 8: 0];
                    if (AD[1]) _r_mem[AD[13:5]][ 9 +: 9] <= DI[17: 9];
                    if (AD[2]) _r_mem[AD[13:5]][18 +: 9] <= DI[26:18];
                    if (AD[3]) _r_mem[AD[13:5]][27 +: 9] <= DI[35:27];
                end
                // Undefined width
                default : ;
            endcase
        end
    end
    
    reg [35:0] _r_dout_p1;

    // Block RAM read
    always @(posedge CLK or posedge _w_ARST) begin : BRAM_READ_P1
        reg [35:0] _v_tmp;
    
        // Asynchronous reset
        if (_w_ARST) begin
            _r_dout_p1 <= 36'b0;
        end
        // Synchronous reset
        else if (_w_SRST) begin
            _r_dout_p1 <= 36'b0;
        end
        // Block RAM selected
        else if (_w_BS) begin
            case (BIT_WIDTH)
                // 9-bit block RAM
                 9: _v_tmp = { 27'b0, _r_mem[AD[13:5]][AD[4:3] * 9 +: 9] };
                // 18-bit block RAM
                18: _v_tmp = { 18'b0, _r_mem[AD[13:5]][(AD[4] ? 18 : 0) +: 18] };
                // 36-bit block RAM
                36: _v_tmp = _r_mem[AD[13:5]];
                // Undefined width
                default: _v_tmp = 36'b0;
            endcase
                
            // Write enable
            if (WRE) begin
                // Write-through mode
                if (WRITE_MODE[0]) begin
                    case (BIT_WIDTH)
                         9: _r_dout_p1 <= { 27'b0, DI[8:0] };
                        18: begin
                            _r_dout_p1[35:18] <= 18'b0;
                            _r_dout_p1[17: 9] <= (AD[1]) ? DI[17: 9] : _v_tmp[17: 9];
                            _r_dout_p1[ 8: 0] <= (AD[0]) ? DI[ 8: 0] : _v_tmp[ 8: 0];
                        end
                        36: begin
                            _r_dout_p1[35:27] <= (AD[3]) ? DI[35:27] : _v_tmp[35:27];
                            _r_dout_p1[26:18] <= (AD[2]) ? DI[26:18] : _v_tmp[26:18];
                            _r_dout_p1[17: 9] <= (AD[1]) ? DI[17: 9] : _v_tmp[17: 9];
                            _r_dout_p1[ 8: 0] <= (AD[0]) ? DI[ 8: 0] : _v_tmp[ 8: 0];
                        end
                    endcase
                end
                // Read-before-write mode
                else if (WRITE_MODE[1]) begin
                    _r_dout_p1 <= _v_tmp;
                end
            end
            // Read enable
            else begin
                _r_dout_p1 <= _v_tmp;
            end
        end
    end

    reg [35:0] _r_dout_p2;

    // Pipelined register
    always @(posedge CLK or posedge _w_ARST) begin : BRAM_READ_P2

        // Asynchronous reset
        if (_w_ARST) begin
            _r_dout_p2 <= 36'b0;
        end
        // Synchronous reset
        else if (_w_SRST) begin
            _r_dout_p2 <= 36'b0;
        end
        // Output clock enable
        else if (OCE) begin
            _r_dout_p2 <= _r_dout_p1;
        end
    end

    assign DO = (READ_MODE) ? _r_dout_p2 : _r_dout_p1;

endmodule