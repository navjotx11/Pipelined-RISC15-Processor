module mux_16_4(data0, data1, data2, data3, selectInput, out);  // 4-16bit-input mux

	output reg [15:0] out;
	input  [15:0] data0, data1, data2, data3;
	input  [1:0] selectInput;
	
	always@(data0 or data1 or data2 or data3 or selectInput) begin
		case(selectInput)
			0: out = data0;
			1: out = data1;
			2: out = data2;
			3: out = data3;
		endcase
	end
	
endmodule