//synchronize inputs with the clock
module synchronize(clk,in,out);
	parameter NSYNC = 2 ;
	input clk;
	input in;
	output out;
	
	reg [NSYNC-2:0] sync;
	reg out;
	
	always @ (posedge clk)
	begin
		{out,sync} <= {sync[NSYNC-2:0],in};
	end
endmodule
