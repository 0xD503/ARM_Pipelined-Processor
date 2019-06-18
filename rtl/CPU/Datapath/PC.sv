module ARM_Pipelined_ProgramCounter
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_ENABLE,
	input logic[(BusWidth - 1):0]	i_PC,
	output logic[(BusWidth - 1):0]	o_PC);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)		o_PC <= 32'h00000000;
		else if (i_ENABLE)	o_PC <= i_PC;
	end

endmodule

