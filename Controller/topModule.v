`timescale 1ns / 1ps


module topModule( resetIn, sensorIn, reprogramIn, walkRqstIn, globalClk, timeValIn, timeParamSel, LEDout);
    input resetIn, sensorIn, reprogramIn, walkRqstIn, globalClk;
	 input [3:0] timeValIn;
	 input [1:0] timeParamSel;
	 output [6:0]LEDout;
	 
	 wire WR;
	 wire resetSync;
	 wire sensorSync;
	 wire progSync;
	 wire WRsync;
	 wire WRreset;
	 
	 wire expired;
	 wire startTimer;
	 wire [1:0] interval;
	 
	 wire dividerEnable;
	 wire [3:0]value;
	 
	 register walkRegister (.FSMreset(WRreset),.globalReset(resetIn), .clk(globalClk), .dataIn(WRsync), .dataOut(WR));
	 
	 synchronize resetMod(.clk(globalClk),.in(resetIn),.out(resetSync));
	 synchronize sensorMod(.clk(globalClk),.in(sensorIn),.out(sensorSync));
	 synchronize reprogramMod(.clk(globalClk),.in(reprogramIn),.out(progSync));
	 synchronize walkRqstMod(.clk(globalClk),.in(walkRqstIn),.out(WRsync));
	 
	 stateMachine FSM(.clk(globalClk), .globalReset(resetIn), .expireInput(expired), .WRinput(WR),
						  .sensorInput(sensorSync), .reprogramInp(progSync),
						  .enableTimer(startTimer), .intervalSel(interval), .resetWReg(WRreset), .LEDoutput(LEDout));
	 
	 clkDivider divider (.inClk(globalClk), .globalReset(resetIn), .outClk(dividerEnable));
	 
	 timeParamter timeParamMod (.clk(globalClk), .globalReset(resetIn),.timeVal(timeValIn),
										 .parameterSel(timeParamSel), .reprogram(progSync), .FSMintervalSel(interval),
										 .outputVal(value));
	 timer timerModule(.clk(globalClk), .dividerClk(dividerEnable), .globalReset(resetIn), .beginTimer(startTimer),
							 .timeValue(value), .expiredSig(expired));


	 /*always @(globalClk) begin
		if (reprogramIn == 1) begin
			expired <= 0;
		end
	end*/
endmodule
