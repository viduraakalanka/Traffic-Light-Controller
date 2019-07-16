`timescale 1ns / 1ps

module timer(clk, dividerClk, globalReset, beginTimer, timeValue, expiredSig);
    input clk, dividerClk, globalReset, beginTimer;
	 input [3:0]timeValue;
	 output reg expiredSig = 1;
	 
	 reg [3:0] counter = 0;
	 reg dividerClkReg   ;//used to identify the positive edge of divider clock
	 
	 always @ (posedge clk )
		begin
			dividerClkReg <= dividerClk;
			if (globalReset == 1)
				begin
					expiredSig <= 1;
					counter 	  <= 0; 
				end
			else if (beginTimer == 1 )begin 
			//runs timer module only when FSM makes begin timer signal 1
			expiredSig <= 0;
			if (dividerClk ==1 && dividerClk == ~dividerClkReg)
			// counter only get updated at the positive edge of the divider clk
			begin
					if (counter == timeValue-1)
						begin
							counter    <= 0;
							expiredSig <= 1;
						end
					else 
						counter <= counter + 1;
					end
					end
		end
endmodule

