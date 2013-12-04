/***************************************************************
 * Paddle Test Bench
 * 
 * Tracks paddle position, interger output is center pixel of
 *    paddle.
 * 
 * Project: ECPE 174: Advanced Digital Design Final Project
 * Author:Ben Reese
 * Date: 2013-12-01
 ***************************************************************/
  
 module Paddle_Test();
	// Delcare registers
 	logic up;
	logic down;
	logic reset;
	logic game_on;
	logic	wrap_mode;
	logic clk = 1'b0;
	int ticks_per_px = 50;
	logic moving_up;
	logic moving_down;
	int position;
	int ticks;
	
	// Connect DUT
	Paddle DUT(.up(up), .down(down), .reset(reset), 
			.game_on(game_on), .wrap_mode(wrap_mode), .clk(clk), 
			.ticks_per_px(ticks_per_px), .moving_up(moving_up), 
			.moving_down(moving_down), .position(position), .ticks(ticks));  

	// Generate clock
	 always #10 clk <= ~clk;
	// Generate inputs			
	
	initial begin
		reset = 1'b0;
		#20
		reset = 1'b1;
		assert (position == 600/2); // y_resolution/2
		@(negedge clk)
	//	check_no_game();
		@(negedge clk)
	//	check_wrap();
		check_no_wrap();
		
		$stop();
		
	
	end //initial

	task check_no_game();
		int temp_pos;
		temp_pos <= position;
		down <= 1'b1;
		up <= 1'b0;
		wrap_mode <= 1'b1;
		game_on <= 1'b0;
		#500
		assert (position == temp_pos);
		down <= 1'b0;
		up <= 1'b1;
		#500
		assert (position == temp_pos);
		up <= 1'b0;
	endtask
	
	task check_wrap();
		int temp_pos;
		temp_pos <= position;
		down <= 1'b1; // move down and wrap
		up <= 1'b0;
		wrap_mode <= 1'b1;
		game_on <= 1'b1;
		#100
		while (!(temp_pos < position)) begin
			temp_pos <= position;
			@(negedge clk);
		end
		#500
		up <= 1'b1;
		down <= 1'b0;
		temp_pos <= position;
		while (!(temp_pos > position)) begin
			temp_pos <= position;
			@(negedge clk);
		end
		$display("Wrapping mode works");
		endtask
		
	task check_no_wrap();
		down <= 1'b1; // move down
		up <= 1'b0;
		wrap_mode <= 1'b0;
		game_on <= 1'b1;
		while (position >0) begin
			@(negedge clk);
		end
		#1000
		assert (position == 0);
		up <= 1'b1;
		down <= 1'b0;
		while (position <600) begin
			@(negedge clk);
		end
		#1000
		assert (position ==600);
	endtask
endmodule
	