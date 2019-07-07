module ARM_Pipelined_CPU
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,

	input logic[(BusWidth - 1):0]	i_Instr_Fetch,
	output logic[(BusWidth - 1):0]	o_PC,
	output logic[(BusWidth - 1):0]	o_Data_Addr,

	output logic[(BusWidth - 1):0]	o_Write_Data,
	input logic[(BusWidth - 1):0]	i_Read_Data);

	//	[Datapath]	Control Unit
	logic					s_PC_Src_WriteBack, s_Reg_Write_WriteBack, s_Mem_To_Reg_WriteBack;
	logic					s_Branch_Taken_Execute, s_ALU_Src_Execute;
	logic[1:0]				s_Reg_Src_Decode, s_Imm_Src_Decode;
	logic[1:0]				s_ALU_Control_Execute;
	logic[1:0]				s_Op;
	logic[5:0]				s_Funct;
	logic[3:0]				s_Rd;
	logic[3:0]				s_Cond;
	logic[3:0]				s_ALU_Flags;
	logic					s_Mem_To_Reg_Writeback;


	//	[Datapath]	Hazard Unit
	logic					s_Stall_Fetch;
	logic					s_Flush_Decode, s_Stall_Decode;
	logic					s_Flush_Execute;
	logic[1:0]				s_Forward_A_Execute, s_Forward_B_Execute;
	logic[(BusWidth - 1):0]	s_RegFile_Data_Execute_1, s_RegFile_Data_Execute_2;
	logic[3:0]				s_DestReg_Memory, s_DestReg_WriteBack;

	//	[Control Unit]	Hazard Unit
	logic					s_SCLR;
	logic					s_Reg_Write_Memory;

	logic					s_Mem_Write_Memory;



	ARM_Pipelined_Datapath			Datapath
		(i_CLK, i_NRESET,

		//	Control unit
		s_PC_Src_WriteBack,
		s_Branch_Taken_Execute,
		s_Reg_Src_Decode, s_Imm_Src_Decode,
		s_Reg_Write_WriteBack,
		s_ALU_Src_Execute,
		s_ALU_Control_Execute,
		s_Mem_To_Reg_Writeback,
		s_Op,
		s_Funct,
		s_Rd,
		s_Cond,
		s_ALU_Flags,

		//	Memory
		i_Instr_Fetch,
		o_PC, o_Data_Addr,
		o_Write_Data,		//	Instruction/Data
		i_Read_Data,

		//	Hazard unit
		s_Stall_Fetch, s_Stall_Decode,
		s_Flush_Decode, s_Flush_Execute,
		s_Forward_A_Execute, s_Forward_B_Execute,
		s_RegFile_Data_Execute_1, s_RegFile_Data_Execute_2,
		s_DestReg_Memory, s_DestReg_WriteBack);


	ARM_Pipelined_Controller		Controller
		(i_CLK, i_NRESET,
		s_SCLR,

		s_Cond,
		s_Op,
		s_Funct,
		s_Rd,
		s_ALU_Flags,

		s_PC_Src_WriteBack,
		s_Branch_Taken_Execute,
		s_Reg_Src_Decode, s_Imm_Src_Decode,
		s_ALU_Src_Execute,
		s_ALU_Control_Execute,
		s_Reg_Write_Memory, s_Reg_Write_WriteBack,
		s_Mem_Write_Memory,

		s_Flush_Execute,
		s_Mem_To_Reg_WriteBack);




endmodule
