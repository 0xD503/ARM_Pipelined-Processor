module ARM_Pipelined_Controller
	#(parameter	BusWidth	= 32)
	(input logic		i_CLK, i_NRESET,
	input logic

	input logic[3:0]	i_Cond,
	input logic[1:0]	i_Op,
	input logic[5:0]	i_Funct,
	input logic[3:0]	i_Rd,

	input logic[3:0]	i_ALU_Flags,


	output logic		o_PC_Src_WriteBack,
	output logic		o_Branch_Taken_Execute,
	output logic[1:0]	o_Reg_Src_Decode, o_Imm_Src_Decode,
	output logic		o_ALU_Src_Execute,
	output logic[1:0]	o_ALU_Control_Execute,
	output logic		o_Reg_Write_Memory, o_Reg_Write_WriteBack,
	output logic		o_Mem_Write_Memory, o_Mem_Write_WriteBack,


	input logic			i_Flush_Execute,
	output logic		o_Mem_To_Reg_Execute);


endmodule

