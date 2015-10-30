module register_bank(in, readAdd1, readAdd2, regValue1, regValue2, equalValue, write, writeAdd, writeR7, inR7, clk, reset);

	output [15:0] regValue1, regValue2;
	output 	      equalValue;
	input  [15:0] in, inR7;
	input  [2:0]  readAdd1, readAdd2, writeAdd;
	input	      write, writeR7, clk, reset;
	
	reg16_file rfile(.clk(clk), .out1(regValue1), .out2(regValue2), .readAdd1(readAdd1), .readAdd2(readAdd2), .write(write), .writeAdd(writeAdd), .writeR7(writeR7), .inR7(inR7), .in(in), .reset(reset));
	check_eq eqCheck(.in1(regValue1), .in2(regValue2), .out(equalValue));

endmodule