module CZ_reg(clk, out, in, write, reset);

	output reg [1:0] out;
	
	input      [1:0] in;
	input      clk, write, reset;
	
	reg [1:0]indata;
	reg inwrite;
	
	always @(negedge clk)
		begin
			indata = in;
			inwrite = write;
		end
	always@(posedge clk) begin
		
		if(reset==0) 
			begin
				out = 2'b0;
			end
		else if(inwrite == 1'b0) 
			begin
				out = indata;
			end
		end

endmodule