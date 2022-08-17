`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// OSER4 primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module OSER4
#(
    parameter string GSREN     = "false",
    parameter string LSREN     = "true",
    parameter string HWL       = "false",
    parameter        TXCLK_POL = 1'b0
)
(
    input  RESET,
    input  PCLK,
    input  FCLK,
    input  D0, D1, D2, D3,
    input  TX0, TX1,
    output Q0,
    output Q1
);
    wire      _w_rst = (LSREN == "true") ? RESET : 1'b0;

    reg       _r_rstn_sel;
    reg       _r_data_sel;

    reg       _r_data_upd_p1;
    reg       _r_data_upd_p2;

    reg [3:0] _r_D_p1;
    reg [1:0] _r_T_p1;
    
    reg [3:0] _r_D_p2;
    reg [1:0] _r_T_p2;
    
    reg [3:0] _r_D_p3;
    reg [1:0] _r_T_p3;
    
    reg       _r_Qp;
    reg       _r_Qn;

    reg       _r_Tp;
    reg       _r_Tn;

    initial begin
        _r_rstn_sel    = 1'b0;
        _r_data_sel    = 1'b0;

        _r_data_upd_p1 = 1'b0;
        _r_data_upd_p2 = 1'b0;

        _r_D_p1        = 4'b0000;
        _r_T_p1        = 2'b00;
        
        _r_D_p2        = 4'b0000;
        _r_T_p2        = 2'b00;
        
        _r_D_p3        = 4'b0000;
        _r_T_p3        = 2'b00;
        
        _r_Qp          = 1'b0;
        _r_Qn          = 1'b0;
        
        _r_Tp          = 1'b0;
        _r_Tn          = 1'b0;
    end

    always @(posedge _w_rst or posedge FCLK) begin : DATA_SEL_RESET

        if (_w_rst) begin
            _r_rstn_sel <= 1'b0;
        end
        else begin
            _r_rstn_sel <= 1'b1;
        end
    end

    always @(negedge _r_rstn_sel or posedge FCLK) begin : DATA_SEL_TOGGLE

        if (!_r_rstn_sel) begin
            _r_data_sel <= 1'b0;
        end
        else begin
            _r_data_sel <= ~_r_data_sel;
        end
    end

    always @(negedge _r_rstn_sel or posedge FCLK) begin : DATA_UPDATE_P1_P2

        if (!_r_rstn_sel) begin
            _r_data_upd_p1 <= 1'b0;
            _r_data_upd_p2 <= 1'b0;
        end
        else begin
            _r_data_upd_p1 <= ~_r_data_sel;
            _r_data_upd_p2 <= (HWL == "true") ? ~_r_data_sel : _r_data_sel;
        end
    end

    always @(posedge _w_rst or posedge PCLK) begin : POS_EDGE_P1
    
        if (_w_rst) begin
            _r_D_p1 <= 4'b0000;
            _r_T_p1 <= 2'b00;
        end
        else begin
            _r_D_p1 <= { D3, D2, D1, D0 };
            _r_T_p1 <= { TX1, TX0 };
        end
    end

    always @(posedge _w_rst or posedge FCLK) begin : POS_EDGE_P2
    
        if (_w_rst) begin
            _r_D_p2 <= 4'b0000;
            _r_T_p2 <= 2'b00;
        end
        else if (_r_data_upd_p1) begin
            _r_D_p2 <= _r_D_p1;
            _r_T_p2 <= _r_T_p1;
        end
    end

    always @(posedge _w_rst or posedge FCLK) begin : POS_EDGE_P3
    
        if (_w_rst) begin
            _r_D_p3 <= 4'b0000;
            _r_T_p3 <= 2'b00;
        end
        else begin
            if (_r_data_upd_p2) begin
                _r_D_p3 <= _r_D_p2;
                _r_T_p3 <= _r_T_p2;
            end
            else begin
                _r_D_p3 <= { 2'b0, _r_D_p3[3:2] };
                _r_T_p3 <= { 1'b0, _r_T_p3[1] };
            end
        end
    end

    always @(posedge _w_rst or negedge FCLK) begin : OUT_NEG_EDGE
    
        if (_w_rst) begin
            _r_Qn <= 1'b0;
            _r_Tn <= 1'b0;
        end
        else begin
            _r_Qn <= _r_D_p3[0];
            _r_Tn <= _r_T_p3[0];
        end
    end

    always @(posedge _w_rst or posedge FCLK) begin : OUT_POS_EDGE
    
        if (_w_rst) begin
            _r_Qp <= 1'b0;
            _r_Tp <= 1'b0;
        end
        else begin
            _r_Qp <= _r_D_p3[1];
            _r_Tp <= _r_Tn;
        end
    end

    assign Q0 = (FCLK     ) ? _r_Qn : _r_Qp;
    assign Q1 = (TXCLK_POL) ? _r_Tn : _r_Tp;

endmodule
