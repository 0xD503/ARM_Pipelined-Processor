module ARM_Pipelined_RegisterFile
	#(parameter	BusWidth			= 32,
				RegAddrWidth		= 4,
				RegisterFileSize	= 15)
	(input logic						i_CLK, i_NRESET,
	input logic							i_WriteEnable,
	input logic[(RegAddrWidth - 1):0]	i_Src_1_Addr, i_Src_2_Addr, i_Write_Src_Addr,
	input logic[(BusWidth - 1):0]		i_WriteData,
	input logic[(BusWidth - 1):0]		i_R15,
	output logic[(BusWidth - 1):0]		o_RegFile_Out_1, o_RegFile_Out_2);

	logic[(BusWidth - 1):0]				RegisterFile[(RegisterFileSize - 1):0];


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			int i;
			for (i = 0; i < RegisterFileSize; i = i + 1)	RegisterFile[i] = 32'h00000000;
		end
		else if (i_WriteEnable)								RegisterFile[i_Write_Src_Addr] = i_WriteData;
	end


	assign o_RegFile_Out_1 = (i_Src_1_Addr == 4'hF) ?	i_R15 : RegisterFile[i_Src_1_Addr];
	assign o_RegFile_Out_2 = (i_Src_2_Addr == 4'hF) ?	i_R15 : RegisterFile[i_Src_2_Addr];

endmodule

