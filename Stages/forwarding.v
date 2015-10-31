module forwarding(clk,equ,pr2_IR,pr3_IR,pr4_IR,pr5_IR,pc_mux_select);

	output reg [2:0] pc_mux_select;
	input [15:0] pr2_IR,pr3_IR,pr4_IR,pr5_IR;
	input 		 equ,clk;

	parameter ADD = 6'b000000;
	parameter NDU = 6'b001000;
	parameter ADC = 6'b000010;
	parameter ADZ = 6'b000001;
	parameter ADI = 4'b0001;
	parameter NDC = 6'b001010;
	parameter NDZ = 6'b001001;
	parameter LHI = 4'b0011;
	parameter LW  = 4'b0100;
	parameter SW  = 4'b0101;
	parameter LM  = 4'b0110;
	parameter SM  = 4'b0111;
	parameter BEQ = 4'b1100;
	parameter JAL = 4'b1000;
	parameter JLR = 4'b1001;

	parameter rb=3'd1;
	parameter c=3'd2;
	parameter m= 3'd3;
	parameter one = 3'd4;
	parameter h = 3'd5;
	parameter a = 3'd6;


	wire [5:0] 	op2,op3,op4,op5;
	wire[2:0] 	pr2RA,pr2RB,pr4RC,pr5RA;
	assign op2={pr2_IR[15:12],pr2_IR[1:0]};
	assign op3={pr3_IR[15:12],pr3_IR[1:0]};
	assign op4={pr4_IR[15:12],pr4_IR[1:0]};
	assign op5={pr5_IR[15:12],pr5_IR[1:0]};

	assign pr2RA = pr2_IR[11:9];
	assign pr2RB = pr2_IR[8:6];
	assign pr4RC = pr2_IR[5:3];
	assign pr5RA = pr5_IR[11:9];

	always @(*)
	begin
		if((op5[5:2]==LW||op5[5:2]==LM)&&pr5RA==3'b111)
			pc_mux_select=c;
		else if(op2[5:2]==LHI&&pr2RA==3'b111)
			pc_mux_select=h;

		else if((op4==ADD||op4==NDU||op4==ADC||op4==ADZ||op4==NDC||op4==NDC||op4==NDZ)&&(pr4RC==3'b111))
			pc_mux_select=a;//ALU_out in pr4
		else if(op4[5:2]==ADI&&pr2RB==3'b111)
			pc_mux_select=a;//ALU_out in pr4
		else if(equ==1&&op3[5:2]==BEQ) 
			pc_mux_select=one;//pc+Im6, in pr3
		else if(op3[5:2]==JLR)
			pc_mux_select=rb;//from RFout2 of pr3
		else if(op2[5:2]==JAL)
			pc_mux_select=m;//PC+Im6 , in pr2
		else
			pc_mux_select=0;
		
	end

endmodule