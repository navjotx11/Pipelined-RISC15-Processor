module reg3(clk, out, in, write, reset);  // Negedge-triggered flipflop register with active-low write signal and reset

	output reg [2:0] out;
	input      [2:0] in;
	input      clk, write, reset;
	reg [2:0]indata;
	always @(negedge clk)
	indata = in;
	always@(posedge clk) begin
		if(reset==0) begin
			out = 3'b0;
		end
		else if(write == 1'b0) begin
			out = indata;
		end
	end
	
endmodule