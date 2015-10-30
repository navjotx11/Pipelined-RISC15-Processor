module execute(	clk, reset, ALUOut, ALUOp,fromPlusOneMem, fromRFOut1, fromRFOut2, RASelectInput, CCRWrite, CCR_Write_from_wb,CCRWriteValue,
CCRWriteValue_from_wb, fromSImm6, ExMux1Select, ExMux2Select,
		RAOut,IR,SignalA,SignalB,SignalC,SignalG,SignalI,SignalJ,SignalK,SignalX,SignalY,SignalZ
		,mem_wb_op,mem_wb_regA,mem_wb_regB,mem_wb_regC,ex_mem_op,ex_mem_regA,ex_mem_regB,ex_mem_regC,
		regread_ex_op,regread_ex_regA,regread_ex_regB,regread_ex_regC,ex_mem_CCR_write,r7,rf,wb_pr_op,wb_pr_regA,wb_pr_regB,wb_pr_regC,wb_pr_CCR_write,RF1out);

		
parameter ADD = 6'b000000;
parameter NDU = 6'b001000;
parameter ADC = 6'b000010;
parameter ADZ = 6'b000001;
parameter ADI = 4'b0001;
parameter NDC = 6'b001010;
parameter NDZ = 6'b001001;
	output [15:0] RAOut, ALUOut,RF1out;
	
	output r7,rf;
	output    reg    CCRWrite;//send to pipeline register
	output  [ 1:0] CCRWriteValue;//send to pipeline register
	input CCR_Write_from_wb;
	input  [15:0] fromPlusOneMem, fromRFOut1, fromRFOut2, fromSImm6;
	input [15:0] SignalA,SignalB,SignalC,SignalG,SignalI,SignalJ,SignalK;
	input [1:0] SignalX,SignalY;
	input [1:0] CCRWriteValue_from_wb;
	input         clk, reset, RASelectInput, ALUOp, ExMux1Select, ExMux2Select;
	input [15:0]IR;
	input [15:0]SignalZ;
	//inputs required for forwarding
	input [2:0] mem_wb_regA,mem_wb_regB,mem_wb_regC,ex_mem_regA,ex_mem_regB,ex_mem_regC,regread_ex_regA,regread_ex_regB,regread_ex_regC,wb_pr_regA,wb_pr_regB,wb_pr_regC;
	input [5:0]mem_wb_op,ex_mem_op,regread_ex_op,wb_pr_op;
	input ex_mem_CCR_write,wb_pr_CCR_write;
	//
	
	
	wire   [15:0] ALUIn1, ALUIn2, ExMux1Out, ExMux2Out,RAMUXout;
	wire[1:0] CCRMux_out;//CCRMux_out[1] = zero, CCRMux_out[0] = carry
	wire[1:0] CCR_muxSelect;
	wire [1:0] CCR;
	wire   [ 2:0] ExMux3Select, ExMux4Select,FRA;			// These come from the forwarding unit. Do this.
	wire          ALUZero, ALUCarry;
	wire Fz;
	wire [5:0]ALU_op;//to check whether we must write to CCR or not
	assign ALU_op = {IR[15:12],IR[1:0]};
	mux_2_4 CCR_mux(.data0(CCR),.data1(SignalX),.data2(SignalY),.data3(2'b0),.selectInput(CCR_muxSelect),.out(CCRMux_out));
	mux_16_2 RAMux(.data0(fromPlusOneMem), .data1(fromRFOut1), .selectInput(RASelectInput), .out(RAMUXout));
	mux_16_2 FzMux (.data0(fromRFOut1),.data1(SignalZ),.selectInput(Fz),.out(RF1out));
	mux_16_2 ExMux1(.data0(fromRFOut1), .data1(fromSImm6), .selectInput(ExMux1Select), .out(ExMux1Out));//for input 1 of ALU
	mux_16_2 ExMux2(.data0(fromRFOut2), .data1(fromSImm6), .selectInput(ExMux2Select), .out(ExMux2Out));//for input 2 of ALU
	mux_16_8 ExMux3(.data0(ExMux1Out), .data1(SignalA), .data2(SignalB), .data3(SignalC), .data4(SignalG), .data5(SignalI), .data6(SignalJ), .data7(SignalK), .selectInput(ExMux3Select), .out(ALUIn1));
	mux_16_8 ExMux4(.data0(ExMux2Out), .data1(SignalA), .data2(SignalB), .data3(SignalC), .data4(SignalG), .data5(SignalI), .data6(SignalJ), .data7(SignalK), .selectInput(ExMux4Select), .out(ALUIn2));
	CZ_reg CCRReg(.clk(clk), .out(CCR), .in(CCRWriteValue_from_wb), .write(CCR_Write_from_wb), .reset(reset));
	mux_16_8 Forwarded_RA_mux(.data0(RAMUXout), .data1(SignalA), .data2(SignalB), .data3(SignalC), .data4(SignalG), .data5(SignalI), .data6(SignalJ), .data7(SignalK), .selectInput(FRA), .out(RAOut));
	ALU me(.in1(ALUIn1), .in2(ALUIn2), .op(ALUOp), .out(ALUOut), .zero(ALUZero), .carry(ALUCarry));
	forward_execution_stage f_ex(.CCRMux_out(CCRMux_out),.Fz(Fz),.mem_wb_op(mem_wb_op),.mem_wb_regA(mem_wb_regA),.mem_wb_regB(mem_wb_regB),.mem_wb_regC(mem_wb_regC),.ex_mem_op(ex_mem_op),.ex_mem_regA(ex_mem_regA),.ex_mem_regB(ex_mem_regB),.ex_mem_regC(ex_mem_regC),.regread_ex_op(regread_ex_op),.regread_ex_regA(regread_ex_regA),.regread_ex_regB(regread_ex_regB),
.regread_ex_regC(regread_ex_regC),.F1(ExMux3Select),.F2(ExMux4Select),.FRA(FRA),.FCCR(CCR_muxSelect), .mem_wb_CCR_write(CCR_Write_from_wb), .ex_mem_CCR_write(ex_mem_CCR_write),
 .writerf(rf), .writer7(r7),.wb_pr_op(wb_pr_op),.wb_pr_regA(wb_pr_regA),.wb_pr_regB(wb_pr_regB), .wb_pr_regC(wb_pr_regC), .wb_pr_CCR_write(wb_pr_CCR_write));
	
	assign CCRWriteValue = {ALUZero, ALUCarry};
	always @(*)
	begin
	
	if(ALU_op==ADD||ALU_op[5:2]==ADI||ALU_op==NDU)
		CCRWrite=1'b0;
	else if((ALU_op==ADC||ALU_op==NDC)&&	(CCRMux_out[0]==1'b1))//previous carry set or not
		CCRWrite=1'b0;
	else if((ALU_op==ADZ||ALU_op==NDZ) &&(CCRMux_out[1]==1'b1)) //previous zero flag set or not
		CCRWrite=1'b0;
	else 
		CCRWrite=1'b1;
	end
	
		
endmodule