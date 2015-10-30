module hazard_detection_unit(IR_write,IR_load_mux,new_IR_multi,first_multiple,clk,flush_reg_ex,flush_id_reg,flush_if_id,pr1_IR,pr1_pc,pr2_IR,pr2_pc,pr3_IR,pr4_IR,pr5_IR,pc_write,equ);//equ comes from PR reg/ex


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
	input clk,equ;
	input [15:0] pr1_IR,pr2_IR,pr3_IR,pr4_IR,pr5_IR,pr1_pc,pr2_pc;
	output reg[15:0] new_IR_multi;
	output reg flush_id_reg,flush_if_id,flush_reg_ex,pc_write,IR_write,first_multiple,IR_load_mux;
	wire [5:0] op1,op2,op3,op4,op5;
	wire [7:0]LM_Imm;
	assign LM_Imm=pr1_IR[7:0];
	
				
	wire[2:0] pr1RA,pr2RA,pr3RA,pr1RB,pr2RB,pr1RC,pr2RC,pr3RC,pr3RB,pr4RC,pr4RB,pr4RA,pr5RC,pr5RB,pr5RA;
	assign op1 = {pr1_IR[15:12],pr1_IR[1:0]};
	assign op2 = {pr2_IR[15:12],pr2_IR[1:0]};
	assign op3 = {pr3_IR[15:12],pr3_IR[1:0]};
	assign op4 = {pr4_IR[15:12],pr4_IR[1:0]};
	assign op5 = {pr5_IR[15:12],pr5_IR[1:0]};
	assign pr1RA = pr1_IR[11:9];
	assign pr1RB = pr1_IR[8:6];
	assign pr1RC = pr1_IR[5:3];
	assign pr2RA = pr2_IR[11:9];
	assign pr2RB = pr2_IR[8:6];
	assign pr2RC = pr2_IR[5:3];
	assign pr3RA = pr3_IR[11:9];
	assign pr3RB = pr3_IR[8:6];
	assign pr3RC = pr3_IR[5:3];
	assign pr4RA = pr4_IR[11:9];
	assign pr4RC = pr4_IR[5:3];
	assign pr4RB = pr4_IR[8:6];
	assign pr5RA = pr5_IR[11:9];
	assign pr5RC = pr5_IR[5:3];
	assign pr5RB = pr5_IR[8:6];
	always@(*) //first multiple detection
		begin
		if((op1[5:2]==LM||op1[5:2]==SM)&&(op1[5:2]!=op2[5:2])) 
			first_multiple=1'b1;
		else if ((op1[5:2]==LM||op1[5:2]==SM)&&(op1[5:2]==op2[5:2])&&(pr1_pc==pr2_pc))//last1
			first_multiple=1'b1;
		else 
			first_multiple=1'b0;
		end//
		
	
	always @(* ) 
	begin
		
			
			 
			 if(op3[5:2]==BEQ&&equ==1'b1)
				begin
				flush_reg_ex=1'b1;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write=1'b0;//write the forwarded value i.e. the jump location into PC
				IR_load_mux=1'b0;
				IR_write=1'b0;
				end
			else if((op1==ADD||op1==NDU||op1==ADC||op1==ADZ||op1==NDC||op1==NDC||op1==NDZ)&&(pr1RC==3'b111)) //if rc = R7 and an operation is performed onto Rc
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; 
				IR_write=1'b1;//do not allow pc to be written into
				IR_load_mux=1'b0;
				end
			else if((op2==ADD||op2==NDU||op2==ADC||op2==ADZ||op2==NDC||op2==NDC||op2==NDZ)&&(pr2RC==3'b111))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;//do not allow pc to be written into
				IR_load_mux=1'b0;
				end
			else if((op3==ADD||op3==NDU||op3==ADC||op3==ADZ||op3==NDC||op3==NDC||op3==NDZ)&&(pr3RC==3'b111))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id = 1'b1;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if(op1[5:2]==ADI&&pr1RB==3'b111)
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if(op2[5:2]==ADI&&pr2RB==3'b111)
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if(op3[5:2]==ADI&&pr2RB==3'b111)
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op1[5:2]==LW||op1[5:2]==LM)&&pr1RA==3'b111) //
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op2[5:2]==LW||op2[5:2]==LM)&&pr2RA==3'b111) 
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op3[5:2]==LW||op3[5:2]==LM)&&pr3RA==3'b111) 
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op4[5:2]==LW||op4[5:2]==LM)&&pr4RA==3'b111) 
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op1[5:2]==LHI)&&pr1RA ==3'b111)
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b0;//flush_id_reg=1'b1;
				flush_if_id=1'b1;
				pc_write = 1'b1; IR_write=1'b0;//IR_write=1'b1;is also ok?
				IR_load_mux=1'b0;
				end
				
			
			else if ((op1==ADD||op1==NDU||op1==ADC||op1==ADZ||op1==NDC||op1==NDC||op1==NDZ)
			&&((pr1RA==pr2RA)||pr1RB==pr2RA)&&(op2==LW||op2==LM))//load followed by op
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op1==ADI)&&(op2==LW||op2==LM)&&(pr1RA==pr2RA))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op1[5:2]==LW)&&(op2[5:2]==LW||op2[5:2]==LM)&&(pr1RB==pr2RA)) // lw/lm followed by lw   
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			
			
			
			else if((op1[5:2]==SW)&&(op2[5:2]==LW||op2[5:2]==LM||op2[5:2]==LHI)&&(pr1RB==pr2RA))        //load followed by store
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1;IR_write=1'b1;
				IR_load_mux=1'b0;
				end
				
			
			
			
			else if((op1[5:2]==BEQ)&&(op2==ADD||op2==NDU||op2==ADC||op2==ADZ||op2==NDC||op2==NDC||op2==NDZ)&&(pr1RA==pr2RC||pr1RB==pr2RC))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; 
				IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op3==ADD||op3==NDU||op3==ADC||op3==ADZ||op3==NDC||op3==NDC||op3==NDZ)&&(pr1RA==pr3RC||pr1RB==pr3RC))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; 
				IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op4==ADD||op4==NDU||op4==ADC||op4==ADZ||op4==NDC||op4==NDC||op4==NDZ)&&(pr1RA==pr4RC||pr1RB==pr4RC))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; 
				IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op2[5:2]==ADI)&&(pr1RA==pr2RB||pr1RB==pr2RB))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; 
				IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op3[5:2]==ADI)&&(pr1RA==pr3RB||pr1RB==pr3RB))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op4[5:2]==ADI)&&(pr1RA==pr4RB||pr1RB==pr4RB))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op2[5:2]==LM||op2[5:2]==LW||op2[5:2]==LHI)&&(pr1RA==pr2RA||pr1RB==pr2RA))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op3[5:2]==LM||op3[5:2]==LW||op3[5:2]==LHI)&&(pr1RA==pr3RA||pr1RB==pr3RA))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op4[5:2]==LM||op4[5:2]==LW||op4[5:2]==LHI)&&(pr1RA==pr4RA||pr1RB==pr4RA))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op3[5:2]==JAL)&&(pr1RA==pr2RA||pr1RB==pr2RA))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op4[5:2]==JAL)&&(pr1RA==pr3RA||pr1RB==pr3RA))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==BEQ)&&(op4[5:2]==JLR)&&(pr1RA==pr4RA||pr1RB==pr4RA))
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1;
				IR_write=1'b1;
				IR_load_mux=1'b0; 
				end
			
			
			else if(op1[5:2]==JAL)
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b0;
				flush_if_id=1'b1;
				pc_write = 1'b0; 
				IR_write=1'b0;
				IR_load_mux=1'b0;
				end
			else if(((op1[5:2]==JLR)&&  ( (op3[5:2]==JAL)&&(pr1RB==pr3RA)) ||((op4[5:2]==JAL)&&(pr1RB==pr4RA))|| ((op5[5:2]==JAL)&&(pr1RB==pr5RA)) )) //last change
				begin
				
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; 
				IR_write=1'b1;
				IR_load_mux=1'b0;
				end
			else if((op1[5:2]==JLR)&&( ((op2[5:2]==LW||op2[5:2]==LM)&&(pr1RB==pr2RA))||((op3[5:2]==LW||op3[5:2]==LM)&&(pr1RB==pr3RA))
					||((op4[5:2]==LW||op4[5:2]==LM)&&(pr1RB==pr4RA))||((op5[5:2]==LW||op5[5:2]==LM)&&(pr1RB==pr5RA))
					||((op2[5:2]==LHI)&&(pr1RB==pr2RA))||((op3[5:2]==LHI)&&(pr1RB==pr3RA))||((op4[5:2]==LHI)&&(pr1RB==pr4RA))
					||((op5[5:2]==LHI)&&(pr1RB==pr5RA))
					||((op2==ADD||op2==ADC||op2==ADZ||op2==NDU||op2==NDC||op2==NDZ)&&(pr1RB==pr2RC))
					||((op3==ADD||op3==ADC||op3==ADZ||op3==NDU||op3==NDC||op3==NDZ)&&(pr1RB==pr3RC))
					||((op4==ADD||op4==ADC||op4==ADZ||op4==NDU||op4==NDC||op4==NDZ)&&(pr1RB==pr4RC))
					||((op5==ADD||op5==ADC||op5==ADZ||op5==NDU||op5==NDC||op5==NDZ)&&(pr1RB==pr5RC))
					||((op2[5:2]==ADI)&&(pr1RB==pr2RB))||((op3[5:2]==ADI)&&(pr1RB==pr3RB))||
					((op4[5:2]==ADI)&&(pr1RB==pr4RB))||((op5[5:2]==ADI)&&(pr1RB==pr5RB))))
				begin
				
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				pc_write = 1'b1; 
				IR_write=1'b1;
				IR_load_mux=1'b0;
				end
					
				
			
			else if(op1[5:2]==JLR)
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b0;
				flush_if_id=1'b1;
				pc_write = 1'b1; 
				IR_write=1'b0;
				IR_load_mux=1'b0;
				end
			else if(op2[5:2]==JLR)
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b1;
				pc_write = 1'b1; 
				IR_write=1'b0;
				IR_load_mux=1'b0;
				end
			else  if(op1[5:2]==LM||op1[5:2]==SM)
					begin
					new_IR_multi[15:0]=pr1_IR[15:0];
					if(LM_Imm[0]==1)
					begin

					pc_write=1'b1;
					new_IR_multi[0]=1'b0;
					end
					else if(LM_Imm[1]==1)
					begin
					
					pc_write=1'b1;
						new_IR_multi[1]=1'b0;
					end
					else if(LM_Imm[2]==1)
					begin
					
					pc_write=1'b1;
					new_IR_multi[2]=1'b0;
					end
					else if(LM_Imm[3]==1)
					begin
					
					pc_write=1'b1;
					new_IR_multi[3]=1'b0;
					end
					else if(LM_Imm[4]==1)
					begin
					
					pc_write=1'b1;
					new_IR_multi[4]=1'b0;
					end
					else if(LM_Imm[5]==1)
					begin
					
					pc_write=1'b1;//back
					new_IR_multi[5]=1'b0;
					end
					else if(LM_Imm[6]==1)
					begin
					
					pc_write=1'b1;
					new_IR_multi[6]=1'b0;
					end
					else if(LM_Imm[7]==1)
					begin
					IR_load_mux=1'b0;
					new_IR_multi[7]=1'b0;
					pc_write=1'b0;
					end
					else 
					begin //LM/sm 00000000
					IR_load_mux=1'b0;
					new_IR_multi[7]=1'b0;
					pc_write=1'b0;
					end
					if(new_IR_multi[7:0] ==8'b0)
					begin
					IR_load_mux = 1'b0;
					pc_write=1'b0;
					end
					else 
					IR_load_mux = 1'b1;
					
					
			
			 if((op1[5:2]==LM)&&(op2[5:2]==LW||op2[5:2]==LM)&&(pr1RA==pr2RA)) //lw/lm followed by LM  
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				IR_write=1'b1;
				//IR_load_mux=1'b0;
				end
			else if((op1[5:2]==SM)&&(op2[5:2]==LM||op2[5:2]==LW||op2[5:2]==LHI)&&(pr1RA==pr2RA)) 
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				 IR_write=1'b1;
				//IR_load_mux=1'b0; 
				end
			else if((op1[5:2]==LM)&&pr1RA==3'b111) //
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b1;
				flush_if_id=1'b0;
				IR_write=1'b1;
				//IR_load_mux=1'b0;
				end
			else 
				begin
				flush_reg_ex=1'b0;
				flush_id_reg=1'b0;
				flush_if_id=1'b0;
				IR_write=1'b0;
				//IR_load_mux=1'b0;
				end
		end	
			
			else 
			begin
			flush_reg_ex=1'b0;
			flush_id_reg=1'b0;
			flush_if_id=1'b0;
			pc_write=1'b0;
			IR_load_mux=1'b0;
			IR_write=1'b0;
			end
		end		
endmodule