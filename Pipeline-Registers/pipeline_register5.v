module pipeline_register5(clk, reset, toCCR, toCCRWrite, toMemData, toWriteRF, toImm970s, toPCImmInc, toALUOut, toPCInc, toWriteAdd, toWriteR7,
			 				toRegWriteSelect, toR7WriteSelect,CCR, CCRWrite, MemData, WriteRF, Imm970s, PCImmInc, ALUOut, PCInc, WriteAdd, WriteR7,
			 				 RegWriteSelect, R7WriteSelect,toIR,IR,RFOut2, toRFOut2);
			
	output [15:0] 	MemData, Imm970s, PCImmInc, ALUOut, PCInc,IR, RFOut2;
	output [2:0] 	WriteAdd;
	output [2:0] 	R7WriteSelect;
	output [1:0] 	CCR, RegWriteSelect;
	output          CCRWrite, WriteRF, WriteR7;
	
	input [15:0]  toMemData, toImm970s, toPCImmInc, toALUOut, toPCInc,toIR, toRFOut2;
	input [2:0]   toWriteAdd;
	input [2:0]   toR7WriteSelect;
	input [1:0]   toCCR, toRegWriteSelect;
	input         toCCRWrite, toWriteRF, toWriteR7, clk, reset;
	
	reg16 		__MemDataReg(.clk(clk), .out(MemData), .in(toMemData), .write(1'b0), .reset(reset));
	reg16 		__Imm970Reg(.clk(clk), .out(Imm970s), .in(toImm970s), .write(1'b0), .reset(reset));
	reg16 		__PCImmIncReg(.clk(clk), .out(PCImmInc), .in(toPCImmInc), .write(1'b0), .reset(reset));
	reg16 		__ALUOutReg(.clk(clk), .out(ALUOut), .in(toALUOut), .write(1'b0), .reset(reset));
	reg16 		__PCIncReg(.clk(clk), .out(PCInc), .in(toPCInc), .write(1'b0), .reset(reset));
	reg16_NOP 	__IR_Reg(.clk(clk), .out(IR), .in(toIR), .write(1'b0), .reset(reset));
	reg16 		__RFOut2_Reg(.clk(clk), .out(RFOut2), .in(toRFOut2), .write(1'b0), .reset(reset));
	
	reg3  	__WriteAddReg(.clk(clk), .out(WriteAdd), .in(toWriteAdd), .write(1'b0), .reset(reset));
	reg3  	__R7WriteSelectReg(.clk(clk), .out(R7WriteSelect), .in(toR7WriteSelect), .write(1'b0), .reset(reset));
	reg2  	__RegWriteSelectReg(.clk(clk), .out(RegWriteSelect), .in(toRegWriteSelect), .write(1'b0), .reset(reset));
	reg2  	__CCRReg(.clk(clk), .out(CCR), .in(toCCR), .write(1'b0), .reset(reset));
	reg1_1  __CCRWriteReg(.clk(clk), .out(CCRWrite), .in(toCCRWrite), .write(1'b0), .reset(reset));
	reg1_1  __WriteRFReg(.clk(clk), .out(WriteRF), .in(toWriteRF), .write(1'b0), .reset(reset));
	reg1_1  __WriteR7Reg(.clk(clk), .out(WriteR7), .in(toWriteR7), .write(1'b0), .reset(reset));

endmodule