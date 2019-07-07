module ARM_Pipelined_HazardUnit
	#(parameter	BusWidth	= 32)
	(input logic[3:0]	i_RegFile_RA_1E, i_RegFile_RA_2E,
	input logic[3:0]	i_RegFile_WA_M, i_RegFile_WA_W,
	input logic			i_Reg_Write_Memory, i_Reg_Write_WriteBack,
	input logic			i_Mem_To_Reg_Execute,

	output logic		o_Stall_Fetch, o_Stall_Decode,
	output logic		o_Flush_Decode, o_Flush_Execute,
	output logic[1:0]	o_Forward_A_Execute, o_Forward_B_Execute);

	logic			s_Match_1E_M, s_Match_2E_M;
	logic			s_Match_1E_W, s_Match_2E_W;


	assign s_Match_1E_M = (i_RegFile_RA_1E == i_RegFile_WA_M);
	assign s_Match_1E_W = (i_RegFile_RA_1E == i_RegFile_WA_W);
	assign s_Match_2E_M = (i_RegFile_RA_2E == i_RegFile_WA_M);
	assign s_Match_2E_W = (i_RegFile_RA_2E == i_RegFile_WA_W);

	always_comb
	begin
		if (s_Match_1E_M && i_Reg_Write_Memory)			o_Forward_A_Execute = 2'b10;
		else if (s_Match_1E_W && i_Reg_Write_WriteBack)	o_Forward_A_Execute = 2'b01;
		else											o_Forward_A_Execute = 2'b00;

		if (s_Match_2E_M && i_Reg_Write_Memory)			o_Forward_B_Execute = 2'b10;
		else if (s_Match_2E_W && i_Reg_Write_WriteBack)	o_Forward_B_Execute = 2'b01;
		else											o_Forward_B_Execute = 2'b00;
	end


endmodule
