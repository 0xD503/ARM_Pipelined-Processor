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

