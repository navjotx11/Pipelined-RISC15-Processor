module memory_access(IRfrompipe6,wb_pr_CCR_write,IRfrompipe4, IRfrompipe5, RAFromPipe, ALUOut, RAMemSelectInput, WAMemSelectInput, MemData,
					  DataInSelect, WriteMem, RAFromPipeInc,SignalB, SignalC, Rfout1, Rfout2, mem_wb_CCR_write, ex_mem_CCR_write,reset,clk,SignalZ);

	output [15:0] MemData, RAFromPipeInc;
	input  [15:0] ALUOut, RAFromPipe, Rfout1, Rfout2, SignalC, SignalB,SignalZ ,IRfrompipe5, IRfrompipe4,IRfrompipe6;
	input         RAMemSelectInput, WAMemSelectInput, WriteMem, DataInSelect, mem_wb_CCR_write, ex_mem_CCR_write,wb_pr_CCR_write,reset,clk;
	
	wire [15:0] DataIn;	
	wire [15:0] readAddSelected, writeAddSelected, DataInSelected;
	wire [1:0]  F3;
	
	mux_16_2 	__RASelect(.data0(RAFromPipe), .data1(ALUOut), .selectInput(RAMemSelectInput), .out(readAddSelected));
	mux_16_2 	__WASelect(.data0(RAFromPipe), .data1(ALUOut), .selectInput(WAMemSelectInput), .out(writeAddSelected));
	mux_16_4 	__DataSelect2(.data0(DataInSelected), .data1(SignalB), .data2(SignalC), .data3(SignalZ), .selectInput(F3), .out(DataIn));
	mux_16_2 	__DataSelect1(.data0(Rfout1), .data1(Rfout2), .selectInput(DataInSelect), .out(DataInSelected));
	
	data_memory __DataMemory(.readAdd(readAddSelected), .out(MemData), .writeAdd(writeAddSelected), .in(DataIn), .write(WriteMem),.clk(clk),.reset(reset));
	incrementer __Inc(.in(RAFromPipe), .out(RAFromPipeInc),.reset(reset));
	
	forward_memory_stage  __f_mem(.wb_pr_CCR_write(wb_pr_CCR_write),.wb_pr_op({IRfrompipe6[15:12],IRfrompipe6[1:0]}),.wb_pr_regC(IRfrompipe6[5:3]),.mem_wb_op({IRfrompipe5[15:12],IRfrompipe5[1:0]}), .mem_wb_regA(IRfrompipe5[11:9]), .mem_wb_regC(IRfrompipe5[5:3]), .ex_mem_op({IRfrompipe4[15:12],IRfrompipe4[1:0]}),.ex_mem_regA(IRfrompipe4[11:9]), .F3(F3) ,.mem_wb_CCR_write(mem_wb_CCR_write), .ex_mem_CCR_write(ex_mem_CCR_write));

endmodule