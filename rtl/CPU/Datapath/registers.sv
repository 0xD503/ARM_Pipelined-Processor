module ARM_Pipelined_Register
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_ENABLE,
	input logic[(BusWidth - 1):0]	i_In,
	output logic[(BusWidth - 1):0]	o_Out);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)		o_Out <= 32'h00000000;
		else if (i_ENABLE)	o_Out <= i_In;
	end

endmodule



module ARM_Pipelined_Register_NE
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic[(BusWidth - 1):0]	i_In,
	output logic[(BusWidth - 1):0]	o_Out);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)	o_Out <= 32'h00000000;
		else			o_Out <= i_In;
	end

endmodule

