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
 module Game_Logic(input logic clk,game_on,reset, input logic joystickup1, joystickup2, joystickdown1,joystickdown2,
						output logic moving_up1, moving_up2, moving_down1, moving_down2, output int ballx, bally,
					   output logic [2:0] P1Total, P2Total, output logic E, RS, RW, ON, output logic [7:0] DB, input logic [1:0] diff1, diff2, 
						output I2C_SCLK, inout I2C_SDAT, output AUD_XCK, input AUD_DACLRCK, input AUD_ADCLRCK, input AUD_BCLK,
						input AUD_ADCDAT, output AUD_DACDAT, input logic quadA, quadB, output logic vga_h_sync, vga_v_sync,
						vgaRed, vgaBlue, vgaGreen);
						
//missing (wires)	ball: paddle_position1, paddle_position2
//						audio: point, win
//						score: P1Point, P2Point
//						compPlayer: position
			
 logic rst;
 logic gameOn;
 logic lvl_up;
 logic [2:0] level;
 wire playerPoint1, playerPoint2,compPosition1, compPosition2, wallHit, paddleHit;
 
 compPlayer computer1(.ballY(bally), .reset(rst), .diff(diff1), .game_on(gameOn), .clk(clk), .up(joystickup1), .down(joystickdown1), 
                      .position(compPosition1), .going_Up(moving_up1), .going_Down(moving_down1));
 
 compPlayer computer2(.ballY(bally), .reset(rst), .diff(diff2), .game_on(gameOn), .clk(clk), .up(joystickup2), .down(joystickdown2), 
                      .position(compPosition2), .going_Up(moving_up2), .going_Down(moving_down2));
							 
 Ball gameball(.clk(clk), .reset(rst),.game_on(gameOn), .paddle_position1(compPosition1), .paddle_position2(compPosition2),
					.ball_x(ballx), .ball_y(bally), .wall_hit(wallHit), .paddle_hit(paddleHit), .player1_point(playerPoint1), .player2_point(playerPoint2));

 Audio sound(.wall_hit(wallHit), .paddle_hit(paddleHit), .point(playerPoint1 | playerPoint2), .win(P1Total | P2Total == 7), .lvl_up(lvl_up), .clk(clk),
				 .rst(rst), .I2C_SCLK(I2C_SCLK), .I2C_SDAT(I2C_SDAT), .AUD_XCK(AUD_XCK), .AUD_DACLRCK(AUD_DACLRCK), .AUD_ADCLRCK(AUD_ADCLRCK), 
				 .AUD_BCLK(AUD_BCLK), .AUD_ADCDAT(AUD_ADCDAT), .AUD_DACDAT(AUD_DACDAT));

 Score points(.clk(clk), .reset(rst), .Level(level), .P1Point(playerPoint1), .P2Point(playerPoint2), .P1Type(diff1), .P2Type(diff2),
              .P1Total(P1Total), .P2Total(P2Total), .E(E), .RS(RS), .RW(RW), .ON(ON), .DB(DB)); 

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
