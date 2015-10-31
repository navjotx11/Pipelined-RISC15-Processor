module pipeline_register6 (clk,reset,toIR, IR, toRF_value, RF_value,toCCRWrite,CCRWrite);
	
	input clk,reset,toCCRWrite;
	input [15:0] toIR,toRF_value;

	output [15:0] IR, RF_value;
	output CCRWrite;

	reg16_NOP   __IR_reg(.clk(clk), .out(IR), .in(toIR), .write(1'b0), .reset(reset));
	reg16 		__RF_value_reg (.clk(clk),.out(RF_value),.in(toRF_value),.write(1'b0),.reset(reset));
	reg1_1 		__CCRWrite_reg(.clk(clk),.reset(reset),.out(CCRWrite),.in(toCCRWrite), .write(1'b0));

endmodule