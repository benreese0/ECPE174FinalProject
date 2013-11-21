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
 *		Busy:		The LCD is currenty performing an operation (active high)
 *		E:			Trigger to update LCD (falling-edge)
 *		RS:			Indicate instruction type (0=control, 1=data)
 *		RW:			Read/!Write select, (0=write)
 *		DB:			Data to output to LCD
 *
 ***************************************************************/
 
module LCD(	input logic clk, reset,
			input [7:0] ASCII [31:0],
			input UpdateLCD,
			output logic Busy,
			output logic E, RS, RW,
			output logic [7:0] DB
			);
	logic [1:0] setup = 0;
	logic [4:0] char = 0;
	typedef enum logic [2:0] {sSetup_start, sSetup_end, sCursor_start, sCursor_end, sChar, sChar_end} state;
	state cState, nState;
	
	always_ff @(posedge clk or negedge reset)
	begin
		if(!reset) begin
			Busy <= 0;
			E <= 0;
			RS <= 0;
			RW <= 0;
			DB <= 0;
			char <= 0;
			setup <=0;
			cState <= sSetup_start;
		end
		else begin
			cState <= nState;
			
			case(nState)
				sSetup_start:
				begin
					E <= 1;
					RS <= 0;
					case(setup)
						0: DB <= 8'h38;
						1: DB <= 8'hF;
						2: DB <= 8'hE;
						3: DB <= 8'h6;
						default: DB <= 0;
					endcase
					setup <= setup+1;
				end
				sSetup_end: E <= 0;
				sCursor_start:
				begin
					E <= 1;
					RS <= 0;
					if(char[4])
						DB <= {1'b1,7'h40+char};
					else
						DB <= {3'b100,char};
				end
				sCursor_end: E <= 0;
				sChar:
				begin
					E <= 1;
					RS <= 1;
					DB <= ASCII[char];
				end
				sChar_end:
				begin
					E <= 0;
					char <= char+1;
				end
			endcase
		end
	end
	
	always_comb
	begin
		case(cState)
			sSetup_start:
				nState <= sSetup_end;
			sSetup_end:
				if(setup==4) nState <= sCursor_start;
				else nState <= sSetup_start;
			sCursor_start:
				nState <= sCursor_end;
			sCursor_end:
				nState <= sChar;
			sChar:
				nState <= sChar_end;
			sChar_end:
				nState <= sCursor_start;
			default:
				nState <= sSetup_start;
		endcase
	end
	
endmodule
