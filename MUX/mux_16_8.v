module mux_16_8(data0, data1, data2, data3, data4, data5, data6, data7, selectInput, out);  // 8-16bit-input mux

	output reg [15:0] out;
	input  [15:0] data0, data1, data2, data3, data4, data5, data6, data7;
	input  [2:0] selectInput;
	
	always @(*)begin
		case(selectInput)
			0: out = data0;
			1: out = data1;
			2: out = data2;
			3: out = data3;
			4: out = data4;
			5: out = data5;
			6: out = data6;
			7: out = data7;
		endcase
	end
	
endmodule