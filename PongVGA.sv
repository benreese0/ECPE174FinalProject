//Sam Mills
//Final Project for VGA pong stuff
//Insanity is doing the same thing over and over again 
//and expecting different results
//-Albert Einstein
//this is the full output with paddles and ball
//source from fpga4fun.com
module PongVGA(input logic clk, quadA, quadB,
					output logic vga_h_sync, vga_v_sync, 
					output logic vgaRed, vgaBlue, vgaGreen);
					//clk is clock, quadA is..., quadB is...
					//vga_h_sync is the horizontal edge
					//vga_v_sync is the vertical edge
					//vgaRed/Green/Blue are for the colored pixels
					
	logic [9:0] CounterX;//pulled in from the sync
	logic [8:0] CounterY;
	logic DisplayArea;//Display signals, all internal here. 
	
	//linking with the hvsync
	hvsync syncgen(.clk(clk),.vga_h_sync(vga_h_sync),.vga_v_sync(vga_v_sync),
						.DisplayArea(DisplayArea),.CounterXout(CounterX),.CounterYout(CounterY));
	
		logic [8:0] PaddlePosition; //The padde position
		logic [2:0] quadAr, quadBr;//?
		
		always_ff @(posedge clk)
			quadAr <= {quadAr[1:0], quadA};
		always_ff @(posedge clk)
			quadBr <= {quadBr[1:0], quadB};
	
		always_ff @(posedge clk)
		if(quadAr[2] ^ quadAr[1] ^ quadBr[2] ^ quadBr[1])
		begin
			if(quadAr[2] ^ quadBr[1])
			begin
				if(~&PaddlePosition) //make sure the values doesnt overflow
					PaddlePosition <= PaddlePosition +1;
			end
			else
			begin
				if(|PaddlePosition) //make sure the value doesnt overflow
					PaddlePosition <= PaddlePosition-1;
			end
		end
		//////////////////////////////////////////////////
		logic [9:0] ballX;
		logic [8:0] ballY;
		logic ball_inX, ball_inY;
		
		always_ff @(posedge clk)
		begin
			if(ball_inX==0)
				ball_inX<=(CounterX==ballX)& ball_inY;
			else
				ball_inX<= !(CounterX==ballX+16);
		end
		
		always_ff @(posedge clk)
		begin
			if(ball_inY==0) 
				ball_inY <= (CounterY==ballY); 
			else
				ball_inY <= !(CounterY==ballY+16);
		end
		
		logic ball;
		assign ball = ball_inX & ball_inY;
		//////////////////////////////////////////////////
		logic border; 
		assign border = ((CounterX[9:3]==0)||(CounterX[9:3]==79)||(CounterY[8:3]==0)||(CounterY[8:3]==59));
		logic paddle;
		assign paddle = (CounterX>=PaddlePosition+8) && (CounterX<=PaddlePosition+120) && (CounterY[8:4]==27);
		logic BouncingObject;
		assign BouncingObject = border|paddle;//active if the border or paddle is redrawing itself
		
		logic ResetCollision;
		always_ff @(posedge clk)
			ResetCollision<=(CounterY==500)&(CounterX==0);//active only once for every video fram
		
		logic CollisionX1,CollisionX2, CollisionY1, CollisionY2;
		always_ff @(posedge clk)
		begin
			if(ResetCollision) 
				CollisionX1<=0; 
			else if(BouncingObject & (CounterX==ballX) & (CounterY==ballY+ 8)) 
				CollisionX1<=1;
		end
		always_ff @(posedge clk) 
		begin
			if(ResetCollision) 
				CollisionX2<=0; 
			else if(BouncingObject & (CounterX==ballX+16) & (CounterY==ballY+ 8)) 
				CollisionX2<=1;
		end
		always_ff @(posedge clk) 
		begin
			if(ResetCollision) 
				CollisionY1<=0; 
			else if(BouncingObject & (CounterX==ballX+ 8) & (CounterY==ballY)) 
				CollisionY1<=1;
		end
		always_ff @(posedge clk) 
		begin
			if(ResetCollision) 
				CollisionY2<=0; 
			else if(BouncingObject & (CounterX==ballX+ 8) & (CounterY==ballY+16)) 
				CollisionY2<=1;
		end
		
		//////////////////////////////////////////////////////
		logic UpdateBallPosition;
		assign UpdateBallPosition=ResetCollision;//update the ball position at the same time of collision detectors
		logic ball_dirx, ball_diry;
		always_ff @(posedge clk)
		if(UpdateBallPosition)
		begin
			if(~(CollisionX1&CollisionX2))//if collision on both x sides, dont move the x direction
			begin
				ballX<=ballX+(ball_dirx ? -1:1);
				if(CollisionX2) 
					ball_dirx<=1;
				else if (CollisionX1) 
					ball_dirx<=0;
			end
			if(~(CollisionY1&CollisionY2))//if collison on both y sides, dont move in the y direction
			begin
				ballY<=ballY+(ball_diry?-1:1);
				if(CollisionY2)
					ball_diry<=1;
				else if(CollisionY1)
					ball_diry<=0;
			end
		end
		
		//////////////////////////////////////////////////
		logic R;
		assign R=BouncingObject | ball | (CounterX[3] ^ CounterY[3]);
		logic G;
		assign G=BouncingObject | ball;
		logic B;
		assign B=BouncingObject | ball;
		
		logic vga_r, vga_g, vga_b;
		always_ff @(posedge clk)
		begin
			vga_r<=R & DisplayArea;
			vga_g<=G & DisplayArea;
			vga_b<=B & DisplayArea;
		end
		
endmodule
	