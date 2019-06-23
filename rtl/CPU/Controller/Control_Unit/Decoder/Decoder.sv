module ARM_Pipelined_Decoder
	(input logic[1:0]	i_Op,
	input logic[5:0]	i_Funct,
	input logic[3:0]	i_Rd,

	output logic		o_PC_Src_Decode,
	output logic		o_Reg_Write_Decode, o_Mem_Write_Decode,
	output logic		o_Mem_To_Reg_Decode,
	output logic[1:0]	o_ALU_Control_Decode,
	output logic		o_ALU_Src_Decode,
	output logic[1:0]	o_Reg_Src_Decode, o_Imm_Src_Decode,
	output logic[1:0]	o_Flag_Write_Decode,
	output logic		o_No_Write_Decode);

	logic		s_Reg_Write_Decode, s_Branch;
	logic		s_ALU_Op;


	ARM_Pipelined_PC_Logic		PC_Logic
	(i_Rd,
	s_Branch,
	s_Reg_Write_Decode,
	o_PC_Src_Decode);

	ARM_Pipelined_MainDecoder	Main_Decoder
	(i_Op,
	{i_Funct[5], i_Funct[0]},
	o_Reg_Write_Decode, o_Mem_Write_Decode,
	o_Mem_To_Reg_Decode,
	o_ALU_Src_Decode,
	o_Reg_Src_Decode, o_Imm_Src_Decode,
	s_Branch,
	s_ALU_Op);

	ARM_Pipelined_ALUDecoder
	(i_Funct[4:0],
	s_ALU_Op,
	o_ALU_Control_Decode,
	o_Flag_Write_Decode,
	o_No_Write_Decode);

endmodule

