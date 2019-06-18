module	ARM_Pipelined_ALU
	#(parameter	BusWidth	= 32)
	(input logic[(BusWidth - 1):0]	i_In_A, i_In_B,
	input logic[1:0]				i_ALU_Control,
	output logic[(BusWidth - 1):0]	o_Out,
	output logic[3:0]				o_Flags);

	typedef enum logic[1:0]	{ADD = 2'b00, SUB = 2'b01, AND = 2'b10, ORR = 2'b11}	en_ALU_Operation;

	logic[(BusWidth - 1):0]	s_Out;
	logic[(BusWidth - 1):0]	s_In_B;//, s_In_Not_B;
	logic					s_Flag_N, s_Flag_Z;
	logic					s_Flag_C, s_Flag_V;


	//	Result logic
	always_comb
	begin
		case (i_ALU_Control[1:0])
			ADD:	s_Out = i_In_A + s_In_B;
			SUB:	s_Out = i_In_A - s_In_B;
			AND:	s_Out = i_In_A & s_In_B;
			ORR:	s_Out = i_In_A | s_In_B;

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
				s_Flag_C = (i_In_A >= s_In_B) ?	1'b1 : 1'b0;
				s_Flag_V =	((i_In_A[BusWidth - 1] & s_In_B[BusWidth - 1] & ~s_Out[BusWidth - 1]) |
							(~i_In_A[BusWidth - 1] & ~s_In_B[BusWidth - 1] & s_Out[BusWidth - 1]));
			end
			SUB:
			begin
				s_Flag_C = (i_In_A < s_In_B) ?	1'b1 : 1'b0;
				s_Flag_V =	((i_In_A[BusWidth - 1] & ~s_In_B[BusWidth - 1] & s_Out[BusWidth - 1]) |
							(~i_In_A[BusWidth - 1] & s_In_B[BusWidth - 1] & s_Out[BusWidth - 1]));;
			end

			default:
			begin
				s_Flag_C = 1'bx;
				s_Flag_V = 1'bx;
			end
		endcase
	end

	//assign s_In_Not_B = ~i_In_B;
	assign s_In_B = i_In_B;//(i_ALU_Control[2]) ?	s_In_Not_B : i_In_B;

	assign o_Out = s_Out;
	assign o_Flags = {s_Flag_N, s_Flag_Z, s_Flag_C, s_Flag_V};

endmodule

