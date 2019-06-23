module ARM_Pipelined_ConditionUnit
	(input logic		i_CLK, i_NRESET,

	input logic[1:0]	i_Flag_Write_Execute,
	input logic[3:0]	i_Cond_Execute,
	input logic[3:0]	i_Flags_Execute,

	output logic[3:0]	o_Flags,
	output logic		o_CondEx_Execute);

	logic[1:0]		s_Flags_NZ, s_Flags_CV;
	logic[1:0]		s_Flag_Write;
	logic			s_CondEx;


	ARM_Pipelined_ConditionCheck		ConditionCheck
	(i_Cond_Execute,
	s_Flags_NZ, s_Flags_CV,
	s_CondEx);


	assign s_Flags_NZ = i_Flags_Execute[3:2];
	assign s_Flags_CV = i_Flags_Execute[1:0];
	assign s_Flag_Write = (s_CondEx) ?	i_Flag_Write_Execute : 2'b00;

	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			s_Flags_NZ = 2'b00;
			s_Flags_CV = 2'b00;
		end
		else
		begin
			s_Flags_NZ = (s_Flag_Write[1]) ?	s_Flags_Execute[3:2] : s_Flags_NZ;
			s_Flags_CV = (s_Flag_Write[0]) ?	s_Flags_Execute[1:0] : s_Flags_CV;
		end
	end


	assign o_Flags = i_Flags_Execute;
	assign o_CondEx_Execute = s_CondEx;

endmodule

