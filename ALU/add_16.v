module add_16(in1, in2 , out,clk);

	output  [15:0]  out;

	input clk;
	input  [15:0] in1, in2;
	
	assign out = in1+in2;
	
endmodule