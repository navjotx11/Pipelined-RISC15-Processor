module incrementer(in, out,reset);

	output [15:0] out;
	input  [15:0] in;
	input reset;
	
	assign out = (reset==0)?in:in + 16'd1;

endmodule