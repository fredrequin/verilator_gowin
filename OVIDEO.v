`ifdef verilator3
`else
`timescale 1 ps / 1 ps
`endif
//
// OVIDEO primitive for Gowin FPGAs
// Compatible with Verilator tool (www.veripool.org)
// Copyright (c) 2022 Frédéric REQUIN
// License : BSD
//

module OVIDEO
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
    input  D0, D1, D2, D3, D4, D5, D6,
    output Q
);
    wire      _w_rst = (LSREN == "true") ? RESET : 1'b0;

    reg       _r_rstn_cnt;
    reg [2:0] _r_data_cnt;

    reg       _r_data_upd_p1;
    reg       _r_data_upd_p2;

    reg [6:0] _r_D_p1;
    
    reg [7:0] _r_D_p2;
    
    reg [7:0] _r_D_p3;
    
    reg       _r_Qp;
    reg       _r_Qn;

    initial begin
        _r_rstn_cnt    = 1'b0;
        _r_data_cnt    = 3'd0;

        _r_data_upd_p1 = 1'b0;
        _r_data_upd_p2 = 1'b0;

        _r_D_p1        = 7'b0000000;
        
        _r_D_p2        = 8'b00000000;
        
        _r_D_p3        = 8'b00000000;
        
        _r_Qp          = 1'b0;
        _r_Qn          = 1'b0;
    end

    always @(posedge _w_rst or posedge FCLK) begin : DATA_CNT_RESET

        if (_w_rst) begin
            _r_rstn_cnt <= 1'b0;
        end
        else begin
            _r_rstn_cnt <= 1'b1;
        end
    end

    always @(negedge _r_rstn_cnt or posedge FCLK) begin : DATA_COUNT

        if (!_r_rstn_cnt) begin
            _r_data_cnt <= 3'd0;
        end
        else begin
            _r_data_cnt <= (_r_data_cnt == 3'd6) ? 3'd0 : _r_data_cnt + 3'd1;
        end
    end

    always @(negedge _r_rstn_cnt or posedge FCLK) begin : DATA_UPDATE_P1_P2

        if (!_r_rstn_cnt) begin
            _r_data_upd_p1 <= 1'b0;
            _r_data_upd_p2 <= 1'b0;
        end
        else begin
            _r_data_upd_p1 <= (_r_data_cnt == 3'd1) || (_r_data_cnt == 3'd4) ? 1'b1 : 1'b0;
            _r_data_upd_p2 <= (_r_data_cnt == 3'd2) || (_r_data_cnt == 3'd5) ? 1'b1 : 1'b0;
        end
    end

    always @(posedge _w_rst or posedge PCLK) begin : POS_EDGE_P1
    
        if (_w_rst) begin
            _r_D_p1 <= 7'b0000000;
        end
        else begin
            _r_D_p1 <= { D6, D5, D4, D3, D2, D1, D0 };
        end
    end

    always @(posedge _w_rst or posedge FCLK) begin : POS_EDGE_P2
    
        if (_w_rst) begin
            _r_D_p2 <= 8'b00000000;
        end
        else if (_r_data_upd_p1) begin
            if (_r_data_cnt[2]) begin
                _r_D_p2 <= { _r_D_p1, _r_D_p2[6] };
            end
            else begin
                _r_D_p2 <= { 1'b0, _r_D_p1 };
            end
        end
    end

    always @(posedge _w_rst or posedge FCLK) begin : POS_EDGE_P3
    
        if (_w_rst) begin
            _r_D_p3 <= 8'b00000000;
        end
        else begin
            if (_r_data_upd_p2) begin
                _r_D_p3 <= _r_D_p2;
            end
            else begin
                _r_D_p3 <= { 2'b0, _r_D_p3[7:2] };
            end
        end
    end

    always @(posedge _w_rst or negedge FCLK) begin : OUT_NEG_EDGE
    
        if (_w_rst) begin
            _r_Qn <= 1'b0;
        end
        else begin
            _r_Qn <= _r_D_p3[0];
        end
    end

    always @(posedge _w_rst or posedge FCLK) begin : OUT_POS_EDGE
    
        if (_w_rst) begin
            _r_Qp <= 1'b0;
        end
        else begin
            _r_Qp <= _r_D_p3[1];
        end
    end

    assign Q = (FCLK) ? _r_Qn : _r_Qp;

endmodule
