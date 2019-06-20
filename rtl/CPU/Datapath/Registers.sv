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


module ARM_Pipelined_Register_sCLR
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_ENABLE,
	input logic						i_SCLR,
	input logic[(BusWidth - 1):0]	i_In,
	output logic[(BusWidth - 1):0]	o_Out);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)		o_Out <= 32'h00000000;
		else if (i_ENABLE)
		begin
			if (i_SCLR)		o_Out <= 32'h00000000;
			else			o_Out <= i_In;
		end
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


module ARM_Pipelined_TripleRegister_NE
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic[(BusWidth - 1):0]	i_In_0, i_In_1, i_In_2,
	output logic[(BusWidth - 1):0]	o_Out_0, o_Out_1, o_Out_2);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			o_Out_0 <= 32'h00000000;
			o_Out_1 <= 32'h00000000;
			o_Out_2 <= 32'h00000000;
		end
		else
		begin
			o_Out_0 <= i_In_0;
			o_Out_1 <= i_In_1;
			o_Out_2 <= i_In_2;
		end
	end

endmodule


module ARM_Pipelined_TripleRegister_NE4
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic[(BusWidth - 1):0]	i_In_0, i_In_1,
	input logic[3:0]				i_In_2,
	output logic[(BusWidth - 1):0]	o_Out_0, o_Out_1,
	output logic[3:0]				o_Out_2);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			o_Out_0 <= 32'h00000000;
			o_Out_1 <= 32'h00000000;
			o_Out_2 <= 4'h0;
		end
		else
		begin
			o_Out_0 <= i_In_0;
			o_Out_1 <= i_In_1;
			o_Out_2 <= i_In_2;
		end
	end

endmodule


module ARM_Pipelined_Register_sCLR_NE
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_SCLR,
	input logic[(BusWidth - 1):0]	i_In,
	output logic[(BusWidth - 1):0]	o_Out);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)		o_Out <= 32'h00000000;
		else if (i_SCLR)	o_Out <= 32'h00000000;
		else				o_Out <= i_In;
	end

endmodule


module ARM_Pipelined_TripleRegister_sCLR_NE
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_SCLR,
	input logic[(BusWidth - 1):0]	i_In_0, i_In_1, i_In_2,
	output logic[(BusWidth - 1):0]	o_Out_0, o_Out_1, o_Out_2);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			o_Out_0 <= 32'h00000000;
			o_Out_1 <= 32'h00000000;
			o_Out_2 <= 32'h00000000;
		end
		else if (i_SCLR)
		begin
			o_Out_0 <= 32'h00000000;
			o_Out_1 <= 32'h00000000;
			o_Out_2 <= 32'h00000000;
		end
		else
		begin
			o_Out_0 <= i_In_0;
			o_Out_1 <= i_In_1;
			o_Out_2 <= i_In_2;
		end
	end

endmodule


module ARM_Pipelined_QuadRegister_sCLR_NE
	#(parameter	BusWidth	= 32)
	(input logic					i_CLK, i_NRESET,
	input logic						i_SCLR,
	input logic[(BusWidth - 1):0]	i_In_0, i_In_1,
	input logic[3:0]				i_In_2,
	input logic[(BusWidth - 1):0]	i_In_3,
	output logic[(BusWidth - 1):0]	o_Out_0, o_Out_1,
	output logic[3:0]				o_Out_2,
	output logic[(BusWidth - 1):0]	o_Out_3);


	always_ff	@(posedge i_CLK, negedge i_NRESET)
	begin
		if (~i_NRESET)
		begin
			o_Out_0 <= 32'h00000000;
			o_Out_1 <= 32'h00000000;
			o_Out_2 <= 4'h0;
			o_Out_3 <= 32'h00000000;
		end
		else if (i_SCLR)
		begin
			o_Out_0 <= 32'h00000000;
			o_Out_1 <= 32'h00000000;
			o_Out_2 <= 4'h0;
			o_Out_3 <= 32'h00000000;
		end
		else
		begin
			o_Out_0 <= i_In_0;
			o_Out_1 <= i_In_1;
			o_Out_2 <= i_In_2;
			o_Out_3 <= i_In_3;
		end
	end

endmodule

