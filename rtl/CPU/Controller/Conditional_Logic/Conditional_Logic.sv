module ARM_Pipelined_ConditionalLogic
	(input logic		i_CLK, i_NRESET,

	input logic[3:0]	i_Cond,
	input logic[3:0]	i_ALU_Flags,

	input logic[1:0]	i_Flag_Write_Execute,
	input logic			i_PC_Src_Execute,
	input logic			i_Reg_Write_Execute, i_Mem_Write,
	input logic			i_No_Write,

	output logic		o_PC_Source_Execute,
	output logic		o_Reg_Write_Execute, o_Mem_Write_Execute,
	output logic		o_Mem_To_Reg_Execute,
	output logic[1:0]	o_ALU_Control_Execute,
	output logic		o_ALU_Src_Execute,
	output logic[1:0]	o_Reg_Src_Execute, o_Imm_Src_Execute);




endmodule

