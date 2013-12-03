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
 * 		PxPoint:	Indicate when player x scores
 *		PxType:		Type of player (0=human, 1=AI)
 *		Level:		The current level of the game (0-7)
 * Outputs:
 *		PxTotal:	Total score for player x
 *		ASCII:		32-char string to output on LCD
 *
 ***************************************************************/
 
 /*
 P1: HU    P2: CP
  3    LVL5    5 
 */
 
 //`define DEBUG
 //`define SIMULATE
 
module Score(	input logic clk, reset,
				input logic [2:0] Level,
				input logic P1Point, P2Point, P1Type, P2Type,
				output logic [2:0] P1Total, P2Total,
				output logic E, RS, RW, ON,
				output logic [7:0] DB
			);
			
	logic [0:31] [7:0] ASCII;

`ifdef SIMULATE
	LCD LCDdriver(.clk(clk),.reset(reset),.ASCII(ASCII),.E(E),.RS(RS),.RW(RW),.DB(DB));
`else
	logic P1SYNC, P2SYNC;
	synchronizer P1syn(.clk(clk),.X(P1Point),.fall(P1SYNC));
	synchronizer P2syn(.clk(clk),.X(P2Point),.fall(P2SYNC));

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
			ON <= 1;
		end else begin
			ON <= 1;
			
`ifdef DEBUG
			P1Total <= P1SYNC ? P1Total+1 : P1Total;
			P2Total <= P2SYNC ? P2Total+1 : P2Total;
`else
			P1Total <= P1Point ? P1Total+1 : P1Total;
			P2Total <= P2Point ? P2Total+1 : P2Total;
`endif
			
			
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