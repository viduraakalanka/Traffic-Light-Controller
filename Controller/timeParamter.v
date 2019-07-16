`timescale 1ns / 1ps

module timeParamter(clk, globalReset,timeVal, parameterSel, reprogram, FSMintervalSel, outputVal);
	input clk, globalReset, reprogram;
	input [3:0] timeVal;
	input [1:0] parameterSel,FSMintervalSel;
	output reg [3:0]outputVal;
	
	reg regTimeVal;
	reg baseInt;
	reg [3:0]memory [2:0] ;
	initial begin
	memory [2] <= 4'd1;
	memory [1] <= 4'd2;
	memory [0] <= 4'd3;
	end
	//here memory[2] = base interval
	//		 memory[1] = extended interval
	//		 memory[0] = yellow interval
	
	always @ (posedge clk)
	begin
		if (globalReset == 1)
			begin
				//reset signal will assign default values to each time parameter 
				memory[2] <= 4'b0001;
				memory[1] <= 4'b0010;
				memory[0] <= 4'b0011;
				outputVal <= 4'bxxxx;
			end		
		else if (globalReset == 0 && reprogram == 1)
			begin
				outputVal 			<= 4'bxxxx;
				case (parameterSel)
				//reprogram a given tme parameter with given time value
					2'b00 : memory[2] <= timeVal;
					2'b01 : memory[1] <= timeVal;
				 	2'b10 : memory[0] <= timeVal;
				endcase
			end
		else 
			begin
				case (FSMintervalSel)
				//output reqired time value as requested
					2'b00 : outputVal <= memory[2] ;
					2'b01 : outputVal <= memory[1] ;
					2'b10 : outputVal <= memory[0] ;
				endcase
		end
	end
endmodule
