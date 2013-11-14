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
 * Outputs:
 *		PxTotal:	Total score for player x
 *		ASCII:		32-char string to output on LCD
 *		UpdateLCD:	Trigger to indicate data ready for LCD
 *
 ***************************************************************/
 
module score(	input logic clk, reset,
				input logic P1Score, P2Score, Level, P1Type, P2Type,
				output logic [2:0] P1Total, P2Total,
				output [7:0] ASCII [31:0],
				output UpdateLCD
			);
	
endmodule
