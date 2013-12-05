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


 
 module Paddle2(input logic up, down, reset, game_on, wrap_mode, clk,
					input int ticks_per_px,
					output logic moving_up, moving_down,
					output int position);  
	
	int ticks;
	logic intclk;
	
	always_ff@(posedge clk)
	begin
		if(ticks > ticks_per_px)begin
			intclk <= ~intclk;
			ticks <= 0;
			end
		else ticks <= ticks+1;
	end
	
	always_ff @(posedge intclk or negedge reset) begin
		if (!reset) begin //resetting
			position <= 480/2;
			moving_down <=1'b0;
			moving_up <=1'b0;
			//ticks <= 0;
		end
		else begin
			if (game_on && up) position = position-1;
			if (game_on && down) position=position+1;
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
