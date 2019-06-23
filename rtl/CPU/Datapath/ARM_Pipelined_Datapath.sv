module ARM_Pipelined_Datapath
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,

	//	Control unit
	input logic						i_PC_Src_WriteBack,
	input logic						i_Branch_Taken_Execute,
	input logic[1:0]				i_Reg_Src_Decode, i_Imm_Src_Decode,
	input logic						i_Reg_Write_WriteBack,
	input logic						i_ALU_Src_Execute,
	input logic[1:0]				i_ALU_Control_Execute,
	input logic						i_Mem_To_Reg_Writeback,

	output logic[1:0]				o_Op,
	output logic[5:0]				o_Funct,
	output logic[3:0]				o_Rd,
	output logic[3:0]				o_Cond,

	output logic[3:0]				o_ALU_Flags,

	//	Memory
	input logic[(BusWidth - 1):0]	i_Instr_Fetch,
	output logic[(BusWidth - 1):0]	o_PC, o_Data_Addr,

	output logic[(BusWidth - 1):0]	o_Write_Data,	//	Instruction/Data
	input logic[(BusWidth - 1):0]	i_Read_Data,

	//	Hazard unit
	input logic						i_Stall_Fetch, i_Stall_Decode,
	input logic						i_Flush_Decode, i_Flush_Execute,
	input logic[1:0]				i_Forward_A_Execute, i_Forward_B_Execute,

	output logic[(BusWidth - 1):0]	o_RegFile_Data_Execute_1, o_RegFile_Data_Execute_2,
	output logic[3:0]	o_DestReg_Memory, o_DestReg_WriteBack);


	logic[(BusWidth - 1):0]	s_PC_Write_Src_0, s_PC_Write_Src_1, s_PC_Write;
	logic					s_PC_Write_Select;

	logic[(BusWidth - 1):0]	s_PC_Src_0, s_PC_Src_1, s_PC;
	logic					s_PC_Select;

	//	Fetch stage
	logic[(BusWidth - 1):0]	s_PC_In, s_PC_Fetch;
	logic[(BusWidth - 1):0]	s_PC_Plus8;
	logic					s_Instr_EN, s_Instr_CLR;
	logic[(BusWidth - 1):0]	s_Instr_Fetch;

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

	logic					s_RegFile_WriteEN;
	logic[3:0]				s_RegFile_Address_1, s_RegFile_Address_2, s_RegFile_Write_Address;
	logic[(BusWidth - 1):0]	s_RegFile_Write_Data;
	logic[(BusWidth - 1):0]	s_RegFile_R15;
	logic[(BusWidth - 1):0]	s_RegFile_Out_1, s_RegFile_Out_2;

	logic[(BusWidth - 1):0]	s_DecodedInstr_CLR;
	logic[(BusWidth - 1):0]	s_DecodedInstr_In_0, s_DecodedInstr_In_1, s_DecodedInstr_In_2, s_DecodedInstr_In_3;
	logic[(BusWidth - 1):0]	s_RegFile_Data_A1, s_RegFile_Data_A2, s_Extended_Data_Execute;
	logic[3:0]				s_Write_A3_Execute;

	//	Execute stage pins
	logic[(BusWidth - 1):0]	s_ALU_Src_A_Execute_0, s_ALU_Src_A_Execute_1, s_ALU_Src_A_Execute_2, s_ALU_Src_A_Execute;
	logic[(BusWidth - 1):0]	s_ALU_Src_B_Execute_0, s_ALU_Src_B_Execute_1, s_ALU_Src_B_Execute_2, s_ALU_Src_B_Execute, s_ALU_Src_B;
	logic[1:0]				s_ALU_Src_A_Execute_Select, s_ALU_Src_B_Execute_Select, s_ALU_Src_B_Select;
	logic[(BusWidth - 1):0]	s_ALU_Src_B_0, s_ALU_Src_B_1;
	logic[(BusWidth - 1):0]	s_ALU_Result_Execute;

	logic[(BusWidth - 1):0]	s_Write_Data_Execute;
	logic[(BusWidth - 1):0]	s_ALU_In_A, s_ALU_In_B, s_ALU_Out_Y;
	logic[1:0]				s_ALU_Control;
	logic[3:0]				s_ALU_Flags;

	logic[(BusWidth - 1):0]	s_ExecuteRegister_In_0, s_ExecuteRegister_In_1;
	logic[3:0]				s_ExecuteRegister_In_2;
	logic[(BusWidth - 1):0]	s_ExecuteRegister_Out_0, s_ExecuteRegister_Out_1;
	logic[3:0]				s_ExecuteRegister_Out_2;

	//	Memory stage pins
	logic[(BusWidth - 1):0]	s_ALU_Out_Memory;
	logic[3:0]				s_Write_A3_Memory;
	logic[(BusWidth - 1):0]	s_MemoryRegister_In_0, s_MemoryRegister_In_1, s_MemoryRegister_In_2;

	//	WriteBack stage pins
	logic[(BusWidth - 1):0]	s_PC_Src_WriteBack_In;
	logic[(BusWidth - 1):0]	s_Result_WriteBack;
	logic[(BusWidth - 1):0]	s_Read_Data_WriteBack, s_ALU_Out_WriteBack;
	logic[3:0]				s_Write_A3_WriteBack;
	logic[(BusWidth - 1):0]	s_WriteBack_Mux_In_0, s_WriteBack_Mux_In_1;
	logic					s_WriteBack_Mux_Select;

	logic					s_Stall_Fetch;



	assign s_PC_Write_Src_0 = s_PC_Plus4;
	assign s_PC_Write_Src_1 = s_Result_WriteBack;

	assign s_PC_Write_Select = i_PC_Src_WriteBack;

	assign s_PC_Plus8 = s_PC_Plus4;

	ARM_Mux_2x1								PC_Src_Write_Mux
		(s_PC_Write_Src_0, s_PC_Write_Src_1,
		s_PC_Write_Select,
		s_PC_Write);


	assign s_PC_Src_0 = s_PC_Write;
	assign s_PC_Src_1 = s_ALU_Result_Execute;

	assign s_PC_Select = i_Branch_Taken_Execute;

	ARM_Mux_2x1								PC_Src_Mux
		(s_PC_Src_0, s_PC_Src_1,
		s_PC_Select,
		s_PC);


	assign s_PC_In = s_PC;
	assign s_Stall_Fetch = ~i_Stall_Fetch;

	ARM_Pipelined_ProgramCounter			PC
		(i_CLK, i_NRESET,
		s_Stall_Fetch,
		s_PC_In,
		s_PC_Fetch);


	assign o_PC = s_PC_Fetch;

	assign s_PC_Increcmenter_A = s_PC_Fetch;
	assign s_PC_Increcmenter_B = 32'd4;

	ARM_Adder								PC_Incrementer
		(s_PC_Increcmenter_A, s_PC_Increcmenter_B,
		s_PC_Plus4);


	assign s_Instr_EN = ~i_Stall_Decode;
	assign s_Instr_CLR = i_Flush_Decode;
	assign s_Instr_Fetch = i_Instr_Fetch;

	ARM_Pipelined_Register_sCLR				InstructionRegister
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


	assign s_RegFile_Address_1	= s_RegFileSrc_Mux_A1_Decode;
	assign s_RegFile_Address_2	= s_RegFileSrc_Mux_A2_Decode;
	assign s_RegFile_WriteEN	= i_Reg_Write_WriteBack;
	assign s_RegFile_Write_Data	= s_Result_WriteBack;
	assign s_RegFile_R15		= s_PC_Plus8;

	ARM_Pipelined_RegisterFile				RegisterFile
		(i_CLK, i_NRESET,
		s_RegFile_WriteEN,
		s_RegFile_Address_1, s_RegFile_Address_2, s_RegFile_Write_Address,
		s_RegFile_Write_Data,
		s_RegFile_R15,
		s_RegFile_Out_1, s_RegFile_Out_2);


	assign s_DecodedInstr_CLR = i_Flush_Execute;
	assign s_DecodedInstr_In_0 = s_RegFile_Out_1;
	assign s_DecodedInstr_In_1 = s_RegFile_Out_2;
	assign s_DecodedInstr_In_2 = s_Instr_Decode[15:12];
	assign s_DecodedInstr_In_3 = s_Extended_Data;

	ARM_Pipelined_QuadRegister_sCLR_NE	DecodeRegister
		(i_CLK, i_NRESET,
		s_DecodedInstr_CLR,
		s_DecodedInstr_In_0, s_DecodedInstr_In_1, s_DecodedInstr_In_2, s_DecodedInstr_In_3,
		s_RegFile_Data_A1, s_RegFile_Data_A2, s_Write_A3_Execute, s_Extended_Data_Execute);


	assign s_ALU_Src_A_Execute_0 = s_RegFile_Data_A1;
	assign s_ALU_Src_A_Execute_1 = s_Result_WriteBack;
	assign s_ALU_Src_A_Execute_2 = s_ALU_Out_Memory;
	assign s_ALU_Src_A_Execute_Select = i_Forward_A_Execute;


	ARM_Mux_4x1								ALU_Src_A_Execute_Mux
		(s_ALU_Src_A_Execute_0, s_ALU_Src_A_Execute_1, s_ALU_Src_A_Execute_2, 32'h00000000,
		s_ALU_Src_A_Execute_Select,
		s_ALU_Src_A_Execute);


	assign s_ALU_Src_B_Execute_0 = s_RegFile_Data_A2;
	assign s_ALU_Src_B_Execute_1 = s_Result_WriteBack;
	assign s_ALU_Src_B_Execute_2 = s_ALU_Out_Memory;
	assign s_ALU_Src_B_Execute_Select = i_Forward_B_Execute;

	ARM_Mux_4x1								ALU_Src_B_Execute_Mux
		(s_ALU_Src_B_Execute_0, s_ALU_Src_B_Execute_1, s_ALU_Src_B_Execute_2, 32'h00000000,
		s_ALU_Src_B_Execute_Select,
		s_ALU_Src_B);

	assign s_Write_Data_Execute = s_ALU_Src_B;


	assign s_ALU_Src_B_0 = s_ALU_Src_B;
	assign s_ALU_Src_B_1 = s_Extended_Data_Execute;
	assign s_ALU_Src_B_Select = i_ALU_Src_Execute;

	ARM_Mux_2x1								ALU_Src_B_Mux
		(s_ALU_Src_B_0, s_ALU_Src_B_1,
		s_ALU_Src_B_Select,
		s_ALU_Src_B_Execute);


	assign s_ALU_In_A = s_ALU_Src_A_Execute;
	assign s_ALU_In_B = s_ALU_Src_B_Execute;
	assign s_ALU_Control = i_ALU_Control_Execute;

	ARM_Pipelined_ALU						ALU
		(s_ALU_In_A, s_ALU_In_B,
		s_ALU_Control,
		s_ALU_Out_Y,
		s_ALU_Flags);

	assign s_ALU_Result_Execute = s_ALU_Out_Y;
	assign o_ALU_Flags = s_ALU_Flags;


	assign s_ExecuteRegister_In_0 = s_ALU_Result_Execute;
	assign s_ExecuteRegister_In_1 = s_Write_Data_Execute;
	assign s_ExecuteRegister_In_2 = s_Write_A3_Execute;

	ARM_Pipelined_TripleRegister_NE4			ExecuteRegister
		(i_CLK, i_NRESET,
		s_ExecuteRegister_In_0, s_ExecuteRegister_In_1, s_ExecuteRegister_In_2,
		s_ExecuteRegister_Out_0, s_ExecuteRegister_Out_1, s_ExecuteRegister_Out_2);

	assign o_Data_Addr = s_ExecuteRegister_Out_0;
	assign s_ALU_Out_Memory = s_ExecuteRegister_Out_0;
	assign o_Write_Data = s_ExecuteRegister_Out_1;


	assign s_ALU_Out_Memory = s_ExecuteRegister_Out_0;
	assign s_Write_A3_Memory = s_ExecuteRegister_Out_2;


	assign s_MemoryRegister_In_0 = i_Read_Data;
	assign s_MemoryRegister_In_1 = s_ALU_Out_Memory;
	assign s_MemoryRegister_In_2 = s_Write_A3_Memory;

	ARM_Pipelined_TripleRegister_NE			MemoryRegister
		(i_CLK, i_NRESET,
		s_MemoryRegister_In_0, s_MemoryRegister_In_1, s_MemoryRegister_In_2,
		s_Read_Data_WriteBack, s_ALU_Out_WriteBack, s_Write_A3_WriteBack);

	assign s_RegFile_Write_Address = s_Write_A3_WriteBack;


	assign s_WriteBack_Mux_In_0 = s_ALU_Out_WriteBack;
	assign s_WriteBack_Mux_In_1 = s_Read_Data_WriteBack;
	assign s_WriteBack_Mux_Select = i_Mem_To_Reg_Writeback;

	ARM_Mux_2x1								WriteBackMux
		(s_WriteBack_Mux_In_0, s_WriteBack_Mux_In_1,
		s_WriteBack_Mux_Select,
		s_Result_WriteBack);



	
	assign o_Op = s_Op;
	assign o_Funct = s_Funct;
	assign o_Rd = s_Rd;
	assign o_Cond = s_Condition;

	assign o_RegFile_Data_Execute_1 = s_RegFile_Data_A1;
	assign o_RegFile_Data_Execute_2 = s_RegFile_Data_A2;

	assign o_DestReg_Memory = s_Write_A3_Memory;

	assign o_DestReg_WriteBack = s_Write_A3_WriteBack;


endmodule

