`timescale 1ns / 1ps
module clockmod(clock);
	output reg clock = 0;
	always begin
		clock <= ~clock;
		#5;
	end

endmodule
