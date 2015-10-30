module data_memory(readAdd, out, writeAdd, in, write,clk,reset);

	output  [15:0] out;
	input  [15:0] readAdd, writeAdd, in;
	input  write;
	input clk;
	reg [15:0] mem [0:255];
	integer i;
	input reset;
	
	always @(posedge clk)
begin

if(reset== 1'b0)
begin
for(i=0;i<255;i=i+1)
mem [i] = 0;
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
	reg [15:0] mem [0:255];
	integer i;
	input reset,clk;
	wire [15:0]test;

	assign out = (reset==1'b0)?16'b1111000000000000:mem[readAdd];	
	
always @(posedge clk)
begin


if(reset== 1'b0)
begin
for(i=0;i<256;i=i+1)
mem [i] =  16'b1111000000000000;

end

  mem[0] = 16'b0011000000000001;//LHI R0,#1     ro = 80
  mem[1] = 16'b0000000000000000;//ADD R0,R0,R0   ro=100
  mem[2] = 16'b0011001000000111;//LHI R1     r1=380
  mem[3] = 16'b0000000001010000; //ADD R2, R0, R1  r2 = 480
//   mem[4] = 16'b0101010011000000;//SW R2,R3,6'b0  mem(0) = 480
//   mem[5] = 16'b0100100011000000;//LW R4,R3,6'b0  r4 = mem(0) = 480
//   mem[6] = 16'b0101010011000001;//SW R2,R3,6'b1  mem(1) = 480
//   mem[7] = 16'b0100101011000001;//LW R5,R3,6'b1  r5 = mem(1) = 480
//   mem[8] = 16'b0110011001100000;//LM r3, 01100000(r6,r5)  r5 = mem(0) = 480 , r6 = 480
//   mem[9] = 16'b0000000001000000;//Add R0,R1,R0           r0 = 480
//  mem[10] = 16'b0000000000000000;////ADD R0,R0,R0         r0  = 900
//  mem[11] = 16'b0000011011000000; //ADD R0,R3,R3			r0 = 0
//  mem[12] = 16'b0000101000000001; //ADZ R0,R0,R5       r0 = 480
//  mem[13] = 16'b0011111000000001;//LHI R7 1
// mem[128] = 16'b0001011100101010;//ADI R4 = R3+#101010 = #sext(101010)
// mem[129] = 16'b0111011000000110;//SM mem(0) = R1	 , mem(1) =R2
// mem[130] = 16'b0110011000001100;   //LM R2 = mem(0) R3 = mem(1)
// mem[131] = 16'b1000000000000111;//JAL R0, #111
// mem[138] = 16'b1100110101001000;//BEQ R6 R5 #2 // mem[136] = 16'b1100111101000010; (one jumps the other doesn't)
// mem[139] = 16'b1001101000000000;//JLR R5,R0 (jump back to 82)
end	

endmodule