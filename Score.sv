/***************************************************************
 * Score
 * 
 * Keeps track of current score for each player.
 * Tracks player type (human, computer) and current level.
 * Formats output for display to LCD.
 * 
 * Project: ECPE 174: Advanced Digital Design Final Project
 * Author: Tristan Watts-Willis
 * Date: 2013-11-14
 *
 * Inputs:
 * 		clk:		Master 50 MHz clock
 * 		reset:		Async active low reset
 * 		PxScore:	Edge trigger when player x scores
 *		PxType:		Type of player (0=human, 1=AI)
 *		Level:		The current level of the game (0-7)
 *		LCDBusy:	Determines if LCD is currently performing an operation
 * Outputs:
 *		PxTotal:	Total score for player x
 *		ASCII:		32-char string to output on LCD
 *		UpdateLCD:	Trigger to indicate data ready for LCD
 *
 ***************************************************************/
 
 /*
 P1: HU    P2: CP
  3    LVL5    5 
 */
 
 `define DEBUG
 
module Score(	input logic clk, reset,
				input logic [2:0] Level,
				input logic P1Score, P2Score, P1Type, P2Type,
				//input logic LCDBusy,
				output logic [2:0] P1Total, P2Total,
				//output logic [0:31] [7:0] ASCII
				//output logic UpdateLCD
				output logic E, RS, RW,
				output logic [7:0] DB
			);
			
	logic [0:31] [7:0] ASCII;

`ifdef DEBUG
	LCD LCDdriver(.clk(clk),.reset(reset),.ASCII(ASCII),.E(E),.RS(RS),.RW(RW),.DB(DB));
`else
	logic LCDclock;
	LCDclockdiv LCDdivider(.iclk(clk),.oclk(LCDclock));
	LCD LCDdriver(.clk(LCDclock),.reset(reset),.ASCII(ASCII),.E(E),.RS(RS),.RW(RW),.DB(DB));
`endif
	
	
	always_ff @(posedge clk or negedge reset)
	begin
		if(!reset) begin
			ASCII <= "";
			P1Total <= 0;
			P2Total <= 0;
		end else begin
			P1Total <= P1Score ? P1Total+1 : P1Total;
			P2Total <= P2Score ? P2Total+1 : P2Total;
			
			//line 1:
			ASCII[0:3] <= "P1: ";
			ASCII[4:5] <= P1Type ? "CP" : "HU";
			ASCII[6:9] <= "    ";
			ASCII[10:13] <= "P2: ";
			ASCII[14:15] <= P2Type ? "CP" : "HU";
			//line 2:
			ASCII[16] <= " ";
			ASCII[17] <= P1Total+48;
			ASCII[18:21] <= "    ";
			ASCII[22:24] <= "LVL";
			ASCII[25] <= Level+48;
			ASCII[26:29] <= "    ";
			ASCII[30] <= P2Total+48;
			ASCII[31] <= " ";
		end
	end
	
endmodule