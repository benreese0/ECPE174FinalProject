/***************************************************************
 * Game Logic
 * 
 * Top level entity, controls if game is playing, paused, not
 * yet started, point made, etc. Also, determines what the 
 * current level of game is.
 * 
 * Project: ECPE 174: Advanced Digital Design Final Project
 * Author:Jennifer Valencia
 * Date: 2013-11-08
 ***************************************************************/
 module GameLogic(input logic clk,game_on,reset, up1, up2, down1, down2, wrap_mode1, wrap_mode2,
					   input int ticks_per_px1, ticks_per_px2, output logic moving_up1, moving_up2, moving_down1,
					   moving_down2, output int ballx, bally, input logic lvl_up, output logic m_clock,
						input logic [2:0] Level, input logic P1Point, P2Point, P1Type, P2Type, 	output logic [2:0] P1Total,
						P2Total, output logic E, RS, RW, ON, output logic [7:0] DB, input logic [1:0] diff1, diff2,
                  output logic moving_up3, moving_up4, moving_down3, moving_down4, input logic quadA, quadB,
						output logic vga_h_sync, vga_v_sync, vgaRed, vgaBlue, vgaGreen);
						
//missing (wires)	paddle: position 
//						ball: paddle_position1, paddle_position2
//						audio: point, win
//						score: P1Point, P2Point
//						compPlayer: position
						
 logic rst;
 logic gameOn;
 wire position1, position2, playerPoint1, playerPoint2,compPosition1, compPosition2, wallHit, paddleHit;
 
 Paddle paddle1(.up(up1), .down(down1), .reset(rst), .game_on(gameOn), .wrap_mode(wrap_mode1), .clk(clk),
					.ticks_per_px(ticks_per_px1), .moving_up(moving_up1), .moving_down(moving_down1),
					.position(position1)); 
 Paddle paddle2(.up(up2), .down(down2), .reset(rst), .game_on(gameOn), .wrap_mode(wrap_mode2), .clk(clk),
					.ticks_per_px(ticks_per_px2), .moving_up(moving_up2), .moving_down(moving_down2),
					.position(position2));  					
					
 Ball gameball(.clk(clk), .reset(rst),.game_on(gameOn), .paddle_position1(position1 | compPosition1), .paddle_position2(position2 | compPosition2),
					.ball_x(ballx), .ball_y(bally), .wall_hit(wallHit), .paddle_hit(paddleHit), .player1_point(playerPoint1), .player2_point(playerPoint2));

 Audio sound(.wall_hit(wallHit), .paddle_hit(paddleHit), .point(playerPoint1 | playerPoint2), .win(P1Total | P2Total == 7), .lvl_up(lvl_up), .clk(clk),
				 .m_clock(m_clock));

 Score points(.clk(clk), .reset(rst), .Level(level), .P1Point(playerPoint1), .P2Point(playerPoint2), .P1Type(P1Type), .P2Type(P2Type),
              .P1Total(P1Total), .P2Total(P2Total), .E(E), .RS(RS), .RW(RW), .ON(ON), .DB(DB));
              
 // do we need moving_up and moving down for computer player?
 compPlayer computer1(.ballY(bally), .reset(rst), .diff(diff1), .game_on(gameOn), .clk(clk), 
                      .position(compPosition1), .moving_up(moving_up3), .moving_down(moving_down3));
 
 compPlayer computer2(.ballY(bally), .reset(rst), .diff(diff2), .game_on(gameOn), .clk(clk), 
                      .position(compPosition2), .moving_up(moving_up4), .moving_down(moving_down4)); 

 //vga needs paddle positions, ballx and bally
 PongVGA gameboard(.clk(clk), .quadA(quadA), .quadB(quadB), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), 
					    .vgaRed(vgaRed), .vgaBlue(vgaBlue), .vgaGreen(vgaGreen));
										  
	
// if someone wins level up! also make level up sound							  
	always_ff @ (posedge clk or negedge reset) begin
		if (!reset) begin
			rst <= 1'b0;
			gameOn <= 1'b1;
		end
	
		else if (game_on && P1Total == 7 | P2Total == 7) begin
			lvl_up <= 1'b1;
			level <= level + 1'b1;
			rst <= 1'b0;
			gameOn <= 1'b1;
		end
	
		else if (game_on <= 1'b0) begin
			gameOn <= 1'b0;
		end
		else 
			gameOn <= 1'b1;
	
	end	
					
endmodule
