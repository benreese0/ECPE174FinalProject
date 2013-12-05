/***************************************************************
 * Paddle
 * 
 * Tracks paddle position, interger output is center pixel of
 *    paddle.
 * 
 * Project: ECPE 174: Advanced Digital Design Final Project
 * Author:Ben Reese
 * Date: 2013-11-08
 ***************************************************************/


 
 module Paddle(input logic up, down, reset, game_on, wrap_mode, clk,
					input int ticks_per_px,
					output logic moving_up, moving_down,
					output int position);  
	
	int ticks;
	
	always_ff @(posedge clk or negedge reset) begin
		if (!reset) begin //resetting
			position <= 480/2;
			moving_down <=1'b0;
			moving_up <=1'b0;
			ticks = 0;
		end
		else begin //normal operation
			//clear ticks if not moving
			if (!up && !down) ticks = 0; // not pushing buttons
			if (ticks > ticks_per_px) begin // need to move up
				position =position +1;
				moving_up <= 1'b1;
				ticks = 0;
			end
			if (-ticks > ticks_per_px) begin // need to move down
				position  = position -1;
				moving_down <= 1'b1;
				ticks = 0;
			end
			if ((ticks<ticks_per_px)&& (-ticks < ticks_per_px)) begin
				// should not be moving now
				moving_down <=1'b0;
				moving_up <=1'b0;
			end
			if (game_on && up) ticks = ticks +1;
			if (game_on && down) ticks = ticks -1;
			if (wrap_mode) begin
				position = (position > 480)? 0:position;
				position = (position < 0)? 480 :position;
			end
			else begin
				position = (position > 480)? 480:position;
				position = (position < 0)? 0: position;
			end
		end
	end
	
endmodule 
