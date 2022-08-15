`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// SDP primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module SDP
#(
    parameter         READ_MODE   = 1'b0,   // 1'b0: bypass mode; 1'b1: pipeline mode
    parameter         BIT_WIDTH_0 = 32,     // 1, 2, 4, 8, 16, 32
    parameter         BIT_WIDTH_1 = 32,     // 1, 2, 4, 8, 16, 32
    parameter   [2:0] BLK_SEL     = 3'b000,
    parameter string  RESET_MODE  = "SYNC", // SYNC, ASYNC
    parameter [255:0] INIT_RAM_00 = 256'h0,
    parameter [255:0] INIT_RAM_01 = 256'h0,
    parameter [255:0] INIT_RAM_02 = 256'h0,
    parameter [255:0] INIT_RAM_03 = 256'h0,
    parameter [255:0] INIT_RAM_04 = 256'h0,
    parameter [255:0] INIT_RAM_05 = 256'h0,
    parameter [255:0] INIT_RAM_06 = 256'h0,
    parameter [255:0] INIT_RAM_07 = 256'h0,
    parameter [255:0] INIT_RAM_08 = 256'h0,
    parameter [255:0] INIT_RAM_09 = 256'h0,
    parameter [255:0] INIT_RAM_0A = 256'h0,
    parameter [255:0] INIT_RAM_0B = 256'h0,
    parameter [255:0] INIT_RAM_0C = 256'h0,
    parameter [255:0] INIT_RAM_0D = 256'h0,
    parameter [255:0] INIT_RAM_0E = 256'h0,
    parameter [255:0] INIT_RAM_0F = 256'h0,
    parameter [255:0] INIT_RAM_10 = 256'h0,
    parameter [255:0] INIT_RAM_11 = 256'h0,
    parameter [255:0] INIT_RAM_12 = 256'h0,
    parameter [255:0] INIT_RAM_13 = 256'h0,
    parameter [255:0] INIT_RAM_14 = 256'h0,
    parameter [255:0] INIT_RAM_15 = 256'h0,
    parameter [255:0] INIT_RAM_16 = 256'h0,
    parameter [255:0] INIT_RAM_17 = 256'h0,
    parameter [255:0] INIT_RAM_18 = 256'h0,
    parameter [255:0] INIT_RAM_19 = 256'h0,
    parameter [255:0] INIT_RAM_1A = 256'h0,
    parameter [255:0] INIT_RAM_1B = 256'h0,
    parameter [255:0] INIT_RAM_1C = 256'h0,
    parameter [255:0] INIT_RAM_1D = 256'h0,
    parameter [255:0] INIT_RAM_1E = 256'h0,
    parameter [255:0] INIT_RAM_1F = 256'h0,
    parameter [255:0] INIT_RAM_20 = 256'h0,
    parameter [255:0] INIT_RAM_21 = 256'h0,
    parameter [255:0] INIT_RAM_22 = 256'h0,
    parameter [255:0] INIT_RAM_23 = 256'h0,
    parameter [255:0] INIT_RAM_24 = 256'h0,
    parameter [255:0] INIT_RAM_25 = 256'h0,
    parameter [255:0] INIT_RAM_26 = 256'h0,
    parameter [255:0] INIT_RAM_27 = 256'h0,
    parameter [255:0] INIT_RAM_28 = 256'h0,
    parameter [255:0] INIT_RAM_29 = 256'h0,
    parameter [255:0] INIT_RAM_2A = 256'h0,
    parameter [255:0] INIT_RAM_2B = 256'h0,
    parameter [255:0] INIT_RAM_2C = 256'h0,
    parameter [255:0] INIT_RAM_2D = 256'h0,
    parameter [255:0] INIT_RAM_2E = 256'h0,
    parameter [255:0] INIT_RAM_2F = 256'h0,
    parameter [255:0] INIT_RAM_30 = 256'h0,
    parameter [255:0] INIT_RAM_31 = 256'h0,
    parameter [255:0] INIT_RAM_32 = 256'h0,
    parameter [255:0] INIT_RAM_33 = 256'h0,
    parameter [255:0] INIT_RAM_34 = 256'h0,
    parameter [255:0] INIT_RAM_35 = 256'h0,
    parameter [255:0] INIT_RAM_36 = 256'h0,
    parameter [255:0] INIT_RAM_37 = 256'h0,
    parameter [255:0] INIT_RAM_38 = 256'h0,
    parameter [255:0] INIT_RAM_39 = 256'h0,
    parameter [255:0] INIT_RAM_3A = 256'h0,
    parameter [255:0] INIT_RAM_3B = 256'h0,
    parameter [255:0] INIT_RAM_3C = 256'h0,
    parameter [255:0] INIT_RAM_3D = 256'h0,
    parameter [255:0] INIT_RAM_3E = 256'h0,
    parameter [255:0] INIT_RAM_3F = 256'h0,
    parameter string  INIT_FILE   = "NONE"
)
(
    // Port A
    input         RESETA, // Output registers reset
    input         CLKA,   // Clock
    input         CEA,    // Chip enable
    input         WREA,   // Read (0) / Write (1)
    input  [13:0] ADA,    // Memory address + Byte enables
    // Port B
    input         RESETB, // Output registers reset - port B
    input         CLKB,   // Port B clock
    input         CEB,    // Chip enable
    input         WREB,   // Read (0) / Write (1)
    input  [13:0] ADB,    // Memory address + Byte enables
    //
    input   [2:0] BLKSEL, // Block RAM select
    input         OCE,    // Clock enable for pipelined output
    input  [31:0] DI,     // Data input (write)
    output [31:0] DO      // Data output (read)
);

    reg [31:0] _r_mem [0:511];

    // Block RAM content initialization
    generate
        if (INIT_FILE == "NONE") begin : GEN_GOWIN_INIT
            initial begin : BRAM_INIT_GOWIN
                { _r_mem['h003], _r_mem['h002], _r_mem['h001], _r_mem['h000] } = INIT_RAM_00[127:  0];
                { _r_mem['h007], _r_mem['h006], _r_mem['h005], _r_mem['h004] } = INIT_RAM_00[255:128];
                { _r_mem['h00B], _r_mem['h00A], _r_mem['h009], _r_mem['h008] } = INIT_RAM_01[127:  0];
                { _r_mem['h00F], _r_mem['h00E], _r_mem['h00D], _r_mem['h00C] } = INIT_RAM_01[255:128];
                { _r_mem['h013], _r_mem['h012], _r_mem['h011], _r_mem['h010] } = INIT_RAM_02[127:  0];
                { _r_mem['h017], _r_mem['h016], _r_mem['h015], _r_mem['h014] } = INIT_RAM_02[255:128];
                { _r_mem['h01B], _r_mem['h01A], _r_mem['h019], _r_mem['h018] } = INIT_RAM_03[127:  0];
                { _r_mem['h01F], _r_mem['h01E], _r_mem['h01D], _r_mem['h01C] } = INIT_RAM_03[255:128];
                { _r_mem['h023], _r_mem['h022], _r_mem['h021], _r_mem['h020] } = INIT_RAM_04[127:  0];
                { _r_mem['h027], _r_mem['h026], _r_mem['h025], _r_mem['h024] } = INIT_RAM_04[255:128];
                { _r_mem['h02B], _r_mem['h02A], _r_mem['h029], _r_mem['h028] } = INIT_RAM_05[127:  0];
                { _r_mem['h02F], _r_mem['h02E], _r_mem['h02D], _r_mem['h02C] } = INIT_RAM_05[255:128];
                { _r_mem['h033], _r_mem['h032], _r_mem['h031], _r_mem['h030] } = INIT_RAM_06[127:  0];
                { _r_mem['h037], _r_mem['h036], _r_mem['h035], _r_mem['h034] } = INIT_RAM_06[255:128];
                { _r_mem['h03B], _r_mem['h03A], _r_mem['h039], _r_mem['h038] } = INIT_RAM_07[127:  0];
                { _r_mem['h03F], _r_mem['h03E], _r_mem['h03D], _r_mem['h03C] } = INIT_RAM_07[255:128];
                { _r_mem['h043], _r_mem['h042], _r_mem['h041], _r_mem['h040] } = INIT_RAM_08[127:  0];
                { _r_mem['h047], _r_mem['h046], _r_mem['h045], _r_mem['h044] } = INIT_RAM_08[255:128];
                { _r_mem['h04B], _r_mem['h04A], _r_mem['h049], _r_mem['h048] } = INIT_RAM_09[127:  0];
                { _r_mem['h04F], _r_mem['h04E], _r_mem['h04D], _r_mem['h04C] } = INIT_RAM_09[255:128];
                { _r_mem['h053], _r_mem['h052], _r_mem['h051], _r_mem['h050] } = INIT_RAM_0A[127:  0];
                { _r_mem['h057], _r_mem['h056], _r_mem['h055], _r_mem['h054] } = INIT_RAM_0A[255:128];
                { _r_mem['h05B], _r_mem['h05A], _r_mem['h059], _r_mem['h058] } = INIT_RAM_0B[127:  0];
                { _r_mem['h05F], _r_mem['h05E], _r_mem['h05D], _r_mem['h05C] } = INIT_RAM_0B[255:128];
                { _r_mem['h063], _r_mem['h062], _r_mem['h061], _r_mem['h060] } = INIT_RAM_0C[127:  0];
                { _r_mem['h067], _r_mem['h066], _r_mem['h065], _r_mem['h064] } = INIT_RAM_0C[255:128];
                { _r_mem['h06B], _r_mem['h06A], _r_mem['h069], _r_mem['h068] } = INIT_RAM_0D[127:  0];
                { _r_mem['h06F], _r_mem['h06E], _r_mem['h06D], _r_mem['h06C] } = INIT_RAM_0D[255:128];
                { _r_mem['h073], _r_mem['h072], _r_mem['h071], _r_mem['h070] } = INIT_RAM_0E[127:  0];
                { _r_mem['h077], _r_mem['h076], _r_mem['h075], _r_mem['h074] } = INIT_RAM_0E[255:128];
                { _r_mem['h07B], _r_mem['h07A], _r_mem['h079], _r_mem['h078] } = INIT_RAM_0F[127:  0];
                { _r_mem['h07F], _r_mem['h07E], _r_mem['h07D], _r_mem['h07C] } = INIT_RAM_0F[255:128];
                { _r_mem['h083], _r_mem['h082], _r_mem['h081], _r_mem['h080] } = INIT_RAM_10[127:  0];
                { _r_mem['h087], _r_mem['h086], _r_mem['h085], _r_mem['h084] } = INIT_RAM_10[255:128];
                { _r_mem['h08B], _r_mem['h08A], _r_mem['h089], _r_mem['h088] } = INIT_RAM_11[127:  0];
                { _r_mem['h08F], _r_mem['h08E], _r_mem['h08D], _r_mem['h08C] } = INIT_RAM_11[255:128];
                { _r_mem['h093], _r_mem['h092], _r_mem['h091], _r_mem['h090] } = INIT_RAM_12[127:  0];
                { _r_mem['h097], _r_mem['h096], _r_mem['h095], _r_mem['h094] } = INIT_RAM_12[255:128];
                { _r_mem['h09B], _r_mem['h09A], _r_mem['h099], _r_mem['h098] } = INIT_RAM_13[127:  0];
                { _r_mem['h09F], _r_mem['h09E], _r_mem['h09D], _r_mem['h09C] } = INIT_RAM_13[255:128];
                { _r_mem['h0A3], _r_mem['h0A2], _r_mem['h0A1], _r_mem['h0A0] } = INIT_RAM_14[127:  0];
                { _r_mem['h0A7], _r_mem['h0A6], _r_mem['h0A5], _r_mem['h0A4] } = INIT_RAM_14[255:128];
                { _r_mem['h0AB], _r_mem['h0AA], _r_mem['h0A9], _r_mem['h0A8] } = INIT_RAM_15[127:  0];
                { _r_mem['h0AF], _r_mem['h0AE], _r_mem['h0AD], _r_mem['h0AC] } = INIT_RAM_15[255:128];
                { _r_mem['h0B3], _r_mem['h0B2], _r_mem['h0B1], _r_mem['h0B0] } = INIT_RAM_16[127:  0];
                { _r_mem['h0B7], _r_mem['h0B6], _r_mem['h0B5], _r_mem['h0B4] } = INIT_RAM_16[255:128];
                { _r_mem['h0BB], _r_mem['h0BA], _r_mem['h0B9], _r_mem['h0B8] } = INIT_RAM_17[127:  0];
                { _r_mem['h0BF], _r_mem['h0BE], _r_mem['h0BD], _r_mem['h0BC] } = INIT_RAM_17[255:128];
                { _r_mem['h0C3], _r_mem['h0C2], _r_mem['h0C1], _r_mem['h0C0] } = INIT_RAM_18[127:  0];
                { _r_mem['h0C7], _r_mem['h0C6], _r_mem['h0C5], _r_mem['h0C4] } = INIT_RAM_18[255:128];
                { _r_mem['h0CB], _r_mem['h0CA], _r_mem['h0C9], _r_mem['h0C8] } = INIT_RAM_19[127:  0];
                { _r_mem['h0CF], _r_mem['h0CE], _r_mem['h0CD], _r_mem['h0CC] } = INIT_RAM_19[255:128];
                { _r_mem['h0D3], _r_mem['h0D2], _r_mem['h0D1], _r_mem['h0D0] } = INIT_RAM_1A[127:  0];
                { _r_mem['h0D7], _r_mem['h0D6], _r_mem['h0D5], _r_mem['h0D4] } = INIT_RAM_1A[255:128];
                { _r_mem['h0DB], _r_mem['h0DA], _r_mem['h0D9], _r_mem['h0D8] } = INIT_RAM_1B[127:  0];
                { _r_mem['h0DF], _r_mem['h0DE], _r_mem['h0DD], _r_mem['h0DC] } = INIT_RAM_1B[255:128];
                { _r_mem['h0E3], _r_mem['h0E2], _r_mem['h0E1], _r_mem['h0E0] } = INIT_RAM_1C[127:  0];
                { _r_mem['h0E7], _r_mem['h0E6], _r_mem['h0E5], _r_mem['h0E4] } = INIT_RAM_1C[255:128];
                { _r_mem['h0EB], _r_mem['h0EA], _r_mem['h0E9], _r_mem['h0E8] } = INIT_RAM_1D[127:  0];
                { _r_mem['h0EF], _r_mem['h0EE], _r_mem['h0ED], _r_mem['h0EC] } = INIT_RAM_1D[255:128];
                { _r_mem['h0F3], _r_mem['h0F2], _r_mem['h0F1], _r_mem['h0F0] } = INIT_RAM_1E[127:  0];
                { _r_mem['h0F7], _r_mem['h0F6], _r_mem['h0F5], _r_mem['h0F4] } = INIT_RAM_1E[255:128];
                { _r_mem['h0FB], _r_mem['h0FA], _r_mem['h0F9], _r_mem['h0F8] } = INIT_RAM_1F[127:  0];
                { _r_mem['h0FF], _r_mem['h0FE], _r_mem['h0FD], _r_mem['h0FC] } = INIT_RAM_1F[255:128];
                { _r_mem['h103], _r_mem['h102], _r_mem['h101], _r_mem['h100] } = INIT_RAM_20[127:  0];
                { _r_mem['h107], _r_mem['h106], _r_mem['h105], _r_mem['h104] } = INIT_RAM_20[255:128];
                { _r_mem['h10B], _r_mem['h10A], _r_mem['h109], _r_mem['h108] } = INIT_RAM_21[127:  0];
                { _r_mem['h10F], _r_mem['h10E], _r_mem['h10D], _r_mem['h10C] } = INIT_RAM_21[255:128];
                { _r_mem['h113], _r_mem['h112], _r_mem['h111], _r_mem['h110] } = INIT_RAM_22[127:  0];
                { _r_mem['h117], _r_mem['h116], _r_mem['h115], _r_mem['h114] } = INIT_RAM_22[255:128];
                { _r_mem['h11B], _r_mem['h11A], _r_mem['h119], _r_mem['h118] } = INIT_RAM_23[127:  0];
                { _r_mem['h11F], _r_mem['h11E], _r_mem['h11D], _r_mem['h11C] } = INIT_RAM_23[255:128];
                { _r_mem['h123], _r_mem['h122], _r_mem['h121], _r_mem['h120] } = INIT_RAM_24[127:  0];
                { _r_mem['h127], _r_mem['h126], _r_mem['h125], _r_mem['h124] } = INIT_RAM_24[255:128];
                { _r_mem['h12B], _r_mem['h12A], _r_mem['h129], _r_mem['h128] } = INIT_RAM_25[127:  0];
                { _r_mem['h12F], _r_mem['h12E], _r_mem['h12D], _r_mem['h12C] } = INIT_RAM_25[255:128];
                { _r_mem['h133], _r_mem['h132], _r_mem['h131], _r_mem['h130] } = INIT_RAM_26[127:  0];
                { _r_mem['h137], _r_mem['h136], _r_mem['h135], _r_mem['h134] } = INIT_RAM_26[255:128];
                { _r_mem['h13B], _r_mem['h13A], _r_mem['h139], _r_mem['h138] } = INIT_RAM_27[127:  0];
                { _r_mem['h13F], _r_mem['h13E], _r_mem['h13D], _r_mem['h13C] } = INIT_RAM_27[255:128];
                { _r_mem['h143], _r_mem['h142], _r_mem['h141], _r_mem['h140] } = INIT_RAM_28[127:  0];
                { _r_mem['h147], _r_mem['h146], _r_mem['h145], _r_mem['h144] } = INIT_RAM_28[255:128];
                { _r_mem['h14B], _r_mem['h14A], _r_mem['h149], _r_mem['h148] } = INIT_RAM_29[127:  0];
                { _r_mem['h14F], _r_mem['h14E], _r_mem['h14D], _r_mem['h14C] } = INIT_RAM_29[255:128];
                { _r_mem['h153], _r_mem['h152], _r_mem['h151], _r_mem['h150] } = INIT_RAM_2A[127:  0];
                { _r_mem['h157], _r_mem['h156], _r_mem['h155], _r_mem['h154] } = INIT_RAM_2A[255:128];
                { _r_mem['h15B], _r_mem['h15A], _r_mem['h159], _r_mem['h158] } = INIT_RAM_2B[127:  0];
                { _r_mem['h15F], _r_mem['h15E], _r_mem['h15D], _r_mem['h15C] } = INIT_RAM_2B[255:128];
                { _r_mem['h163], _r_mem['h162], _r_mem['h161], _r_mem['h160] } = INIT_RAM_2C[127:  0];
                { _r_mem['h167], _r_mem['h166], _r_mem['h165], _r_mem['h164] } = INIT_RAM_2C[255:128];
                { _r_mem['h16B], _r_mem['h16A], _r_mem['h169], _r_mem['h168] } = INIT_RAM_2D[127:  0];
                { _r_mem['h16F], _r_mem['h16E], _r_mem['h16D], _r_mem['h16C] } = INIT_RAM_2D[255:128];
                { _r_mem['h173], _r_mem['h172], _r_mem['h171], _r_mem['h170] } = INIT_RAM_2E[127:  0];
                { _r_mem['h177], _r_mem['h176], _r_mem['h175], _r_mem['h174] } = INIT_RAM_2E[255:128];
                { _r_mem['h17B], _r_mem['h17A], _r_mem['h179], _r_mem['h178] } = INIT_RAM_2F[127:  0];
                { _r_mem['h17F], _r_mem['h17E], _r_mem['h17D], _r_mem['h17C] } = INIT_RAM_2F[255:128];
                { _r_mem['h183], _r_mem['h182], _r_mem['h181], _r_mem['h180] } = INIT_RAM_30[127:  0];
                { _r_mem['h187], _r_mem['h186], _r_mem['h185], _r_mem['h184] } = INIT_RAM_30[255:128];
                { _r_mem['h18B], _r_mem['h18A], _r_mem['h189], _r_mem['h188] } = INIT_RAM_31[127:  0];
                { _r_mem['h18F], _r_mem['h18E], _r_mem['h18D], _r_mem['h18C] } = INIT_RAM_31[255:128];
                { _r_mem['h193], _r_mem['h192], _r_mem['h191], _r_mem['h190] } = INIT_RAM_32[127:  0];
                { _r_mem['h197], _r_mem['h196], _r_mem['h195], _r_mem['h194] } = INIT_RAM_32[255:128];
                { _r_mem['h19B], _r_mem['h19A], _r_mem['h199], _r_mem['h198] } = INIT_RAM_33[127:  0];
                { _r_mem['h19F], _r_mem['h19E], _r_mem['h19D], _r_mem['h19C] } = INIT_RAM_33[255:128];
                { _r_mem['h1A3], _r_mem['h1A2], _r_mem['h1A1], _r_mem['h1A0] } = INIT_RAM_34[127:  0];
                { _r_mem['h1A7], _r_mem['h1A6], _r_mem['h1A5], _r_mem['h1A4] } = INIT_RAM_34[255:128];
                { _r_mem['h1AB], _r_mem['h1AA], _r_mem['h1A9], _r_mem['h1A8] } = INIT_RAM_35[127:  0];
                { _r_mem['h1AF], _r_mem['h1AE], _r_mem['h1AD], _r_mem['h1AC] } = INIT_RAM_35[255:128];
                { _r_mem['h1B3], _r_mem['h1B2], _r_mem['h1B1], _r_mem['h1B0] } = INIT_RAM_36[127:  0];
                { _r_mem['h1B7], _r_mem['h1B6], _r_mem['h1B5], _r_mem['h1B4] } = INIT_RAM_36[255:128];
                { _r_mem['h1BB], _r_mem['h1BA], _r_mem['h1B9], _r_mem['h1B8] } = INIT_RAM_37[127:  0];
                { _r_mem['h1BF], _r_mem['h1BE], _r_mem['h1BD], _r_mem['h1BC] } = INIT_RAM_37[255:128];
                { _r_mem['h1C3], _r_mem['h1C2], _r_mem['h1C1], _r_mem['h1C0] } = INIT_RAM_38[127:  0];
                { _r_mem['h1C7], _r_mem['h1C6], _r_mem['h1C5], _r_mem['h1C4] } = INIT_RAM_38[255:128];
                { _r_mem['h1CB], _r_mem['h1CA], _r_mem['h1C9], _r_mem['h1C8] } = INIT_RAM_39[127:  0];
                { _r_mem['h1CF], _r_mem['h1CE], _r_mem['h1CD], _r_mem['h1CC] } = INIT_RAM_39[255:128];
                { _r_mem['h1D3], _r_mem['h1D2], _r_mem['h1D1], _r_mem['h1D0] } = INIT_RAM_3A[127:  0];
                { _r_mem['h1D7], _r_mem['h1D6], _r_mem['h1D5], _r_mem['h1D4] } = INIT_RAM_3A[255:128];
                { _r_mem['h1DB], _r_mem['h1DA], _r_mem['h1D9], _r_mem['h1D8] } = INIT_RAM_3B[127:  0];
                { _r_mem['h1DF], _r_mem['h1DE], _r_mem['h1DD], _r_mem['h1DC] } = INIT_RAM_3B[255:128];
                { _r_mem['h1E3], _r_mem['h1E2], _r_mem['h1E1], _r_mem['h1E0] } = INIT_RAM_3C[127:  0];
                { _r_mem['h1E7], _r_mem['h1E6], _r_mem['h1E5], _r_mem['h1E4] } = INIT_RAM_3C[255:128];
                { _r_mem['h1EB], _r_mem['h1EA], _r_mem['h1E9], _r_mem['h1E8] } = INIT_RAM_3D[127:  0];
                { _r_mem['h1EF], _r_mem['h1EE], _r_mem['h1ED], _r_mem['h1EC] } = INIT_RAM_3D[255:128];
                { _r_mem['h1F3], _r_mem['h1F2], _r_mem['h1F1], _r_mem['h1F0] } = INIT_RAM_3E[127:  0];
                { _r_mem['h1F7], _r_mem['h1F6], _r_mem['h1F5], _r_mem['h1F4] } = INIT_RAM_3E[255:128];
                { _r_mem['h1FB], _r_mem['h1FA], _r_mem['h1F9], _r_mem['h1F8] } = INIT_RAM_3F[127:  0];
                { _r_mem['h1FF], _r_mem['h1FE], _r_mem['h1FD], _r_mem['h1FC] } = INIT_RAM_3F[255:128];
            end
        end
        else begin : GEN_VERILOG_INIT
            initial begin : BRAM_INIT_VERILOG
                integer _i;
                
                // First, clear array
                for (_i = 0; _i < 512; _i = _i + 1) begin
                    _r_mem[_i] = 32'h0;
                end
                // Simple .mem file (always mapped as a 512 x 32-bit hexadecimal dump)
                $readmemh(INIT_FILE, _r_mem);
            end
        end
    endgenerate
    
    // Reset type (RESETA not used)
    wire _w_ARST = (RESET_MODE == "ASYNC") ? RESETB : 1'b0;
    wire _w_SRST = (RESET_MODE == "SYNC" ) ? RESETB : 1'b0;
    
    // Block RAM select
    wire _w_BSA = (BLKSEL == BLK_SEL) ? CEA : 1'b0;
    wire _w_BSB = (BLKSEL == BLK_SEL) ? CEB : 1'b0;

    // Block RAM write
    always @(posedge CLKA) begin : BRAM_WRITE

        // Block RAM selected with write enable
        if (_w_BSA & WREA) begin
            case (BIT_WIDTH_0)
                // 1-bit block RAM
                 1: _r_mem[ADA[13:5]][ADA[4:0]            +: 1] <= DI[  0];
                // 2-bit block RAM
                 2: _r_mem[ADA[13:5]][ADA[4:0] & 5'b11110 +: 2] <= DI[1:0];
                // 4-bit block RAM
                 4: _r_mem[ADA[13:5]][ADA[4:0] & 5'b11100 +: 4] <= DI[3:0];
                // 8-bit block RAM
                 8: _r_mem[ADA[13:5]][ADA[4:0] & 5'b11000 +: 8] <= DI[7:0];
                // 16-bit block RAM with write enables
                16: begin
                    if (ADA[0]) _r_mem[ADA[13:5]][(ADA[4] ? 16 : 0) +: 8] <= DI[ 7:0];
                    if (ADA[1]) _r_mem[ADA[13:5]][(ADA[4] ? 24 : 8) +: 8] <= DI[15:8];
                end
                // 32-bit block RAM with write enables
                32: begin
                    if (ADA[0]) _r_mem[ADA[13:5]][ 0 +: 8] <= DI[ 7: 0];
                    if (ADA[1]) _r_mem[ADA[13:5]][ 8 +: 8] <= DI[15: 8];
                    if (ADA[2]) _r_mem[ADA[13:5]][16 +: 8] <= DI[23:16];
                    if (ADA[3]) _r_mem[ADA[13:5]][24 +: 8] <= DI[31:24];
                end
                // Undefined width
                default: ;
            endcase
        end
    end
    
    reg [31:0] _r_dout_p1;

    // Block RAM read
    always @(posedge CLKB or posedge _w_ARST) begin : BRAM_READ_P1
    
        // Asynchronous reset
        if (_w_ARST) begin
            _r_dout_p1 <= 32'b0;
        end
        // Synchronous reset
        else if (_w_SRST) begin
            _r_dout_p1 <= 32'b0;
        end
        // Block RAM selected
        else if (_w_BSB) begin
            // Read enable
            if (!WREB) begin
                case (BIT_WIDTH_1)
                    // 1-bit block RAM
                     1: _r_dout_p1 <= { 31'b0, _r_mem[ADB[13:5]][ADB[4:0]            +: 1] };
                    // 2-bit block RAM
                     2: _r_dout_p1 <= { 30'b0, _r_mem[ADB[13:5]][ADB[4:0] & 5'b11110 +: 2] };
                    // 4-bit block RAM
                     4: _r_dout_p1 <= { 28'b0, _r_mem[ADB[13:5]][ADB[4:0] & 5'b11100 +: 4] };
                    // 8-bit block RAM
                     8: _r_dout_p1 <= { 24'b0, _r_mem[ADB[13:5]][ADB[4:0] & 5'b11000 +: 8] };
                    // 16-bit block RAM
                    16: _r_dout_p1 <= { 16'b0, _r_mem[ADB[13:5]][ADB[4:0] & 5'b10000 +: 16] };
                    // 32-bit block RAM
                    32: _r_dout_p1 <= _r_mem[ADB[13:5]];
                    // Undefined width
                    default: _r_dout_p1 <= 32'b0;
                endcase
            end
        end
    end

    reg [31:0] _r_dout_p2;

    // Pipelined register
    always @(posedge CLKB or posedge _w_ARST) begin : BRAM_READ_P2

        // Asynchronous reset
        if (_w_ARST) begin
            _r_dout_p2 <= 32'b0;
        end
        // Synchronous reset
        else if (_w_SRST) begin
            _r_dout_p2 <= 32'b0;
        end
        // Output clock enable
        else if (OCE) begin
            _r_dout_p2 <= _r_dout_p1;
        end
    end

    assign DO = (READ_MODE) ? _r_dout_p2 : _r_dout_p1;

endmodule
