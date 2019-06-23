module ARM_Pipelined_ControlUnit
	(input logic[1:0]	i_Op,
	input logic[5:0]	i_Funct,
	input logic[3:0]	i_Rd,

	output logic		o_PC_Source_Decode,
	output logic		o_Reg_Write_Decode, o_Mem_Write_Decode,
	output logic		o_Mem_To_Reg_Decode,
	output logic[1:0]	o_ALU_Control_Decode,
	output logic		o_ALU_Src_Decode,
	output logic[1:0]	o_Reg_Src_Decode, o_Imm_Src_Decode,
	output logic[1:0]	o_Flag_Write_Decode,
	output logic		o_No_Write_Decode,
	output logic		o_Branch_Decode);


	ARM_Pipelined_Decoder	Decoder
		(i_Op,
		i_Funct,
		i_Rd,
		o_PC_Source_Decode,
		o_Reg_Write_Decode, o_Mem_Write_Decode,
		o_Mem_To_Reg_Decode,
		o_ALU_Control_Decode,
		o_ALU_Src_Decode,
		o_Reg_Src_Decode, o_Imm_Src_Decode,
		o_Flag_Write_Decode,
		o_No_Write_Decode);

	assign o_Branch_Decode = (i_Op[1:0] == 2'b10) ?	1'b1 : 1'b0;

endmodule

