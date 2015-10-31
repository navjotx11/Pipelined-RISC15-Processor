module write_back(clk, reset, Imm970, MemData, PCImmInc, ALUOut, PCInc, regSelect, r7Select, writeData, writeR7Data, RFOut2);

	output [15:0] writeData, writeR7Data;
	input  [15:0] Imm970, MemData, PCImmInc, ALUOut, PCInc, RFOut2;
	input  [ 2:0] r7Select;
	input  [ 1:0] regSelect;
	input         clk, reset;

	mux_16_4 __regWriteMux(.data0(MemData), .data1(ALUOut), .data2(Imm970), .data3(PCInc), .selectInput(regSelect), .out(writeData));
	mux_16_8 __r7WriteMux(.data0(Imm970), .data1(MemData), .data2(PCImmInc), .data3(ALUOut), .data4(RFOut2), .data5(PCInc), .selectInput(r7Select), .out(writeR7Data));

endmodule