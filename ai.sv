/********************************************************
********* Computer Player aka A.I. **********************
* This file will be used to have a computer player to 
* compete against. It will have the ball position as an input
* and a level */


module compPlayer        (        input int ballY,
                                input logic reset,
                                input logic [1:0] diff,
                                input logic game_on,
                                input logic clk, 
										  input logic up,
										  input logic down,
                                output int position,
                                output logic going_Up,
                                output logic going_Down);
logic goingUp;
logic goingDown;
int tickCount = 0;

        Paddle comp(.up(goingUp), .down(goingDown), .reset(reset), .game_on(game_on), .wrap_mode(1'b0), .clk(clk), .ticks_per_px(tickCount),
		  .position(position), .moving_up(going_Up), .moving_down(going_Down));
		  
        always_ff @(posedge clk) begin
                case(diff)
                        2'b00: tickCount<=20000;
                        2'b01: tickCount<=80000;
                        2'b10: tickCount<=40000;
                        2'b11: tickCount<=20000;
                endcase

			end

        always_comb begin
						if (diff==2'b00)
                        begin
									goingUp<=up;
									goingDown<=down;
                        end

                else if (ballY>position)
                        begin
                                goingUp<=0;
                                goingDown<=1;
                        end
                else if (ballY<position)
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

