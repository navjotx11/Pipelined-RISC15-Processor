module pipeline_register1(clk, reset, toPCInc, toPC, toIR, PCInc, PC, IR,flush,IR_write); // First pipeline register
	
	output [15:0] PCInc, PC, IR;
	input  [15:0] toPCInc, toPC, toIR;
	input	      reset, clk;
	input flush,IR_write;
	wire [15:0]inIR;
	
	assign inIR = (flush==1'b1)?16'b1111000000000000:toIR;//introduce a NOP, in the event of a flush
	reg16 pipe1IncPC(.clk(clk), .out(PCInc), .in(toPCInc), .write(1'b0), .reset(reset));
	reg16 pipe1PC(.clk(clk), .out(PC), .in(toPC), .write(1'b0), .reset(reset));
	reg16_NOP pipe1IR(.clk(clk), .out(IR), .in(inIR), .write(IR_write), .reset(reset));
	
endmodule