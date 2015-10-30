module mux_16_2(data0, data1, selectInput, out);  // 2-16bit-input mux

	output reg [15:0] out;
	input  [15:0] data0, data1;
	input  selectInput;
	
	always@(*) begin
		case(selectInput)
			0: out = data0;
			1: out = data1;
		endcase
	end
	
endmodule