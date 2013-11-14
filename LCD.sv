/***************************************************************
 * LCD
 * 
 * Handles LCD control signals
 * Outputs an ASCII string to the LCD display
 * 
 * Project: ECPE 174: Advanced Digital Design Final Project
 * Author: Tristan Watts-Willis
 * Date: 2013-11-14
 *
 * Inputs:
 * 		clk:		Master 50 MHz clock
 * 		reset:		Async active low reset
 *		ASCII:		32-char string to output on LCD
 *		UpdateLCD:	Trigger to indicate data ready for LCD
 * Outputs:
 *		E:			Trigger to update LCD (falling-edge)
 *		RS:			Indicate instruction type (0=control, 1=data)
 *		RW:			Read/!Write select, (0=write)
 *		DB:			Data to output to LCD
 *
 ***************************************************************/
 
module LCD(	input logic clk, reset,
			input [7:0] ASCII [31:0],
			input UpdateLCD,
			output logic E, RS, RW,
			output logic [7:0] DB
			);
	
endmodule
