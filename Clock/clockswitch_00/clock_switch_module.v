module clock_switc_module(
	input	wire			rst_n         , //
	input	wire			clka          , //
	input	wire			clkb          , //
	input	wire			sel_clkb      , //
	input	wire			clk_o           //
);

//`define USE_GATE_CELL


`ifdef USE_GATE_CELL
	`define CLK_EDGE posedge
`else
	`define CLK_EDGE negedge
`endif

reg			sel_clka_d0		;
reg			sel_clka_d1		;
reg			sel_clka_dly1	;
reg			sel_clka_dly2	;
reg			sel_clka_dly3	;
reg			sel_clkb_d0		;
reg			sel_clkb_d1		;
reg			sel_clkb_dly1	;
reg			sel_clkb_dly2	;
reg			sel_clkb_dly3	;
wire		clka_g			;
wire		clkb_g			;


// part1
always @ (`CLK_EDGE clka or negedge rst_n) begin
    if (!rst_n) begin
        sel_clka_d0 <= 1'b0;
        sel_clka_d1 <= 1'b0;
    end
    else begin
        sel_clka_d0 <= (~sel_clkb) & (~sel_clkb_dly3) ;
        sel_clka_d1 <= sel_clka_d0 ;
    end
end

// part2
always @ (`CLK_EDGE clka or negedge rst_n) begin
    if (!rst_n) begin
        sel_clka_dly1 <= 1'b0;
        sel_clka_dly2 <= 1'b0;
        sel_clka_dly3 <= 1'b0;
    end
    else begin
        sel_clka_dly1 <= sel_clka_d1;
        sel_clka_dly2 <= sel_clka_dly1 ;
        sel_clka_dly3 <= sel_clka_dly2 ;
    end
end

// part3
always @ (posedge clkb_n or negedge rst_n)
always @ (`CLK_EDGE clkb or negedge rst_n) begin
    if (!rst_n) begin
        sel_clkb_d0 <= 1'b0;
        sel_clkb_d1 <= 1'b0;
    end
    else begin
        sel_clkb_d0 <= sel_clkb & (~sel_clka_dly3) ;
        sel_clkb_d1 <= sel_clkb_d0 ;
    end
end

// part4
always @ (`CLK_EDGE clkb or negedge rst_n) begin
    if (!rst_n) begin
        sel_clkb_dly1 <= 1'b0;
        sel_clkb_dly2 <= 1'b0;
        sel_clkb_dly3 <= 1'b0;
    end
    else begin
        sel_clkb_dly1 <= sel_clkb_d1   ;
        sel_clkb_dly2 <= sel_clkb_dly1 ;
        sel_clkb_dly3 <= sel_clkb_dly2 ;
    end
end

// part5
`ifdef USE_GATE_CELL
clk_gate_xxx clk_gate_a ( .CP(clka), .EN(sel_clka_dly1), .Q(clka_g)  .TE(1'b0) );
clk_gate_xxx clk_gate_b ( .CP(clkb), .EN(sel_clkb_dly1), .Q(clkb_g)  .TE(1'b0) );
`else
assign clka_g = clka & sel_clka_dly1 ;
assign clkb_g = clkb & sel_clkb_dly1 ;
`endif
assign clk_o = clka_g | clkb_g ;

endmodule