module PC_reg(clk, out, in, write, reset);

output reg [15:0] out;
	input      [15:0] in;
	input      clk, write, reset;
	reg [15:0]indata;
	reg inwrite;
	
	always @(negedge clk)
	begin
	indata = in;
	inwrite = write;
	end
	always@(posedge clk) begin
		if(reset==0) begin
			out = 16'b0;
		end
		else if(inwrite == 1'b0) begin
			out = indata;
		end
	end


endmodule