module ARM_Pipelined_Datapath
	#(parameter	BusWidth	= 32)
	(input logic			);


endmodule



module ARM_Pipelined_ProgramCounter
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_ENABLE,
	input logic[(BusWidth - 1):0]	i_PC,
	output logic[(BusWidth - 1):0]	o_PC);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)		o_PC <= 32'h00000000;
		else if (i_ENABLE)	o_PC <= i_PC;
	end

endmodule

module ARM_Pipelined_Register
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_ENABLE,
	input logic[(BusWidth - 1):0]	i_In,
	output logic[(BusWidth - 1):0]	o_Out);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)		o_Out <= 32'h00000000;
		else if (i_ENABLE)	o_Out <= i_In;
	end

endmodule

module ARM_Pipelined_Register_NE
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic[(BusWidth - 1):0]	i_In,
	output logic[(BusWidth - 1):0]	o_Out);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)	o_Out <= 32'h00000000;
		else			o_Out <= i_In;
	end

endmodule

module ARM_Mux_2x1
	#(parameter	BusWidth	= 32)
	(input logic[(BusWidth - 1):0]	i_In_0, i_In_1,
	input logic						i_SelectInput,
	output logic[(BusWidth - 1):0]	o_Output,);


	assign o_Output = (i_SelectInput) ?	i_In_1 : i_In_0;

endmodule

module ARM_4_bit_Mux_2x1
	#(parameter	BusWidth	= 4)
	(input logic[(BusWidth - 1):0]	i_In_0, i_In_1,
	input logic						i_SelectInput,
	output logic[(BusWidth - 1):0]	o_Output,);


	assign o_Output = (i_SelectInput) ?	i_In_1 : i_In_0;

endmodule

module ARM_Pipelined_RegisterFile
	#(parameter	BusWidth			= 32,
				RegAddrWidth		= 4,
				RegisterFileSize	= 15)
	(input logic						i_CLK, i_NRESET,
	input logic							i_WriteEnable,
	input logic[(RegAddrWidth - 1):0]	i_Src_1_Select, i_Src_2_Select, i_Write_Src_Select,
	input logic[(BusWidth - 1):0]		i_WriteData,
	input logic[(BusWidth - 1):0]		i_R15,
	input logic[(BusWidth - 1):0]		i_RegFile_Out_1, i_RegFile_Out_2);




endmodule

module ARM_Pipelined_ExtensionUnit
	#(parameter	ImmediateBusWidth	= 24,
				ExtendedBusWidth	= 32)
	(input logic[(ImmediateBusWidth - 1):0]	i_Immediate,
	input logic[1:0]						i_ExtensionSelect,
	output logic[(ExtendedBusWidth - 1):0]	o_Extension);


	always_comb
	begin
		case (i_ExtensionSelect)
			2'b00:		o_Extension = {24'h000000, i_Immediate[7:0]};
			2'b01:		o_Extension = {20'h00000, i_Immediate[11:0]};
			2'b10:		o_Extension = {8'h00, i_Immediate};

			default:	o_Extension = 32'h00000000;
		endcase
	end

endmodule

module	ARM_Pipelined_ALU
	#(parameter	BusWidth	= 32)
	(input logic[(BusWidth - 1):0]	i_In_A, i_In_B,
	input logic[1:0]				i_ALU_Control,
	output logic[(BusWidth - 1):0]	o_Out)
	output logic[3:0]				o_Flags);

	typedef enum logic[1:0]	{ADD = 2'b00, SUB = 2'b01, AND = 2'b10, ORR = 2'b11}	en_ALU_Operation;

	logic[(BusWidth - 1):0]	s_Out;
	logic[(BusWidth - 1):0]	s_In_B, s_In_Not_B;
	logic					s_Flag_N, s_Flag_Z;
	logic					s_Flag_C, s_Flag_V;


	//	Result logic
	always_comb
	begin
		case (i_ALU_Control[1:0])
			ADD:	s_Out = i_In_A + i_In_B;
			SUB:	s_Out = i_In_A - i_In_B;
			AND:	s_Out = i_In_A & i_In_B;
			ORR:	s_Out = i_In_A | i_In_B;

			default:	s_Out = 32'h00000000;
		endcase
	end

	//	Flags logic
	always_comb
	begin
		s_Flag_N = s_Out[31];
		s_Flag_Z = (s_Out == 0) ?;
		case (i_ALU_Control[1:0])
			ADD:
			begin
				s_Flag_C = (i_In_A >= i_In_B) ?;
				s_Flag_V =	((i_In_A[BusWidth - 1] & i_In_B[BusWidth - 1] & ~s_Out[BusWidth - 1]) |
							(~i_In_A[BusWidth - 1] & ~i_In_B[BusWidth - 1] & s_Out[BusWidth - 1));
			end
			SUB:
			begin
				s_Flag_C = (i_In_A < i_In_B) ?;
				s_Flag_V =	((i_In_A[BusWidth - 1] & ~i_In_B[BusWidth - 1] & s_Out[BusWidth - 1]) |
							(~i_In_A[BusWidth - 1] & i_In_B[BusWidth - 1] & s_Out[BusWidth - 1));;
			end

			default:
			begin
				s_Flag_C = 1'bx;
				s_Flag_V = 1'bx;
			end
		endcase
	end

	assign s_In_Not_B = ~i_In_B;
	assign s_In_B = (i_ALU_Control[2]) ?	s_In_Not_B : i_In_B;

	assign o_Out = s_Out;
	assign o_Flags = {s_Flag_N, s_Flag_Z, s_Flag_C, s_Flag_V};

endmodule

module ARM_Mux_4x1
	#(parameter	BusWidth	= 32)
	(input logic[(BusWidth - 1):0]	i_In_0, i_In_1, i_In_2, i_In_3,
	input logic[1:0]				i_InputSelect,
	output logic[(BusWidth - 1):0]	o_Out);


	always_comb
	begin
		case (i_InputSelect)
			2'b00:	o_Output = i_In_0;
			2'b01:	o_Output = i_In_1;
			2'b10:	o_Output = i_In_2;
			2'b11:	o_Output = i_In_3;

			default:	o_Output = i_In_0;
		endcase
	end

endmodule

