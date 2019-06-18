module ARM_Pipelined_Datapath
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,

	input logic[1:0]				i_Reg_Src_Decode, i_Imm_Src_Decode,
	//input logic						i_Mem_To_Reg, i_Reg_Write,
	//input logic						i_ALU_Control, i_ALU_Src,
	//input logic						i_Imm_Src,

	input logic[(BusWidth - 1):0]	i_Instr,
	output logic[(BusWidth - 1):0]	o_PC, o_Data_Addr,

	output logic[(BusWidth - 1):0]	o_Write_Data,	//	Instruction/Data
	input logic[(BusWidth - 1):0]	i_Read_Data,
	
	output logic					o_ALU_Flags,

	//	Hazard unit
	input logic						i_Stall_Fetch, i_Stall_Decode,
	input logic						i_Flush_Decode, i_Flush_Execute,
	input logic						i_Forward_A_Execute, i_Forward_B_Execute,
	
	output logic					o_Match);

	logic[(BusWidth - 1):0]	s_PC_Write_Src_0, s_PC_Write_Src_1, s_PC_Write;
	logic					s_PC_Write_Select;

	logic[(BusWidth - 1):0]	s_PC_Src_0, s_PC_Src_1, s_PC;
	logic					s_PC_Select;

	//	Fetch stage
	logic[(BusWidth - 1):0]	s_PC_In, s_PC_Fetch;

	logic[(BusWidth - 1):0]	s_PC_Increcmenter_A, s_PC_Increcmenter_B, s_PC_Plus4;

	//	Decode stage pins
	logic[(BusWidth - 1):0]	s_Instr_Decode;

	logic[3:0]				s_Condition;
	logic[1:0]				s_Op;
	logic[5:0]				s_Funct;
	logic[3:0]				s_Rd;

	logic[3:0]				s_RegFileSrc_Mux_A1_0, s_RegFileSrc_Mux_A1_1, s_RegFileSrc_Mux_A1_Decode;
	logic					s_RegFileSrc_Mux_A1_Select;
	logic[3:0]				s_RegFileSrc_Mux_A2_0, s_RegFileSrc_Mux_A2_1, s_RegFileSrc_Mux_A2_Decode;
	logic					s_RegFileSrc_Mux_A2_Select;

	logic[23:0]				s_Immediate;
	logic[1:0]				s_Immediate_Select;
	logic[(BusWidth - 1):0]	s_Extended_Data;

	//	Execute stage pins
	logic[(BusWidth - 1):0]	s_ALU_Result_Execute;

	logic[(BusWidth - 1):0]	s_Branch_CondEx_Execute;

	//	Memory stage pins


	//	WriteBack stage pins
	logic[(BusWidth - 1):0]	s_PC_Src_WriteBack_In, s_PC_Src_WriteBack_Out;

	logic[(BusWidth - 1):0]	s_Result_Write;

	assign s_PC_Write_Src_0 = s_PC_Plus4;
	assign s_PC_Write_Src_1 = s_Result_Write;

	assign s_PC_Write_Select = s_PC_Src_WriteBack_Out;

	ARM_Mux_2x1						PC_Src_Write_Mux
		(s_PC_Write_Src_0, s_PC_Write_Src_1,
		s_PC_Write_Select,
		s_PC_Write);


	assign s_PC_Src_0 = s_PC_Write;
	assign s_PC_Src_1 = s_ALU_Result_Execute;

	assign s_PC_Select = s_Branch_CondEx_Execute;

	ARM_Mux_2x1						PC_Src_Mux
		(s_PC_Src_0, s_PC_Src_1,
		s_PC_Select,
		s_PC);


	assign s_PC_In = s_PC;
	assign s_Stall_Fetch = ~i_Stall_Fetch;

	ARM_Pipelined_ProgramCounter	PC
		(i_CLK, i_NRESET,
		s_Stall_Fetch,
		s_PC_In,
		s_PC_Fetch);


	assign o_PC = s_PC_Fetch;

	assign s_PC_Increcmenter_A = s_PC_Fetch;
	assign s_PC_Increcmenter_B = 32'd4;

	ARM_Adder						PC_Incrementer
		(s_PC_Increcmenter_A, s_PC_Increcmenter_B,
		s_PC_Plus4);


	assign s_Instr_EN = ~i_Stall_Decode;
	assign s_Instr_CLR = i_Flush_Decode;
	assign s_Instr_Fetch = i_Instr;

	ARM_Pipelined_Register_sCLR		InstructionRegister
		(i_CLK, i_NRESET,
		s_Instr_EN,
		s_Instr_CLR,
		s_Instr_Fetch,
		s_Instr_Decode);


	assign s_Condition	= s_Instr_Decode[31:28];
	assign s_Op			= s_Instr_Decode[27:26];
	assign s_Funct		= s_Instr_Decode[25:20];
	assign s_Rd			= s_Instr_Decode[15:12];


	assign s_RegFileSrc_Mux_A1_0 = s_Instr_Decode[19:16];
	assign s_RegFileSrc_Mux_A1_1 = 4'd15;
	assign s_RegFileSrc_Mux_A1_Select	= i_Reg_Src_Decode[0];


	ARM_4_bit_Mux_2x1						RegFileSrc_Mux_A1
		(s_RegFileSrc_Mux_A1_0, s_RegFileSrc_Mux_A1_1,
		s_RegFileSrc_Mux_A1_Select,
		s_RegFileSrc_Mux_A1_Decode);


	assign s_RegFileSrc_Mux_A2_0 = s_Instr_Decode[3:0];
	assign s_RegFileSrc_Mux_A2_1 = s_Instr_Decode[15:12];
	assign s_RegFileSrc_Mux_A2_Select	= i_Reg_Src_Decode[1];

	ARM_4_bit_Mux_2x1						RegFileSrc_Mux_A2
		(s_RegFileSrc_Mux_A2_0, s_RegFileSrc_Mux_A2_1,
		s_RegFileSrc_Mux_A2_Select,
		s_RegFileSrc_Mux_A2_Decode);


	assign s_Immediate = s_Instr_Decode[23:0];
	assign s_Immediate_Select = i_Imm_Src_Decode;

	ARM_Pipelined_ExtensionUnit				ExtensionUnit
		(s_Immediate,
		s_Immediate_Select,
		s_Extended_Data);


	

endmodule

