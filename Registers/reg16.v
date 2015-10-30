module reg16(clk, out, in, write, reset);  // Negedge-triggered flipflop register with active-low write signal and reset

	output reg [15:0] out;
	input      [15:0] in;
	input      clk, write, reset;
	reg [15:0]indata;
	always @(negedge clk)
	indata = in;
	always@(posedge clk) begin
		if(reset==0) begin
			out = 16'b0;
		end
		else if(write == 1'b0) begin
			out = indata;
		end
	end
	
endmodule