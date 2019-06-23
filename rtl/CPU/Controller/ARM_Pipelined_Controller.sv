module ARM_Pipelined_Controller
	#(parameter	BusWidth	= 32)
	(input logic		i_CLK, i_NRESET,
	input logic			i_SCLR,

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
	output logic		o_Mem_Write_Memory,


	input logic			i_Flush_Execute,
	output logic		o_Mem_To_Reg_WriteBack);

	logic		s_PC_Src_Decode;
	logic		s_Reg_Write_Decode, s_Mem_Write_Decode;
	logic		s_Mem_To_Reg_Decode;
	logic[1:0]	s_ALU_Control_Decode;
	logic		s_ALU_Src_Decode;
	logic[1:0]	s_Flag_Write_Decode;
	logic		s_No_Write_Decode;
	logic		s_Branch_Decode;
	logic[3:0]	s_Cond_Decode;
	logic[3:0]	s_Flags_Decode;

	logic		s_PC_Src_Execute;
	logic		s_Reg_Write_Execute, s_Mem_Write_Execute;
	logic		s_Mem_To_Reg_Execute;
	logic[1:0]	s_ALU_Control_Execute;
	logic		s_ALU_Src_Execute;
	logic[1:0]	s_Flag_Write_Execute;
	logic		s_No_Write_Execute;
	logic		s_Branch_Execute;
	logic[3:0]	s_Cond_Execute;
	logic[3:0]	s_Flags_Execute;

	logic		s_PC_Src_Memory;
	logic		s_Reg_Write_Memory, s_Mem_Write_Memory;
	logic		s_Mem_To_Reg_Memory;

	logic		s_PC_Src_WriteBack;
	logic		s_Reg_Write_WriteBack;
	logic		s_Mem_To_Reg_WriteBack;

	//	Condition Unit pins
	logic[3:0]	s_Flags;
	logic		s_CondEx_Execute;
	logic		s_PC_Src_Taken_Execute;
	logic 		s_Reg_Write_Taken_Execute;
	logic 		s_Mem_Write_Taken_Execute;
	logic 		s_Branch_Taken_Execute;


	ARM_Pipelined_ControlUnit			ControlUnit
	(i_Op,
	i_Funct,
	i_Rd,

	s_PC_Src_Decode,
	s_Reg_Write_Decode, s_Mem_Write_Decode,
	s_Mem_To_Reg_Decode,
	s_ALU_Control_Decode,
	s_ALU_Src_Decode,
	o_Reg_Src_Decode, o_Imm_Src_Decode,
	s_Flag_Write_Decode,
	s_No_Write_Decode,
	s_Branch_Decode);

	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			s_PC_Src_Execute = 1'b0;
			s_Reg_Write_Execute = 1'b0;
			s_Mem_Write_Execute = 1'b0;
			s_Mem_To_Reg_Execute = 1'b0;
			s_ALU_Control_Execute = 2'b00;
			s_ALU_Src_Execute = 1'b0;
			s_Branch_Execute = 1'b0;
			s_Flag_Write_Execute = 2'b00;
			s_Cond_Execute = 1'b0;
			s_Flags_Execute = 4'b0000;
			s_No_Write_Execute = 1'b0;
		end
		else if (i_SCLR)
		begin
			s_PC_Src_Execute = 1'b0;
			s_Reg_Write_Execute = 1'b0;
			s_Mem_Write_Execute = 1'b0;
			s_Mem_To_Reg_Execute = 1'b0;
			s_ALU_Control_Execute = 2'b00;
			s_ALU_Src_Execute = 1'b0;
			s_Branch_Execute = 1'b0;
			s_Flag_Write_Execute = 2'b00;
			s_Cond_Execute = 1'b0;
			s_Flags_Execute = 4'b0000;
			s_No_Write_Execute = 1'b0;
		end
		else
		begin
			s_PC_Src_Execute = s_PC_Src_Decode;
			s_Reg_Write_Execute = s_Reg_Write_Decode;
			s_Mem_Write_Execute = s_Mem_Write_Decode;
			s_Mem_To_Reg_Execute = s_Mem_To_Reg_Decode;
			s_ALU_Control_Execute = s_ALU_Control_Decode;
			s_ALU_Src_Execute = s_ALU_Src_Decode;
			s_Branch_Execute = s_Branch_Decode;
			s_Flag_Write_Execute = s_Flag_Write_Decode;
			s_Cond_Execute = i_Cond;
			s_Flags_Execute = s_Flags;
			s_No_Write_Execute = s_No_Write_Decode;
		end
	end


	ARM_Pipelined_ConditionUnit			CondUnit
	(i_CLK, i_NRESET,
	s_Flag_Write_Execute, s_Cond_Execute,
	s_Flags_Execute,
	i_ALU_Flags,
	s_Flags,
	s_CondEx_Execute);

	assign s_PC_Src_Taken_Execute		= s_PC_Src_Execute & s_CondEx_Execute;
	assign s_Reg_Write_Taken_Execute	= (s_Reg_Write_Execute & ~s_No_Write_Execute) & s_CondEx_Execute;
	assign s_Mem_Write_Taken_Execute	= s_Mem_Write_Execute & s_CondEx_Execute;
	assign s_Branch_Taken_Execute		= s_Branch_Execute & s_CondEx_Execute;

	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			s_PC_Src_Memory = 1'b0;
			s_Reg_Write_Memory = 1'b0;
			s_Mem_Write_Memory = 1'b0;
			s_Mem_To_Reg_Memory = 1'b0;
		end
		else
		begin
			s_PC_Src_Memory = s_PC_Src_Taken_Execute;
			s_Reg_Write_Memory = s_Reg_Write_Taken_Execute;
			s_Mem_Write_Memory = s_Mem_Write_Taken_Execute;
			s_Mem_To_Reg_Memory = s_Mem_To_Reg_Execute;
		end
	end

	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			s_PC_Src_WriteBack = 1'b0;
			s_Reg_Write_WriteBack = 1'b0;
			s_Mem_To_Reg_WriteBack = 1'b0;
		end
		else
		begin
			s_PC_Src_WriteBack = s_PC_Src_Memory;
			s_Reg_Write_WriteBack = s_Reg_Write_Memory;
			s_Mem_To_Reg_WriteBack = s_Mem_To_Reg_Memory;
		end
	end


	assign o_ALU_Control_Execute = s_ALU_Control_Execute;
	assign o_ALU_Src_Execute = s_ALU_Src_Execute;

	assign o_PC_Src_WriteBack = s_PC_Src_WriteBack;
	assign o_Reg_Write_Memory = s_Reg_Write_Memory;
	assign o_Reg_Write_WriteBack = s_Reg_Write_WriteBack;
	assign o_Mem_Write_Memory = s_Mem_Write_Memory;
	assign o_Mem_To_Reg_WriteBack = s_Mem_To_Reg_WriteBack;
	assign o_Branch_Taken_Execute = s_Branch_Taken_Execute;

endmodule

