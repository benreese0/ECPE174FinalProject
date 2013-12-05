/***************************************************************
 * Ball
 * 
 * The following file tracks the ball position, the integer output
 * is the center pixel of the ball.
 * 
 * 
 * Project: ECPE 174: Advanced Digital Design Final Project
 * Author:Jennifer Valencia 
 * Date: 2013-11-08
 *
 * Inputs:  
 *				clk: Master 50 MHz clock
 *			   reset: Asynchronous active low reset
 *		      game_on: High when game is running
 *			   paddle_position1, paddle_position2: paddle position of player 1 and 2
 * Outputs: 
 *			   ball_x, ball_y: ball position of x and y coorditate
 *			   wall_hit: High when ball hits wall
 *				paddle_hit: High when ball hits paddle
 *				player1_point, player2_point: High when player 1 or 2 scored a point
 *
 ****************************************************************/
 module Ball(input logic clk, reset,game_on, input int paddle_position1, paddle_position2, dir, input logic [2:0] lvl,
                                 output int ball_x, ball_y, output logic wall_hit, paddle_hit, player1_point, player2_point);
        
        logic ball_move_x, ball_move_y;                         
        
        //constants
        const int X_RESOLUTION = 640;
        const int Y_RESOLUTION = 480;
        
        //velocity
        int BALL_V=1;
		  //assign BALL_V = lvl+5;

        always_ff @ (posedge clk or negedge reset) begin
                
                //resetting
                if (!reset) begin
                        ball_y <= Y_RESOLUTION/2;
                        ball_x <= X_RESOLUTION/2;
                        ball_move_x <= dir;
                        ball_move_y <= dir && player1_point;
                        player1_point <= 1'b0;
                        player2_point <= 1'b0;
                        wall_hit <= 1'b0;
                        paddle_hit <= 1'b0;
								BALL_V <= lvl+1;
      end
                
					else begin
                        // ball move
								
								if (ball_move_x && game_on) 
                                ball_x <= ball_x + BALL_V;
								else if(game_on)
                                ball_x <= ball_x - BALL_V;
								if (ball_move_y && game_on) 
                                ball_y <= ball_y + BALL_V;
								else if(game_on)
                                ball_y <= ball_y - BALL_V;
										  
                        
                        // collision detect
                        //The "+ 5" adds a few pixels so that the ball will for sure detect the collision
								if (ball_y <=5) begin
									ball_move_y <= 1'b1;
									//ball_y <= 5;
									wall_hit <= 1'b1;
                        end              
                        else if (ball_y >= Y_RESOLUTION - 5) begin
									ball_move_y <= 1'b0;
									//ball_y <= Y_RESOLUTION-5;
                           wall_hit <= 1'b1;
                        end else begin
									wall_hit <= 1'b0;
								end

								
								if (ball_x <= 25 && ball_y <= paddle_position1 + 25 && ball_y >= paddle_position1 - 25) begin
									ball_move_x <= 1'b1;
                           paddle_hit <= 1'b1;
                        end                 
                        
                        if (ball_x >= X_RESOLUTION - 25  && ball_y <= paddle_position2 + 25 && ball_y >= paddle_position2 - 25) begin
									ball_move_x <= 1'b0;
                           paddle_hit <= 1'b1;
                        end
								
                        
                        //score detect
                        if (ball_x <= 15)
                                player2_point <= 1'b1;
                        
                        else if (ball_x >= X_RESOLUTION-15)
                                player1_point <= 1'b1;
								else begin
									player1_point <= 1'b0;
									player2_point <= 1'b0;
								end
                                
                end
        end        
 endmodule
 