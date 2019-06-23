module ARM_Pipelined_MainDecoder
	(input logic[1:0]	i_Op,
	input logic[1:0]	i_Funct,

	output logic		o_Reg_Write_Decode, o_Mem_Write_Decode,
	output logic		o_Mem_To_Reg_Decode,
	output logic		o_ALU_Src_Decode,
	output logic[1:0]	o_Reg_Src_Decode, o_Imm_Src_Decode,
	
	output logic		o_Branch,

	output logic		o_ALU_Op);

	typedef enum logic[1:0]	{DP = 2'b00, MEM = 2'b01, BRANCH = 2'b10}	cmdType_t;


	always_comb
	begin
		case (i_Op)
			DP:
			begin
				o_Mem_To_Reg_Decode = 1'b0;
				o_Mem_Write_Decode = 1'b0;
				o_Reg_Write_Decode = 1'b1;
				if (i_Funct[1])
				begin
					o_ALU_Src_Decode = 1'b1;
					o_Imm_Src_Decode = 2'b00;
					o_Reg_Src_Decode = 2'bx0;
				end
				else
				begin
					o_ALU_Src_Decode = 1'b1;
					o_Imm_Src_Decode = 2'b00;
					o_Reg_Src_Decode = 2'bx0;
				end
			end
			MEM:
			begin
				if (i_Funct[0])
				begin
					o_Mem_To_Reg_Decode = 1'b1;
					o_Mem_Write_Decode = 1'b0;
					o_Reg_Write_Decode = 1'b1;
					o_Reg_Src_Decode = 2'bx0;
				end
				else
				begin
					o_Mem_To_Reg_Decode = 1'bx;
					o_Mem_Write_Decode = 1'b1;
					o_Reg_Write_Decode = 1'b0;
					o_Reg_Src_Decode = 2'b10;
				end
				o_ALU_Src_Decode = 1'b1;
				o_Imm_Src_Decode = 2'b01;
			end
			BRANCH:
			begin
				o_Mem_To_Reg_Decode = 1'b0;
				o_Mem_Write_Decode = 1'b0;
				o_Mem_Write_Decode = 1'b0;
				o_Reg_Src_Decode = 2'bx1;
				o_ALU_Src_Decode = 1'b1;
				o_Imm_Src_Decode = 2'b10;
			end
		endcase
	end

	//assign o_Imm_Src_Decode = i_Op;
	assign o_Branch = (i_Op == 2'b10) ?	1'b1 : 1'b0;
	assign o_ALU_Op = (i_Op == 2'b00) ?	1'b1 : 1'b0;

endmodule

