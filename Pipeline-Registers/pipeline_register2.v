module pipeline_register2(clk,reset,toMex1,Mex1,toMex2,Mex2,toMmemData,MmemData,toMmemR,MmemR,toMmemW,MmemW,toMregWB,MregWB,toMr7WB,Mr7WB,toPCInc,PCInc,
	                       toPC,PC,toIR,IR,tofirst_multiple,first_multiple,toPCImmInc,PCImmInc,toWriteMem,WriteMem,torA1,rA1,torA2,rA2,toWriteAdd,
	                       WriteAdd,toSImm6,SImm6,toImm970s,Imm970s,toalu_ctrl,alu_ctrl,flush,modify_pr2_ra,modify_ir);

	output [15:0] PCInc,PC,IR,PCImmInc,SImm6,Imm970s;
	output [2:0]  rA1,rA2,WriteAdd;
	output [2:0]  Mr7WB;
	output [1:0]  MregWB;
	output        Mex1,Mex2,MmemData,MmemR,MmemW,first_multiple,WriteMem,alu_ctrl;
	
	input [15:0] toPCInc,toPC,toIR,toPCImmInc,toSImm6,toImm970s;
	input [2:0]  torA1,torA2,toWriteAdd,modify_pr2_ra;
	input [2:0]  toMr7WB;
	input [1:0]  toMregWB;
	input        toMex1,toMex2,toMmemData,toMmemR,toMmemW,tofirst_multiple,toWriteMem,toalu_ctrl;
	input        modify_ir;
	input        flush,clk,reset;
	
	wire [15:0] inIR;
	wire infirst_multiple;
	wire inWriteMem;

	assign inIR = (flush==1'b1)?16'b1111000000000000:((modify_ir ==1'b1)?{toIR[15:12],modify_pr2_ra,toIR[8:0]}:toIR);
	assign inWriteMem = (flush==1'b1)?1'b1:toWriteMem;
	assign infirst_multiple = (flush==1'b1)?1'b0:tofirst_multiple;

	reg1_0  __Mex1_reg (.clk(clk), .out(Mex1), .in(toMex1) , .write(1'b0), .reset(reset));
	reg1_0  __Mex2_reg (.clk(clk), .out(Mex2), .in(toMex2) , .write(1'b0), .reset(reset));
	reg1_0  __MmemData_reg (.clk(clk), .out(MmemData), .in(toMmemData) , .write(1'b0), .reset(reset));
	reg1_0  __MmemR_reg (.clk(clk), .out(MmemR), .in(toMmemR) , .write(1'b0), .reset(reset));
	reg1_0  __MmemW_reg (.clk(clk), .out(MmemW), .in(toMmemW) , .write(1'b0), .reset(reset));
	reg1_0  __first_multiple_reg (.clk(clk), .out(first_multiple), .in(infirst_multiple) , .write(1'b0), .reset(reset));
	reg1_1  __WriteMem_reg (.clk(clk), .out(WriteMem), .in(inWriteMem) , .write(1'b0), .reset(reset));
	reg1_0  __alu_ctrl_reg (.clk(clk), .out(alu_ctrl), .in(toalu_ctrl) , .write(1'b0), .reset(reset));

	reg2    __MregWB_reg (.clk(clk), .out(MregWB), .in(toMregWB) , .write(1'b0), .reset(reset));
	reg3    __rA1_reg (.clk(clk), .out(rA1), .in(torA1) , .write(1'b0), .reset(reset));
	reg3 	__rA2_reg (.clk(clk), .out(rA2), .in(torA2) , .write(1'b0), .reset(reset));
	reg3 	__WriteAdd_reg (.clk(clk), .out(WriteAdd), .in(toWriteAdd) , .write(1'b0), .reset(reset));

	reg3    __Mr7WB_reg (.clk(clk), .out(Mr7WB), .in(toMr7WB) , .write(1'b0), .reset(reset));


	reg16      __PCInc_reg (.clk(clk), .out(PCInc), .in(toPCInc) , .write(1'b0), .reset(reset));
	reg16      __PC (.clk(clk), .out(PC), .in(toPC) , .write(1'b0), .reset(reset));
	reg16_NOP  __IR_reg (.clk(clk), .out(IR), .in(inIR) , .write(1'b0), .reset(reset));
	reg16      __PCImmInc_reg (.clk(clk), .out(PCImmInc), .in(toPCImmInc) , .write(1'b0), .reset(reset));
	reg16      __SImm6_reg (.clk(clk), .out(SImm6), .in(toSImm6) , .write(1'b0), .reset(reset));
	reg16      __Imm970s_reg (.clk(clk), .out(Imm970s), .in(toImm970s) , .write(1'b0), .reset(reset));

endmodule