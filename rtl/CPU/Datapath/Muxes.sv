module ARM_Mux_2x1
	#(parameter	BusWidth	= 32)
	(input logic[(BusWidth - 1):0]	i_In_0, i_In_1,
	input logic						i_SelectInput,
	output logic[(BusWidth - 1):0]	o_Output);


	assign o_Output = (i_SelectInput) ?	i_In_1 : i_In_0;

endmodule



module ARM_4_bit_Mux_2x1
	#(parameter	BusWidth	= 4)
	(input logic[(BusWidth - 1):0]	i_In_0, i_In_1,
	input logic						i_SelectInput,
	output logic[(BusWidth - 1):0]	o_Output);


	assign o_Output = (i_SelectInput) ?	i_In_1 : i_In_0;

endmodule



module ARM_Mux_4x1
	#(parameter	BusWidth	= 32)
	(input logic[(BusWidth - 1):0]	i_In_0, i_In_1, i_In_2, i_In_3,
	input logic[1:0]				i_InputSelect,
	output logic[(BusWidth - 1):0]	o_Out);


	always_comb
	begin
		case (i_InputSelect)
			2'b00:	o_Out = i_In_0;
			2'b01:	o_Out = i_In_1;
			2'b10:	o_Out = i_In_2;
			2'b11:	o_Out = i_In_3;

			default:	o_Out = i_In_0;
		endcase
	end

endmodule

