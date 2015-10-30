module reg1_0(clk, out, in, write, reset);  // Negedge-triggered flipflop register with active-low write signal and reset

	output reg out;
	input      in;
	input      clk, write, reset;
	reg indata;
	always @(negedge clk)
	indata = in;
	always@(posedge clk) begin
		if(reset==0) begin
			out = 1'b0;
		end
		else if(write == 1'b0) begin
			out = indata;
		end
	end
	
endmodule