module ControlUnit
	(input logic[1:0]	i_Op,
	input logic[5:0]	i_Funct,
	input logic[3:0]	i_Rd,

	output logic		o_PC_Source_Decode,
	output logic		o_Reg_Write_Decode,
	output logic		o_Mem_To_Reg_Decode, o_Mem_Write_Decode,
	output logic[1:0]	o_ALU_Control_Decode,
	output logic		o_ALU_Src_Decode,
	output logic		o_Branch_Decode,
	output logic		o_Flag_Write_Decode,
	output logic[1:0]	o_Reg_Src_Decode, o_Imm_Src_Decode);



endmodule

