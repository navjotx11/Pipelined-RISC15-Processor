module forward_execution_stage(CCRMux_out,mem_wb_op,mem_wb_regA,mem_wb_regB,mem_wb_regC,ex_mem_op,ex_mem_regA,ex_mem_regB,ex_mem_regC,regread_ex_op,regread_ex_regA,regread_ex_regB,
regread_ex_regC,F1,F2,FRA,FCCR,mem_wb_CCR_write,ex_mem_CCR_write,writer7,writerf,wb_pr_op,wb_pr_regA,wb_pr_regB,wb_pr_regC,wb_pr_CCR_write,Fz);

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
parameter z = 3'd4;
input [2:0] mem_wb_regA,mem_wb_regB,mem_wb_regC,ex_mem_regA,ex_mem_regB,ex_mem_regC,regread_ex_regA,regread_ex_regB,regread_ex_regC, wb_pr_regA,wb_pr_regB,wb_pr_regC;
input [1:0] CCRMux_out;
input [5:0]	mem_wb_op,ex_mem_op,regread_ex_op,wb_pr_op;
input 		mem_wb_CCR_write,ex_mem_CCR_write,wb_pr_CCR_write;
output reg [2:0]	F1,F2,FRA;
output reg 			Fz;
output reg [1:0]	FCCR;
output reg 			writerf,writer7;

			
always @ (*)//F1
begin

	if(regread_ex_op==ADD||regread_ex_op==NDU||regread_ex_op==ADC||regread_ex_op==ADZ||regread_ex_op[5:2]==ADI||regread_ex_op==NDC||regread_ex_op==NDZ)
			begin        // for  operators
					
					if((regread_ex_regA==ex_mem_regC)&&(ex_mem_op==ADD||ex_mem_op==NDU||ex_mem_op==ADC||ex_mem_op==ADZ||ex_mem_op==NDC||ex_mem_op==NDZ)&&(ex_mem_CCR_write==1'b0))
						F1 = 3'b1;//a
					
					else if((regread_ex_regA == ex_mem_regB)&&(ex_mem_op[5:2]==ADI)&&(ex_mem_CCR_write==1'b0))
					
						F1 = 3'b1;//a
					
					else if((regread_ex_regA==ex_mem_regA)&&(ex_mem_op[5:2]==LHI))
						F1 = 3'd5;//i
				
					else if((regread_ex_regA==mem_wb_regC)&&(mem_wb_op==ADD||mem_wb_op==NDU||mem_wb_op==ADC
						||mem_wb_op==ADZ||mem_wb_op==NDC
						||mem_wb_op==NDZ)&&(mem_wb_CCR_write==1'b0))
						F1 = 3'd2;//b
						
					
					
					else if((regread_ex_regA==mem_wb_regA)&&(mem_wb_op[5:2]==LHI))
						F1 = 3'd6;//j
					else if((regread_ex_regA == mem_wb_regA)&&(mem_wb_op[5:2] ==LW||mem_wb_op[5:2] ==LM))
					
						F1 = 3'd3; //forwarded from memory
					else if((regread_ex_regA == mem_wb_regA)&&(mem_wb_op[5:2] == JAL))
							
						F1 = 3'd7; //forwarded PC+1
					else if((regread_ex_regA == mem_wb_regB)&&(mem_wb_op[5:2]==ADI)
						&&(mem_wb_CCR_write==1'b0))
						F1 = 3'd2;//b
							
							
					else if((regread_ex_regA==wb_pr_regC)&&(wb_pr_op==ADD||wb_pr_op==NDU||wb_pr_op==ADC
						||wb_pr_op==ADZ||wb_pr_op==NDC
						||wb_pr_op==NDZ)&&(wb_pr_CCR_write==1'b0))
							F1 = z;	
					else if((regread_ex_regA==wb_pr_regA)&&(wb_pr_op[5:2]==LHI))
						F1 = z;
					else if((regread_ex_regA == wb_pr_regA)&&(wb_pr_op[5:2] ==LW||wb_pr_op[5:2] ==LM))
					
						F1 = z; //forwarded from memory
					else if((regread_ex_regA == wb_pr_regA)&&(wb_pr_op[5:2] == JAL))
						
						F1 = z; //forwarded PC+1
					else if((regread_ex_regA == wb_pr_regB)&&(wb_pr_op[5:2]==ADI)
						&&(wb_pr_CCR_write==1'b0))
							F1 = z;//b
					else if((regread_ex_regA == wb_pr_regA)&&(wb_pr_op[5:2] == JLR))
							
						F1 = z; //forwarded PC+1
							
					else //no hazard, given the current instruction is op
						F1 = 3'b0;
					
			end			// for  operators
				
				
		else 
				F1 = 3'b0;
				
end


always @(*)//FZ
begin
	if(regread_ex_op[5:2]==SW)
		begin
		if((regread_ex_regA==wb_pr_regC)&&(wb_pr_op==ADD||wb_pr_op==NDU||wb_pr_op==ADC||wb_pr_op==ADZ||wb_pr_op==NDC||wb_pr_op==NDZ)
		&&(wb_pr_CCR_write==1'b0))              
										
										
		Fz=1'b1;
		else if((regread_ex_regA==wb_pr_regB)&&(wb_pr_op[5:2]==ADI))
		Fz=1'b1;
		else
		Fz=1'b0;
		end
	else 
		Fz=1'b0;
end//always 

		
always @(*)//FRA
begin
	if(regread_ex_op[5:2]==LM||regread_ex_op[5:2]==SM) 
				begin
					
					if((regread_ex_regA == ex_mem_regC)&&(ex_mem_op==ADD||ex_mem_op==NDU
					||ex_mem_op==ADC||ex_mem_op==ADZ
								||ex_mem_op==NDC||ex_mem_op==NDZ)&&(ex_mem_CCR_write==1'b0))
						FRA = 3'b1;//a
					else if((regread_ex_regA==ex_mem_regA)&&(ex_mem_op[5:2]==LHI))
						FRA = 3'd5;//i
					else if((regread_ex_regA == ex_mem_regB)&&(ex_mem_op[5:2]==ADI)&&(ex_mem_CCR_write==1'b0))
						FRA = 3'b1;//a
					
					
					else if((regread_ex_regA == mem_wb_regC)&&(mem_wb_op==ADD||mem_wb_op==NDU||mem_wb_op==ADC
								||mem_wb_op==ADZ||mem_wb_op==NDC
								||mem_wb_op==NDZ)&&(mem_wb_CCR_write==1'b0))
						FRA = 3'd2;//b
					else if((regread_ex_regA==mem_wb_regA)&&(mem_wb_op==LHI))
						FRA = 3'd6;//j		
					else if((regread_ex_regA == mem_wb_regB)&&(mem_wb_op[5:2]==ADI)&&(mem_wb_CCR_write==1'b0))
						FRA = 3'd2;//b
					else	if((regread_ex_regA == mem_wb_regA)&&(mem_wb_op[5:2]==LW||mem_wb_op[5:2]==LM))
						FRA = 3'd3;
					else if((regread_ex_regA == mem_wb_regA)&& (mem_wb_op[5:2] ==JAL))
						FRA = 3'd7;//k -> PC+1
					
					
					else if((regread_ex_regA == wb_pr_regC)&&(wb_pr_op==ADD||wb_pr_op==NDU||wb_pr_op==ADC
								||wb_pr_op==ADZ||wb_pr_op==NDC
								||wb_pr_op==NDZ)&&(wb_pr_CCR_write==1'b0))
						FRA = z;
					else if((regread_ex_regA==wb_pr_regA)&&(wb_pr_op==LHI))
						FRA =z;	
					else if((regread_ex_regA == wb_pr_regB)&&(wb_pr_op[5:2]==ADI)&&(wb_pr_CCR_write==1'b0))
						FRA = z;
					else	if((regread_ex_regA == wb_pr_regA)&&(wb_pr_op[5:2]==LW||wb_pr_op[5:2]==LM))
						FRA = z;
					else if((regread_ex_regA == wb_pr_regA)&& (wb_pr_op[5:2] ==JAL))
						FRA = z;
					else if((regread_ex_regA == wb_pr_regA)&& (wb_pr_op[5:2] ==JLR))
						FRA = z;	
						
						
				else 
					FRA = 3'b0; //no hazards,given current instruction is LM		
				end
		else 
			FRA = 3'd0;	
			
end			
			
always @ (*) //F2
begin

	if(regread_ex_op==ADD||regread_ex_op==NDU||regread_ex_op==ADC||regread_ex_op==ADZ||regread_ex_op==NDC||regread_ex_op==NDZ)//NO ADI as ADI has only regA
		begin        // for  operators		
					
			if((regread_ex_regB==ex_mem_regC)&&(ex_mem_op==ADD||ex_mem_op==NDU||ex_mem_op==ADC||ex_mem_op==ADZ
			||ex_mem_op==NDC||ex_mem_op==NDZ)&&(ex_mem_CCR_write==1'b0))
			
				F2 = 3'b1;
			else	if((regread_ex_regB == ex_mem_regB)&&(ex_mem_op[5:2]==ADI)&&(ex_mem_CCR_write==1'b0))
				F2 = 3'b1;
			else if((regread_ex_regB==ex_mem_regA)&&(ex_mem_op[5:2]==LHI))
			F2 = 3'd5;
		
			
			else if((regread_ex_regB==mem_wb_regC)&&(mem_wb_op==ADD||mem_wb_op==NDU||mem_wb_op==ADC
			||mem_wb_op==ADZ||mem_wb_op==NDC
			||mem_wb_op==NDZ)&&(mem_wb_CCR_write==1'b0))
				F2 = 3'd2;
			else if((regread_ex_regB == mem_wb_regB)&&(mem_wb_op[5:2]==ADI)&&(mem_wb_CCR_write==1'b0))
				F2 = 3'd2;
			else if((regread_ex_regB==mem_wb_regA)&&(mem_wb_op[5:2]==LHI))
			F2 = 3'd6;
			else	if((regread_ex_regB == mem_wb_regA)&&(mem_wb_op[5:2] ==LW||mem_wb_op[5:2] ==LM))
			
				F2 = 3'd3;
			else if((regread_ex_regB == mem_wb_regA)&&(mem_wb_op[5:2] == JAL))
			
			F2 = 3'd7; //forwarded PC+1
		
		
			else if((regread_ex_regB==wb_pr_regC)&&(wb_pr_op==ADD||wb_pr_op==NDU||wb_pr_op==ADC
			||wb_pr_op==ADZ||wb_pr_op==NDC
			||wb_pr_op==NDZ)&&(wb_pr_CCR_write==1'b0))
				F2 = z;	
			else if((regread_ex_regB==wb_pr_regA)&&(wb_pr_op[5:2]==LHI))
					F2 = z;
			else if((regread_ex_regB == wb_pr_regA)&&(wb_pr_op[5:2] ==LW||wb_pr_op[5:2] ==LM))
			
					F2 = z; //forwarded from memory
			else if((regread_ex_regB == wb_pr_regA)&&(wb_pr_op[5:2] == JAL))
					
					F2 = z; //forwarded PC+1
			else if((regread_ex_regB == wb_pr_regB)&&(wb_pr_op[5:2]==ADI)
				&&(wb_pr_CCR_write==1'b0))
					F2 = z;//b
			else if((regread_ex_regB == wb_pr_regA)&&(wb_pr_op[5:2] == JLR))
					
					F2 = z; //forwarded PC+1
		
			
			
			else 
				F2 = 3'd0;//no hazards when current instruction is op
		
				
		end			// for  operators
		
		
		
		else if(regread_ex_op[5:2]==LW||regread_ex_op[5:2]==SW)
			begin
				
				if((regread_ex_regB == ex_mem_regC)&&(ex_mem_op==ADD||ex_mem_op==NDU||ex_mem_op==ADC||ex_mem_op==ADZ
							||ex_mem_op==NDC||ex_mem_op==NDZ)&&(ex_mem_CCR_write==1'b0))
					F2 = 3'b1;//a
				
				else if((regread_ex_regB==ex_mem_regA)&&(ex_mem_op[5:2]==LHI))
						F2 = 3'd5;//i
				else if((regread_ex_regB==ex_mem_regB)&&ex_mem_op[5:2]==ADI)
						F2 = 3'd1;//a
						
						
				else if((regread_ex_regB == mem_wb_regC)&&(mem_wb_op==ADD||mem_wb_op==NDU||mem_wb_op==ADC
								||mem_wb_op==ADZ||mem_wb_op==NDC
								||mem_wb_op==NDZ)&&(mem_wb_CCR_write==1'b0))
						F2 = 3'd2;//b
				else if((regread_ex_regB==mem_wb_regA)&&(mem_wb_op[5:2]==LHI))
						F2 = 3'd6;//j	
				else if((regread_ex_regB==mem_wb_regB)&&ex_mem_op[5:2]==ADI)
						F2 = 3'd2;//b
				else if((regread_ex_regB == mem_wb_regA)&&(mem_wb_op[5:2]==LW||mem_wb_op[5:2]==LM))
						F2 = 3'd3;//from memory
					else if((regread_ex_regB == mem_wb_regA)&& (mem_wb_op[5:2] ==JAL))
						F2 = 3'd7;//k -> PC+1
						
				
				else if((regread_ex_regB == wb_pr_regC)&&(wb_pr_op==ADD||wb_pr_op==NDU||wb_pr_op==ADC
								||wb_pr_op==ADZ||wb_pr_op==NDC
								||wb_pr_op==NDZ)&&(wb_pr_CCR_write==1'b0))
						F2 = z;
				else if((regread_ex_regB==wb_pr_regA)&&(wb_pr_op[5:2]==LHI))
						F2 = z;	
				else if((regread_ex_regB==wb_pr_regB)&&ex_mem_op[5:2]==ADI)
						F2 = z;
				else if((regread_ex_regB == wb_pr_regA)&&(wb_pr_op[5:2]==LW||wb_pr_op[5:2]==LM))
						F2 = z;
				else if((regread_ex_regB == wb_pr_regA)&& (wb_pr_op[5:2] ==JAL))
						F2 = z;
				else if((regread_ex_regB == wb_pr_regA)&& (wb_pr_op[5:2] ==JAL))
						F2 = z;
				
					
				else 
				F2 = 3'b0; //no hazards,given current instruction is LW/SW
			
			end
			
			
		else 
			F2 = 3'b0;
end


			

always @(*) //FCCR, write signals
begin
if(regread_ex_op==ADC||regread_ex_op==ADZ||regread_ex_op==NDC||regread_ex_op==NDZ) 
		begin
	
				if((ex_mem_op==ADD||ex_mem_op==NDU||ex_mem_op==ADC||ex_mem_op==ADZ||ex_mem_op[5:2]==ADI||ex_mem_op==NDC||ex_mem_op==NDZ)&&(ex_mem_CCR_write==1'b0))//if the current op is conditional on CCR, CCR needs to be forwarded
					begin
					FCCR = 2'b1;
						if(regread_ex_regC==3'b111)
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
						else 
						if((regread_ex_op==ADC||regread_ex_op==NDC)&&(CCRMux_out[0] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else if ((regread_ex_op==ADZ||regread_ex_op==NDZ)&&(CCRMux_out[1] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else 
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
						
						
					end
				else if((ex_mem_op[5:2]==LW)&&(ex_mem_CCR_write==1'b0))
					begin
					FCCR = 2'b1;
						if(regread_ex_regC==3'b111)
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
						else
						if((regread_ex_op==ADC||regread_ex_op==NDC)&&(CCRMux_out[0] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else if ((regread_ex_op==ADZ||regread_ex_op==NDZ)&&(CCRMux_out[1] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else 
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
					end
					
				else if((mem_wb_op==ADD||mem_wb_op==NDU||mem_wb_op==ADC||mem_wb_op==ADZ||mem_wb_op[5:2]==ADI||mem_wb_op==NDC||mem_wb_op==NDZ)&&(mem_wb_CCR_write==1'b0))
					begin
					FCCR = 2'd2;
						if(regread_ex_regC==3'b111)
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
						else 
						if((regread_ex_op==ADC||regread_ex_op==NDC)&&(CCRMux_out[0] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else if ((regread_ex_op==ADZ||regread_ex_op==NDZ)&&(CCRMux_out[1] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else 
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
					end
				
				
				else if((mem_wb_op[5:2]==LW)&&(mem_wb_CCR_write==1'b0))
					begin
					FCCR = 2'd2;
						if(regread_ex_regC==3'b111)
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
						else 
						if((regread_ex_op==ADC||regread_ex_op==NDC)&&(CCRMux_out[0] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else if ((regread_ex_op==ADZ||regread_ex_op==NDZ)&&(CCRMux_out[1] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else 
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
					end
				else 
					begin
						FCCR = 2'b0;
						if(regread_ex_regC==3'b111)
							begin
								writer7=1'b0;
								writerf=1'b1;
							end
						else 
							if((regread_ex_op==ADC||regread_ex_op==NDC)&&(CCRMux_out[0] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else if ((regread_ex_op==ADZ||regread_ex_op==NDZ)&&(CCRMux_out[1] ==1'b1))
						begin
							writer7=1'b0;
							writerf=1'b0;
						end
						else 
						begin
							writer7=1'b0;
							writerf=1'b1;
						end
					end
				
			
		end

else if(regread_ex_op==ADD||regread_ex_op==NDU)
	begin
	FCCR = 2'b0;
				if(regread_ex_regC==3'b111)
				begin
					writer7=1'b0;
					writerf=1'b1;
				end
				else 
				begin
					writer7=1'b0;
					writerf=1'b0;	
				end
	end
else if(regread_ex_op[5:2]==ADI)
	begin
	FCCR = 2'b0;
				if(regread_ex_regB ==3'b111)
				begin
					writer7 = 1'b0;
					writerf=1'b1;
				end
				else 
				begin
					writer7=1'b0;
					writerf=1'b0;
				end
	end
else if(regread_ex_op[5:2]==LW||regread_ex_op[5:2]==LM||regread_ex_op[5:2]==LHI)
	begin
	FCCR = 2'b0;
				if(regread_ex_regA==3'b111)
				begin
					writer7=1'b0;
					writerf=1'b1;
				end
				else 
				begin
					writer7=1'b0;
					writerf=1'b0;	
				end
	end
else if(regread_ex_op[5:2]==JAL||regread_ex_op[5:2]==JLR)
	begin
	FCCR=2'b0;
		writer7=1'b0;
		writerf=1'b0;
	end 			//jump operations, which modify registers

else
	begin
	FCCR=1'b0;
	writer7=1'b0;
	writerf=1'b1;    //for beq
	end
	
end

endmodule