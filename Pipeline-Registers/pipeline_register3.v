module pipeline_register3(clk, reset, toalu_ctrl, alu_ctrl, toImm970s, toPCImmInc, toPCInc, toWriteAdd, toRegWriteSelect, toR7WriteSelect, toWriteMem, toRFOut1,
 toRFOut2, toEqu, toSImm6, toIR, Imm970s, PCImmInc, PCInc, WriteAdd, RegWriteSelect, R7WriteSelect, WriteMem, RFOut1, RFOut2, Equ, SImm6, IR,
 MemdataSelectInput,toMemdataSelectInput,
 RAMemSelectInput,toRAMemSelectInput, WAMemSelectInput,toWAMemSelectInput,tofirst_multiple,first_multiple,Mex1,toMex1,Mex2,toMex2,flush);
	
	output [15:0] Imm970s, PCImmInc, PCInc, RFOut1, RFOut2, IR, SImm6;
	output [ 2:0] WriteAdd;
	output [2:0]  R7WriteSelect;
	output [1:0] RegWriteSelect;
	output        WriteMem, RAMemSelectInput, WAMemSelectInput, Equ,Mex1,Mex2, alu_ctrl, MemdataSelectInput,first_multiple;
	
	input [15:0] toImm970s, toPCImmInc, toPCInc, toRFOut1, toRFOut2, toIR, toSImm6;
	input [ 2:0] toWriteAdd;
	input [2:0]  toR7WriteSelect;
	input [ 1:0] toRegWriteSelect;
	input        toWriteMem, toRAMemSelectInput, toWAMemSelectInput, toEqu, clk, reset,tofirst_multiple,toMex1,toMex2, flush,
				 toalu_ctrl, toMemdataSelectInput;
	
	wire [15:0] inIR;
	wire infirst_multiple;
	wire inWriteMem,inEqu;

	assign inIR = (flush==1'b1)?16'b1111000000000000:toIR;//introduce a NOP, in the event of a flush
	assign inWriteMem = (flush==1'b1)?1'b1:toWriteMem;//introduce a NOP, in the event of a flush
	assign inEqu = (flush==1'b1)?1'b1:toEqu;//introduce a NOP, in the event of a flush
	assign infirst_multiple = (flush==1'b1)?1'b0:tofirst_multiple;//introduce a NOP, in the event of a flush
	
	reg16 Imm970Reg(.clk(clk), .out(Imm970s), .in(toImm970s), .write(1'b0), .reset(reset));
	reg16 PCImmIncReg(.clk(clk), .out(PCImmInc), .in(toPCImmInc), .write(1'b0), .reset(reset));
	reg16 PCIncReg(.clk(clk), .out(PCInc), .in(toPCInc), .write(1'b0), .reset(reset));
	reg16 RFOut1Reg(.clk(clk), .out(RFOut1), .in(toRFOut1), .write(1'b0), .reset(reset));
	reg16 RFOut2Reg(.clk(clk), .out(RFOut2), .in(toRFOut2), .write(1'b0), .reset(reset));
	reg16 SImm6Reg(.clk(clk), .out(SImm6), .in(toSImm6), .write(1'b0), .reset(reset));
	reg16_NOP IRReg(.clk(clk), .out(IR), .in(inIR), .write(1'b0), .reset(reset));
	reg3  WriteAddReg(.clk(clk), .out(WriteAdd), .in(toWriteAdd), .write(1'b0), .reset(reset));
	
	reg3  R7WriteSelectReg(.clk(clk), .out(R7WriteSelect), .in(toR7WriteSelect), .write(1'b0), .reset(reset));
	reg2  RegWriteSelectReg(.clk(clk), .out(RegWriteSelect), .in(toRegWriteSelect), .write(1'b0), .reset(reset));
	
	reg1_1  WriteMemReg(.clk(clk), .out(WriteMem), .in(inWriteMem), .write(1'b0), .reset(reset));
	reg1_0  RAMemSelect(.clk(clk), .out(RAMemSelectInput), .in(toRAMemSelectInput), .write(1'b0), .reset(reset));
	reg1_0  WAMemSelect(.clk(clk), .out(WAMemSelectInput), .in(toWAMemSelectInput), .write(1'b0), .reset(reset));
	reg1_0  MemdataSelect(.clk(clk), .out(MemdataSelectInput), .in(toMemdataSelectInput), .write(1'b0), .reset(reset));
	reg1_0  EquReg(.clk(clk), .out(Equ), .in(inEqu), .write(1'b0), .reset(reset));
	reg1_0 first_multiple_reg (.clk(clk), .out(first_multiple), .in(infirst_multiple) , .write(1'b0), .reset(reset));
	reg1_0 Mex1_reg (.clk(clk), .out(Mex1), .in(toMex1) , .write(1'b0), .reset(reset));
	reg1_0 Mex2_reg (.clk(clk), .out(Mex2), .in(toMex2) , .write(1'b0), .reset(reset));
	reg1_0 alu_ctrl_reg (.clk(clk), .out(alu_ctrl), .in(toalu_ctrl) , .write(1'b0), .reset(reset));
endmodule