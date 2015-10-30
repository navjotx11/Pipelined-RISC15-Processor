module fetch(IR_load_mux,new_IR_multi,equ,pr2_IR ,pr3_IR ,pr4_IR, pr5_IR,fromPipe2_PCim, fromPipe2_970, fromPipe3RFOut, fromPipe3PCInc, 
fromPipe4_Aluout, fromPipe5Mem, PCWrite, PCOut, IROut, incPCOut, clk, reset);

	output [15:0] PCOut, IROut, incPCOut;
	input [15:0]new_IR_multi;
	wire [15:0] next_IR;//read from instruction memory
	input IR_load_mux;
	input  [15:0] fromPipe2_PCim, fromPipe2_970, fromPipe3RFOut, fromPipe3PCInc, fromPipe4_Aluout, fromPipe5Mem;
	input [15:0] pr2_IR ,pr3_IR ,pr4_IR, pr5_IR;
	wire  [ 2:0] fromForwarding;
	input         PCWrite, clk, reset;
	input equ;
	wire   [15:0] PCWriteWire;
	forwarding f_u(.clk(clk),.equ(equ),.pr2_IR(pr2_IR),.pr3_IR(pr3_IR),.pr4_IR(pr4_IR),.pr5_IR(pr5_IR),.pc_mux_select(fromForwarding))	;
	mux_16_8 PCWriteSelect(.data0(incPCOut), .data1(fromPipe3RFOut), .data2(fromPipe5Mem), .data3(fromPipe2_PCim), .data4(fromPipe3PCInc), 
	.data5(fromPipe2_970), .data6(fromPipe4_Aluout), .data7(16'b0), .selectInput(fromForwarding), .out(PCWriteWire));
	PC_reg PCReg(.clk(clk), .out(PCOut), .in(PCWriteWire), .write(PCWrite), .reset(reset));
	incrementer PlusOne(.in(PCOut), .out(incPCOut),.reset(reset));
	instruction_memory InstructionMemory(.readAdd(PCOut), .out(next_IR),.clk(clk),.reset(reset));
	mux_16_2 IR_write_select(.data0(next_IR), .data1(new_IR_multi), .selectInput(IR_load_mux), .out(IROut));
endmodule