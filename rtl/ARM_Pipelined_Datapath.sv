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
	(input logic[(BusWidth - 1):0]	i_Input_A, i_Input_B,
	input logic						i_SelectInput,
	output logic[(BusWidth - 1):0]	o_Output,);


	assign o_Output = (i_SelectInput) ?	i_Input_B : i_Input_A;

endmodule

module ARM_4_bit_Mux_2x1
	#(parameter	BusWidth	= 4)
	(input logic[(BusWidth - 1):0]	i_Input_A, i_Input_B,
	input logic						i_SelectInput,
	output logic[(BusWidth - 1):0]	o_Output,);


	assign o_Output = (i_SelectInput) ?	i_Input_B : i_Input_A

endmodule

module ARM_Pipelined_RegisterFile
	#(parameter	BusWidth			= 32,
				RegAddrWidth		= 4,
				RegisterFileSize	= 15)
	(input logic						);

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
	(input logic);




endmodule

module ARM_Mux_4x1
	#(parameter	BusWidth	= 32)
	(input logic);


endmodule

