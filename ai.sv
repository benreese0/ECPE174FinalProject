/********************************************************
********* Computer Player aka A.I. **********************
* This file will be used to have a computer player to 
* compete against. It will have the ball position as an input
* and a level 

include "constants.sv"

module compPlayer	(	input int ballY,
				input logic reset,
				input logic [1:0] diff,
				input logic game_on,
				input logic clk, 
				output int position,
				output logic moving_up,
				output logic moving_down);
logic goingUp;
logic goingDown;
int tickCount = 0;
	
	always_ff @(posedge clk) begin
		case(diff)
		begin
			2'b01: tickCount<=80000;
			2'b10: tickCount<=40000;
			2'b11: tickCount<=20000;
		end



	Paddle comp(.up(goingUp), .down(goingDown), .reset(reset), .game_on(game_on), .wrap_mode(logic 0), .clk(clk), .ticks_per_px(tickCount));
	always_comb begin
		if !reset
			begin
				
			end
		else if ballY>position
			begin
				goingUp<=0;
				goingDown<=1;
			end
		else if ballY<position
			begin	
				goingUp<=1;
				goingDown<=0;
			end
		end

