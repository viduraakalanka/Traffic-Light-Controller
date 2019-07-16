`timescale 1ns / 1ps

module stateMachine(clk, globalReset, expireInput, WRinput,
						  sensorInput, reprogramInp,
						  enableTimer, intervalSel, resetWReg, LEDoutput);
    input clk, globalReset, expireInput, 
			 WRinput,sensorInput, reprogramInp;
	 output reg resetWReg = 0;
	 output reg [1:0]intervalSel = baseSel;
	 output reg [6:0]LEDoutput = 7'b1000010;
	 output reg enableTimer =0;
	 reg [2:0]state ;//shows next state
	 reg reg1 		 = 1'b1 ;
	 reg reg2		 = 1'b1 ;
	 
	 localparam baseSel = 2'b00;
	 localparam extSel  = 2'b01;
	 localparam yelSel = 2'b10;
	 
	 localparam GRN1 = 3'b000; //GRN : main traffic light colour - Green, 
										//side street traffic light colour - Red,
										//walk light - Not on
	 localparam GRN2 = 3'b001;
	 localparam YRN1 = 3'b010;
	 localparam RRY1 = 3'b011;
	 localparam RGN1 = 3'b100;
	 localparam RGN2 = 3'b101;
	 localparam RYN1 = 3'b110;
	 
	 reg expireInputReg ; 
	 //stores the previous value of expireInput
	
	 always @ (posedge clk)
	 begin
		expireInputReg <= expireInput ;
		if ((globalReset == 1 )|| (reprogramInp == 1))
			begin
				state 	 <= GRN1;
				resetWReg <= 0;
				enableTimer <= 0;
				intervalSel <= baseSel;
				LEDoutput = 7'b1000010;
				//havent asssigned to led output
			end		
		else if (expireInput == 1 && reg2 == 1)
					begin
					//runs only at the begining 
						reg2 <= 0;
						intervalSel <= baseSel;
						state 		<= GRN2;
						enableTimer <= 1;
						LEDoutput <= 7'b1000010;
					end
		else
				begin
				//below code runs at the begining of the each positive 
				//edge of expired input signal from the timer
					if (expireInputReg == ~expireInput && expireInput == 1)
					begin
						case (state)
							GRN1 :
								begin
									intervalSel <= baseSel;
									state 		<= GRN2;
									enableTimer <= 1;
									LEDoutput <= 7'b1000010;
								end
							GRN2 :
								begin	
								//Select correct time parameter depending on the input from the sensor
									if (sensorInput ==1)
										begin
										intervalSel <= extSel;
										state 		<= YRN1;
										enableTimer <= 1;
										LEDoutput <= 7'b1000010;
										end
									else
										begin
										intervalSel <= baseSel;
										state 		<= YRN1;
										enableTimer <= 1;
										LEDoutput <= 7'b1000010;
										end
								end
							YRN1 :
								begin
								//shortens the yellow signal time period of main traffic light
								//if walk register input is one
								if (WRinput ==1)
									begin
									resetWReg   <= 1;
									state 		<= RGN1; 
									intervalSel <= extSel;
									enableTimer	<= 1;
									LEDoutput <= 7'b0010011;
									end
								else
									begin
									intervalSel <= yelSel;
									state 		<= RGN1;
									enableTimer <= 1;
									LEDoutput <= 7'b0100010;
									end	
								end
							RGN1 :
							//here side street trafffic light turns yellow
								begin
									resetWReg   <= 0;
				     				intervalSel <= baseSel;
									state 		<= RGN2;
									enableTimer <= 1;
									LEDoutput <= 7'b0011000;
								end
							RGN2 :
								begin
								//extend the green colour time period of side street traffic light
								// if sensor input is one at that time
									if (sensorInput ==1)
										begin
										intervalSel <= extSel;
										state 		<= RYN1;
										enableTimer <= 1;
										LEDoutput <= 7'b0011000;
										end
									else
										begin
										intervalSel <= yelSel;
										state 		<= GRN1;
										enableTimer <= 1;
										LEDoutput <= 7'b0010100;
										end
								end
							RYN1 :
								begin
									intervalSel <= yelSel;
									state 		<= GRN1;
									enableTimer <= 1;
									LEDoutput <= 7'b0010100;
								end
							endcase
					end
				end	
	 end
endmodule
