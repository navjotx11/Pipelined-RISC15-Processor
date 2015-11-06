module data_memory(readAdd, out, writeAdd, in, write,clk,reset);

	output  [15:0] out;

	input  [15:0] readAdd, writeAdd, in;
	input  write;
	input clk;
	input reset;
	
	reg [15:0] mem [0:255];
	integer i;
	
	always @(posedge clk)
		begin
			if(reset== 1'b0)
				begin
					for(i=0;i<255;i=i+1) mem [i] = 0;
					mem[20] <= 		16'b0000000000000001;
					mem[21] <= 		16'b0010111001010100;
					
					mem[23] <= 		16'b0000000000010000;
					mem[24] <= 		16'b0000000000000101;

					mem[54] <= 		16'b0000000000001001;
				end
			if(write ==1'b0)
				begin
					mem[writeAdd] <= in;
				end
		end

	assign out  = mem[readAdd];

endmodule

module instruction_memory(readAdd, out,reset,clk);

	output  [15:0] out;
	
	input  [15:0] readAdd;
	input reset,clk;
	
	reg [15:0] mem [0:255];
	wire [15:0]test;

	integer i;
	
	assign out = (reset==1'b0)?16'b1111000000000000:mem[readAdd];	
	
	always @(posedge clk)
		begin
			if(reset== 1'b0)
				begin
					for(i=0;i<256;i=i+1) mem [i] =  16'b1111000000000000;
				end

				/*
				  mem[0] = 16'b0011000000000001;//LHI R0,#1     ro = 80
				  mem[1] = 16'b0000000000000000;//ADD R0,R0,R0   ro=100
				  mem[2] = 16'b0011001000000111;//LHI R1     r1=380
				  mem[3] = 16'b0000000001010000; //ADD R2, R0, R1  r2 = 480
				  mem[4] = 16'b0101010011000000;//SW R2,R3,6'b0  mem(0) = 480
				  mem[5] = 16'b0100100011000000;//LW R4,R3,6'b0  r4 = mem(0) = 480
				  mem[6] = 16'b0101010011000001;//SW R2,R3,6'b1  mem(1) = 480
				  mem[7] = 16'b0100101011000001;//LW R5,R3,6'b1  r5 = mem(1) = 480
				  mem[8] = 16'b0110011001100000;//LM r3, 01100000(r6,r5)  r5 = mem(0) = 480 , r6 = 480
				  mem[9] = 16'b0000000001000000;//Add R0,R1,R0           r0 = 480
				  mem[10] = 16'b0000000000000000;////ADD R0,R0,R0         r0  = 900
				  mem[11] = 16'b0000011011000000; //ADD R0,R3,R3			r0 = 0
				  mem[12] = 16'b0000101000000001; //ADZ R0,R0,R5       r0 = 480
				  mem[13] = 16'b0011111000000001;//LHI R7 1
				  mem[128] = 16'b0001011100101010;//ADI R4 = R3+#101010 = #sext(101010)
				  mem[129] = 16'b0111011000000110;//SM mem(0) = R1	 , mem(1) =R2
				  mem[130] = 16'b0110011000001100;   //LM R2 = mem(0) R3 = mem(1)
				  mem[131] = 16'b1000000000000111;//JAL R0, #111
				  mem[138] = 16'b1100110101001000;//BEQ R6 R5 #2 // mem[136] = 16'b1100111101000010; (one jumps the other doesn't)
				  mem[139] = 16'b1001101000000000;//JLR R5,R0 (jump back to 82)
				  */

				// Lab Testbench 1 w/o LM SM
				/*
				mem[0]	<=		16'b1100000001011101;
				// mem[0]	<=		16'b1111000000000000;
				mem[1]	<=		16'b0100100110000101;
				mem[2]	<=		16'b0100110110000101;
				mem[3]	<=		16'b0100000101010100;
				mem[4]	<=		16'b0100001101010101;
				mem[5]	<=		16'b0001000010000000;
				mem[6]	<=		16'b0010000001011000;
				mem[7]	<=		16'b0010011011011000;
				mem[8]	<=		16'b0001011011000000;
				mem[9]	<=		16'b0000100010100001;
				mem[10]	<=		16'b0000000000000000;
				mem[11]	<=		16'b0010110110110010;
				mem[12]	<=		16'b1100110101111010;
				mem[13]	<=		16'b0101100101010110;
				

				mem[29] <=   	16'b0001011011000001;
				mem[30] <=   	16'b0001110110010111;
				mem[31] <=   	16'b0101000110000100;
				mem[32] <=   	16'b0100000110000000;
				mem[33] <=   	16'b0100001110000001;
				mem[34] <=   	16'b1100101001001100;
				mem[35] <=   	16'b0000000010010000;
				mem[36] <=   	16'b0000011100100010;
				mem[37] <=   	16'b0001001001111111;
				mem[38] <=   	16'b1000111111111011;

				mem[46] <=   	16'b0101010110000010;
				mem[47] <=   	16'b0101100110000011;
				mem[48] <=   	16'b0001011011111111;
				mem[49] <=   	16'b0101011110000101;
				mem[50] <=   	16'b0100111110000100;
				*/

				
				mem[0]  <=		16'b0100101000010111; 
				mem[1] 	<= 		16'b1111000000000000;
				mem[2]  <= 		16'b1111000000000000;
				mem[3]	<= 		16'b1111000000000000;
				mem[4]  <=		16'b0100011000011000; 
				mem[5] 	<= 		16'b1111000000000000;
				mem[6]  <= 		16'b1111000000000000;
				mem[7]	<= 		16'b1111000000000000;
				mem[8] 	<= 		16'b0001011011111111;
				mem[9] 	<= 		16'b1111000000000000;
				mem[10] <=	 	16'b1111000000000000;
				mem[11]	<= 		16'b1111000000000000;
				mem[12] <= 		16'b0000101110110000;
				mem[13] <= 		16'b1111000000000000;
				mem[14] <= 		16'b1111000000000000;
				mem[15]	<= 		16'b1111000000000000;
				mem[16] <= 		16'b1100011000001000;
				mem[17] <= 		16'b1111000000000000;
				mem[18] <= 		16'b1111000000000000;
				mem[19]	<= 		16'b1111000000000000;
				mem[20] <= 		16'b1000001111110100;
				mem[21] <= 		16'b1111000000000000;
				mem[22] <= 		16'b1111000000000000;
				mem[23]	<= 		16'b1111000000000000;
				mem[24] <=		16'b0101110000011001; 
				
				end	
endmodule