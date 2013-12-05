/********************************************************
********* Computer Player aka A.I. **********************
* This file will be used to have a computer player to 
* compete against. It will have the ball position as an input
* and a level 

include "constants.sv"*/

module compPlayer	(	input int ballY,
				input logic reset,
				input logic [1:0] diff,
				input logic game_on, wrapping,
				input logic clk, humanUp, humanDown,
				output int position,
				output logic moving_up,
				output logic moving_down);
logic goingUp;
logic goingDown;
int tickCount = 0;
//logic wrapping = 1;

	
	always_ff @(posedge clk)
		case(diff)
			2'b00: tickCount<=100000;
			2'b01: tickCount<=400000;
			2'b10: tickCount<=200000;
			2'b11: tickCount<=100000;
		endcase

	assign moving_up = goingUp;
	assign moving_down = goingDown;

	Paddle2 comp(.up(goingUp), .down(goingDown), .reset(reset), .game_on(game_on), .wrap_mode(wrapping), .clk(clk), .ticks_per_px(tickCount), .position(position));
	always_comb begin
		if(!reset)
			begin
				goingUp <= 0;
				goingDown <= 0;
			end
		else if(diff==2'b00)
			begin
				if(humanUp) begin
					goingUp <= 1;
					goingDown <= 0;
				end else if(humanDown) begin
					goingUp <= 0;
					goingDown <= 1;
				end else begin
					goingUp <= 0;
					goingDown <= 0;
				end
			end

		else if(ballY>position)
			begin
				goingUp<=0;
				goingDown<=1;
			end
		else if(ballY<position)
			begin	
				goingUp<=1;
				goingDown<=0;
			end
		else
			begin
				goingUp<=0;
				goingDown<=0;
			end
		end
endmodule
