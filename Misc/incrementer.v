module incrementer(in, out, reset);

	input reset;
	input  [15:0] in;
	output [15:0] out;
	
	assign out = (reset==0)?in:in + 16'd1;

endmodule