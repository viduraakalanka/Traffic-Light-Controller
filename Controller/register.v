`timescale 1ns / 1ps
//stores any walk register requests
module register( FSMreset,globalReset, clk, dataIn, dataOut);
	parameter WIDTH = 1;
	input FSMreset, globalReset, clk  ;
	input [WIDTH-1:0] dataIn;
	output reg dataOut; 
	
	always @ (posedge clk)
	begin
		if (globalReset == 1)
			dataOut <= 0;
		else if (FSMreset == 1'b1)
			dataOut <= 0;
		else
			dataOut <=  dataIn;
	end
	
endmodule