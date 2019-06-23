module ARM_Pipelined_ALUDecoder
	(input logic[4:0]	i_Funct,
	input logic			i_ALU_Op,

	output logic[1:0]	o_ALU_Control_Decode,
	output logic[1:0]	o_Flag_Write_Decode,
	output logic		o_No_Write_Decode);

	typedef enum logic[3:0]	{ADD = 4'h4, SUB = 4'h2, AND = 4'h0, ORR = 4'hC, CMP = 4'hA}	cmd_t;


	always_comb
	begin
		if (i_ALU_Op)
		begin
			case (i_Funct[4:1])
				ADD:
				begin
					o_ALU_Control_Decode = 2'b00;
					o_No_Write_Decode = 1'b0;
					if (i_Funct[0])	o_Flag_Write_Decode = 2'b11;
					else			o_Flag_Write_Decode = 2'b00;
				end
				SUB:
				begin
					o_ALU_Control_Decode = 2'b01;
					o_No_Write_Decode = 1'b0;
					if (i_Funct[0])	o_Flag_Write_Decode = 2'b11;
					else			o_Flag_Write_Decode = 2'b00;
				end
				AND:
				begin
					o_ALU_Control_Decode = 2'b10;
					o_No_Write_Decode = 1'b0;
					if (i_Funct[0])	o_Flag_Write_Decode = 2'b10;
					else			o_Flag_Write_Decode = 2'b00;
				end
				ORR:
				begin
					o_ALU_Control_Decode = 2'b11;
					o_No_Write_Decode = 1'b0;
					if (i_Funct[0])	o_Flag_Write_Decode = 2'b10;
					else			o_Flag_Write_Decode = 2'b00;
				end
				CMP:
				begin
					o_ALU_Control_Decode = 2'b01;
					o_No_Write_Decode = 1'b1;
					if (i_Funct[0])	o_Flag_Write_Decode = 2'b11;
					else			o_Flag_Write_Decode = 2'b00;
				end
			endcase
		end
		else
		begin
			o_ALU_Control_Decode = 2'b00;
			o_Flag_Write_Decode = 2'b00;
			o_No_Write_Decode = 1'b0;
		end
	end

endmodule

