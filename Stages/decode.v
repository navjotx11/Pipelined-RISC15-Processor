module decode(MmemData, fromPipe1PC, IR, PC_Imm, rA1, rA2, wA, Sext_Imm6, Imm970, Mex1, Mex2, wMem, alu_ctrl, MregWB, MmemR, MmemW, Mr7WB,modify_pr2_ra,modify_ir,clk);
	
	output  [15:0] PC_Imm, Sext_Imm6, Imm970;
	output reg [2:0] rA1, rA2, wA;
	output reg [1:0] MregWB;
	output wire [2:0]modify_pr2_ra;
	output reg modify_ir;
	assign modify_pr2_ra=wA;
	output reg MmemData;
	integer i;
	output reg  Mex1, Mex2, wMem, alu_ctrl, MmemR, MmemW;
	output reg [2:0] Mr7WB;
	input [15:0] fromPipe1PC, IR;
	input clk;
	wire [15:0] imm6, imm9;
	wire select;
	wire [15:0] offset;
	wire [8:0] LM_Imm;	
	assign LM_Imm = IR[8:0];
	assign imm6 = {10'd0, IR[5:0]};
	assign imm9 = {7'd0, IR[8:0]};
	assign select = (IR[15:12]==4'b1000)?1'b0:1'b1;	
	mux_16_2 __m1(.data0(imm9), .data1(imm6), .selectInput(select), .out(offset));
	add_16 __add1(.in1(fromPipe1PC),.in2(offset),.out(PC_Imm),.clk(clk));
	shift_6 __s1(.in(IR[5:0]), .out(Sext_Imm6));
	assign Imm970 = {IR[8:0], 7'd0};
	
	always@(*)	
	begin
	
		case (IR[15:12])
			
			4'b0000:	//Instructions ADD, ADC, ADZ
			begin
				modify_ir <= 1'b0;
				rA2<= IR[8:6];	
				wA<= IR[5:3];	
				rA1<= IR[11:9];	
				Mex1<= 0;
				Mex2<= 0;
				alu_ctrl<=0;	//Add operation
				wMem<=1;	// memory write disabled
				MmemR<=0;	
				MmemW<=0;
				MmemData<=0;
				MregWB<=1;	//Write_back Alu_out
				if(IR[5:3]==3'b111)	//If RC is R7
					Mr7WB<=3;	//Write_back Alu_out to R7
				else
					Mr7WB<=5;	//Increment PC
			end
			
			4'b0001:	//ADI instruction
			begin
				modify_ir <= 1'b0;
				rA1<= IR[11:9];	
				rA2<= 3'b000;
				wA<= IR[8:6];
				Mex1<= 0;
				Mex2<= 1;	//Shift_6;	
				alu_ctrl<=0;	//ADD
				wMem<=1;
				MmemR<=0;
				MmemW<=0;
				MmemData<=0;
				MregWB<=1; 	//Write back Alu_out
				if(IR[8:6]==3'b111)	//If RB is R7
					Mr7WB<=3;	//Write_back Alu_out to R7
				else
					Mr7WB<=5;	//Increment PC
			end
			
			4'b0010:	//Instructions NDU, NDC, NDZ
			begin
				modify_ir <= 1'b0;
				rA2<= IR[8:6];	
				wA<= IR[5:3];
				rA1<= IR[11:9];
				Mex1<= 0;
				Mex2<= 0;
				alu_ctrl<=1;	//Nand operation
				wMem<=1;
				MmemR<=0;
				MmemW<=0;
				MmemData<=0;
				MregWB<=1;	//Write_back Alu_out
				if(IR[5:3]==3'b111)	//If RC is R7
					Mr7WB<=3;	//Write_back Alu_out to R7
				else
					Mr7WB<=5;	//Increment PC
			end
			
			4'b0011:	//LHI instruction
			begin
				modify_ir <= 1'b0;
				wA<= IR[11:9];
				rA1<= 3'b000;
				rA2<= 3'b000;
				Mex1<=0;
				Mex2<=0;
				alu_ctrl<=0;
				wMem<=1;
				MmemR<=0;	
				MmemW<=0;	
				MmemData<=0;
				MregWB<=2;	
				if(IR[11:9]==3'b111) //If RA is R7
					Mr7WB<=0;	// Write_back Imm970 to R7
				else
					Mr7WB<=5;	//Increment PC
			end
			
			4'b0100:	//LW Instruction
			begin
				modify_ir <= 1'b0;
				wA<= IR[11:9];	
				rA2<=IR[8:6];	
				rA1<=3'b000;	
				Mex1<=1;
				Mex2<=0;
				alu_ctrl<=0;
				wMem<=1;
				MmemR<=1;
				MmemW<=0;
				MmemData<=0;
				MregWB<=0;	//Write_back mem_data
				if(IR[11:9]==3'b111) //If RA is R7
					Mr7WB<=1;	// Write back mem_data to R7
				else
					Mr7WB<=5;	//Increment PC
			end
			
			4'b0101:	//SW Instruction
			begin
				modify_ir <= 1'b0;
				rA2<= IR[8:6];	
				rA1<= IR[11:9];	
				wA<= 3'b000;	
				Mex1<=1;
				Mex2<=0;
				alu_ctrl<=0;	//Add
				wMem<=0;
				MmemR<=0;
				MmemW<=1;
				MmemData<=0;	//Write to memory. Data present in rfout1
				MregWB<=0;	//Don't Care
				Mr7WB<=5;	//PC Increment
			end
			
			4'b0110:	//LM
			begin
				
				rA1<= IR[11:9];	//RA
				rA2<=3'b000;	//Don't Care
				if(LM_Imm[0]==1)
					wA <=3'b000;
				else if(LM_Imm[1]==1)
					wA <=3'b001;
				else if(LM_Imm[2]==1)
					wA <=3'b010;
				else if(LM_Imm[3]==1)
					wA <=3'b011;
				else if(LM_Imm[4]==1)
					wA <=3'b100;
				else if(LM_Imm[5]==1)
					wA <=3'b101;
				else if(LM_Imm[6]==1)
					wA <=3'b110;
				else if(LM_Imm[7]==1)
					wA <=3'b111;
				else 
					wA <=3'b000;
				modify_ir <= 1'b1;
				Mex1<=0;
				Mex2<=0;
				alu_ctrl<=0;
				wMem<=1;
				MmemR<=0;
				MmemW<=0;
				MmemData<=0;
				MregWB<=0;	//Write_back the value in mem_data
				if(IR[11:9]==3'b111) //If RA is R7
					Mr7WB<=1;	// Write_back mem_data to R7
				else
					Mr7WB<=5;	//Increment PC
			end
			
			4'b0111:	//SM Instruction
			begin
				/*** PRIORITY ENCODER ***/
				modify_ir <= 1'b1;
				rA1<= IR[11:9]; //take RA
				
				if(LM_Imm[0]==1)
				begin
					wA<=3'b000;
					rA2 <=3'b000;
				end
				else if(LM_Imm[1]==1)
				begin
					wA<=3'b001;
					rA2 <=3'b001;
				end
				else if(LM_Imm[2]==1)
				begin
					wA<=3'b010;
					rA2 <=3'b010;
				end
				else if(LM_Imm[3]==1)
				begin
					wA<=3'b011;
					rA2 <=3'b011;
				end
				else if(LM_Imm[4]==1)
				begin
					wA<=3'b100;
					rA2 <=3'b100;
				end
				else if(LM_Imm[5]==1)
				begin
					wA<=3'b101;
					rA2 <=3'b101;
				end
				else if(LM_Imm[6]==1)
				begin
					wA<=3'b110;
					rA2 <=3'b110;
				end
				else if(LM_Imm[7]==1)
				begin
					wA<=3'b111;
					rA2 <=3'b111;
				end
				else 
				begin
					wA<=3'b000;
					rA2 <=3'b000;
				end 
				Mex1<=0;
				Mex2<=0;
				alu_ctrl<=0;
				wMem<=0;
				MmemR<=0;
				MmemW<=0;
				MmemData<=1;
				MregWB<=0;
				Mr7WB<=5;
			end
			
			4'b1100:	//BEQ Instruction - Branching
			begin
				modify_ir <= 1'b0;
				rA1<= IR[11:9];
				rA2<= IR[8:6];	
				wA<= 3'b000;
				Mex1<=0;	
				Mex2<=0;	
				alu_ctrl<=0;
				wMem<=1;	
				MmemR<=0;	
				MmemW<=0;	
				MmemData<=0;
				MregWB<=0;	
				Mr7WB<=2;	//PC_Imm -> r7
			end
			
			4'b1000:	//JAL Instruction
			begin
				modify_ir <= 1'b0;
				rA1<= 3'b000;
				rA2<= 3'b000;
				wA<= IR[11:9];
				Mex1<=0;
				Mex2<=0;
				alu_ctrl<=0;
				wMem<=1;
				MmemR<=0;
				MmemW<=0;
				MmemData<=0;
				MregWB<=3;	//Write_back PC+1
				Mr7WB<=2;	//PC_Imm -> r7
			end
			
			4'b1001:	//JLR Instruction
			begin
				modify_ir <= 1'b0;
				rA1<= 3'b000;
				rA2<= IR[8:6];
				wA<= IR[11:9];
				Mex1<=0;
				Mex2<=0;
				alu_ctrl<=0;
				wMem<=1;
				MmemR<=0;
				MmemW<=0;
				MmemData<=0;
				MregWB<=3;	//Write back PC+1
				Mr7WB<=4;	//Write Rfout2 to R7
			end
			
			default:
			begin
				modify_ir <= 1'b0;
				rA1<=3'b000;	
				rA2<=3'b000;	
				wA<= 3'b000;
				Mex1<=0;
				Mex2<=0;
				alu_ctrl<=0;
				wMem<=1;
				MmemR<=0;
				MmemW<=0;
				MmemData<=0;
				MregWB<=0;	
				Mr7WB<=5;	//Increment PC
			end
		endcase
	end
endmodule