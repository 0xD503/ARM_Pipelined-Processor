module ARM_Adder
	#(parameter	BusWidth	= 32)
	(input logic[(BusWidth - 1):0]	i_In_A, i_In_B,
	output logic[(BusWidth - 1):0]	o_Out_Y);


	assign o_Out_Y = i_In_A + i_In_B;

endmodule

