module ARM_Pipelined_Datapath
	#(parameter	BusWidth	= 32)
	(input logic			);


endmodule



module ARM_Pipelined_ProgramCounter
	#(parameter	BusWidth	= 32)
	(input logic					);


endmodule

module ARM_Pipelined_Register
	#(parameter	BusWidth	= 32)
	(input logic					);


endmodule

module ARM_Pipelined_Register_NE
	#(parameter	BusWidth	= 32)
	(input logic					);


endmodule

module ARM_Mux_2x1
	#(parameter	BusWidth	= 32)
	(input logic);


endmodule

module ARM_4_bit_Mux_2x1
	#(parameter	BusWidth	= 4)
	(input logic);


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
	(input logic);


endmodule

module	ARM_Pipelined_ALU
	#(parameter	BusWidth	= 32)
	(input logic);


endmodule

module ARM_Mux_4x1
	#(parameter	BusWidth	= 32)
	(input logic);


endmodule
