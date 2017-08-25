module clock_switc_module_tb();

	reg			rst_n         ;
	reg			clka          ;
	reg			clkb          ;
	reg			sel_clkb      ;
	wire		clk_o         ;

clock_switc_module clock_switc_module(
	.rst_n   	(rst_n   	), //
	.clka    	(clka    	), //
	.clkb    	(clkb    	), //
	.sel_clkb	(sel_clkb	), //
	.clk_o   	(clk_o   	)  //
);

initial begin
	rst_n = 1'b0;
	clka  = 1'b0;
	clkb  = 1'b0;
	sel   = 1'b0;
	#100;
	rst_n = 1'b1;
	#1000;
	sel   = 1'b1;
	#1350;
	sel   = 1'b0;	
end

always begin
	#18 clka = ~clka;
end
always begin
	#66 clkb = ~clkb;
end
endmodule