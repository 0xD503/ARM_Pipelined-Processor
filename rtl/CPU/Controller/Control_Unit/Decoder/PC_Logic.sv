module	ARM_Pipelined_PC_Logic
	(input logic[3:0]	i_Rd,
	input logic			i_Branch,
	input logic			i_Reg_Write,
	output logic		o_PC_Src_Decode);


	assign o_PC_Src_Decode = ((i_Rd == 4'hF) & i_Reg_Write) ?	1'b1 : i_Branch;

endmodule

