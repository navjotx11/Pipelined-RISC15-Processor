module pipeline_register4(	clk, reset, toCCR, toCCRWrite, toWriteRF, toImm970s, toPCImmInc, toALUOut, toPCInc, toWriteAdd, toWriteR7, toRegWriteSelect, toR7WriteSelect, 
	                        toWriteMem, toRFOut1,toRFOut2, toRAOut,CCR, CCRWrite, WriteRF, Imm970s, PCImmInc, ALUOut, PCInc, WriteAdd, WriteR7, RegWriteSelect, R7WriteSelect, 
	                        WriteMem, RFOut1,RFOut2, RAOut,toIR,IR,MemdataSelectInput,toMemdataSelectInput, RAMemSelectInput, toRAMemSelectInput, WAMemSelectInput,
	                        toWAMemSelectInput);

	output [15:0] Imm970s, PCImmInc, ALUOut, PCInc, RFOut1, RFOut2, RAOut,IR;
	output [2:0]  WriteAdd;
	output [2:0]  R7WriteSelect;
	output [1:0]  CCR, RegWriteSelect;
	output        CCRWrite, WriteRF, WriteR7, WriteMem, RAMemSelectInput, WAMemSelectInput, MemdataSelectInput;
	
	input [15:0]  toImm970s, toPCImmInc, toALUOut, toPCInc, toRFOut1, toRFOut2, toRAOut,toIR;
	input [2:0]   toWriteAdd;
	input [2:0]   toR7WriteSelect;
	input [1:0]   toCCR, toRegWriteSelect;
	input         toCCRWrite, toWriteRF, toWriteR7, toWriteMem, toRAMemSelectInput, toWAMemSelectInput, clk, reset, toMemdataSelectInput;

	reg16 		__Imm970Reg(.clk(clk), .out(Imm970s), .in(toImm970s), .write(1'b0), .reset(reset));
	reg16 		__PCImmIncReg(.clk(clk), .out(PCImmInc), .in(toPCImmInc), .write(1'b0), .reset(reset));
	reg16 		__ALUOutReg(.clk(clk), .out(ALUOut), .in(toALUOut), .write(1'b0), .reset(reset));
	reg16 		__PCIncReg(.clk(clk), .out(PCInc), .in(toPCInc), .write(1'b0), .reset(reset));
	reg16 		__RAReg(.clk(clk), .out(RAOut), .in(toRAOut), .write(1'b0), .reset(reset));
	reg16 		__RfOut1_Reg(.clk(clk), .out(RFOut1), .in(toRFOut1), .write(1'b0), .reset(reset));
	reg16 		__RfOut2_Reg(.clk(clk), .out(RFOut2), .in(toRFOut2), .write(1'b0), .reset(reset));
	reg16_NOP 	__IR_Reg(.clk(clk), .out(IR), .in(toIR), .write(1'b0), .reset(reset));
	reg1_0  	__MemdataSelect(.clk(clk), .out(MemdataSelectInput), .in(toMemdataSelectInput), .write(1'b0), .reset(reset));
	
	
	reg3    __WriteAddReg(.clk(clk), .out(WriteAdd), .in(toWriteAdd), .write(1'b0), .reset(reset));
	
	reg3 	__R7WriteSelectReg(.clk(clk), .out(R7WriteSelect), .in(toR7WriteSelect), .write(1'b0), .reset(reset));
	reg2  	__RegWriteSelectReg(.clk(clk), .out(RegWriteSelect), .in(toRegWriteSelect), .write(1'b0), .reset(reset));
	reg2  	__CCRReg(.clk(clk), .out(CCR), .in(toCCR), .write(1'b0), .reset(reset));
	
	reg1_1  __CCRWriteReg(.clk(clk), .out(CCRWrite), .in(toCCRWrite), .write(1'b0), .reset(reset));
	reg1_1  __WriteRFReg(.clk(clk), .out(WriteRF), .in(toWriteRF), .write(1'b0), .reset(reset));
	reg1_1  __WriteR7Reg(.clk(clk), .out(WriteR7), .in(toWriteR7), .write(1'b0), .reset(reset));
	reg1_1  __WriteMemReg(.clk(clk), .out(WriteMem), .in(toWriteMem), .write(1'b0), .reset(reset));
	reg1_0  __RAMemSelect(.clk(clk), .out(RAMemSelectInput), .in(toRAMemSelectInput), .write(1'b0), .reset(reset));
	reg1_0  __WAMemSelect(.clk(clk), .out(WAMemSelectInput), .in(toWAMemSelectInput), .write(1'b0), .reset(reset));

endmodule