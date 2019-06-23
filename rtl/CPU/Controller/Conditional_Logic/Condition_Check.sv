module ARM_Pipelined_ConditionCheck
	(input logic[3:0]	i_Cond,
	input logic[1:0]	i_Flags_NZ, i_Flags_CV,

	output logic		o_CondEx_Execute);

	typedef enum logic[3:0]	{EQ = 4'h0,
							NE = 4'h1,
							HS = 4'h2,
							LO = 4'h3,
							MI = 4'h4,
							PL = 4'h5,
							VS = 4'h6,
							VC = 4'h7,
							HI = 4'h8,
							LS = 4'h9,
							GE = 4'hA,
							LT = 4'hB,
							GT = 4'hC,
							LE = 4'hD,
							AL = 4'hE}


	always_comb
	begin
		case (i_Cond)
			EQ:	o_CondEx_Execute = i_Flags_NZ[0];
			NE:	o_CondEx_Execute = ~i_Flags_NZ[0];
			HS:	o_CondEx_Execute = i_Flags_CV[1];
			LO:	o_CondEx_Execute = ~i_Flags_CV[1];
			MI:	o_CondEx_Execute = i_Flags_NZ[1];
			PL:	o_CondEx_Execute = ~i_Flags_NZ[1];
			VS:	o_CondEx_Execute = i_Flags_CV[0];
			VC:	o_CondEx_Execute = ~i_Flags_CV[0];

			HI:	o_CondEx_Execute = ~i_Flags_NZ[0] & i_Flags_CV[1];
			LS:	o_CondEx_Execute = i_Flags_NZ[0] | ~i_Flags_CV[1];

			GE:	o_CondEx_Execute = ~(i_Flags_NZ[1] ^ i_Flags_CV[0]);
			LT:	o_CondEx_Execute = (i_Flags_NZ[1] ^ i_Flags_CV[0]);

			GT:	o_CondEx_Execute = ~i_Flags_NZ[0] & ~(i_Flags_NZ[1] ^ i_Flags_CV[0]);
			LE:	o_CondEx_Execute = i_Flags_NZ[0] | (i_Flags_NZ[1] ^ i_Flags_CV[0]);
			AL:	o_CondEx_Execute = 1'b0;
		endcase
	end

endmodule

