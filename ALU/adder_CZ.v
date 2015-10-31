module adder_CZ(in1, in2 , out, carry);
	
	output [15:0] out;
	output        carry;
	
	input  [15:0] in1, in2;
	
	wire   [16:0] outTemp;

	assign outTemp = in1 + in2;
	assign out     = outTemp[15:0];
	assign carry   = outTemp[16];
	
endmodule