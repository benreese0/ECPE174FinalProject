module display(input logic VGA_CLOCK, input int XPOS, YPOS, input logic DISP_EN, output logic R, G, B, input int PADDLE1Y, PADDLE2Y, BALLX, BALLY);
	
	//dimensions are halves
	int PADDLE_WIDTH = 5;
	int PADDLE_HEIGHT = 25;
	
	int BALL_WIDTH = 5;
	int BALL_HEIGHT = 5;
	
	int PADDLE1X = 20;
	//int PADDLE1Y = 180;
	
	int PADDLE2X = 620;
	//int PADDLE2Y = 280;
	
	//int BALLX = 310;
	//int BALLY = 200;
	
	
	always_ff@(posedge VGA_CLOCK) begin
		if(DISP_EN) begin
			if(XPOS > PADDLE1X - PADDLE_WIDTH && XPOS < PADDLE1X+PADDLE_WIDTH
				&& YPOS > PADDLE1Y - PADDLE_HEIGHT && YPOS < PADDLE1Y+PADDLE_HEIGHT)
			begin
				R = 1;
				B = 1;
				G = 1;
			end else if(XPOS > PADDLE2X - PADDLE_WIDTH && XPOS < PADDLE2X+PADDLE_WIDTH
				&& YPOS > PADDLE2Y - PADDLE_HEIGHT && YPOS < PADDLE2Y+PADDLE_HEIGHT)
			begin
				R = 1;
				B = 1;
				G = 1;
			end else if(XPOS > BALLX - BALL_WIDTH && XPOS < BALLX+BALL_WIDTH
				&& YPOS > BALLY - BALL_HEIGHT && YPOS < BALLY+BALL_HEIGHT)
			begin
				R = 1;
				B = 1;
				G = 1;
			end else if(XPOS == 0 || XPOS == 639 || YPOS == 0 || YPOS == 479) begin
				R = 1;
				B = 1;
				G = 1;
			end else begin
				R = 0;
				B = 1;
				G = 0;
			end
		end else begin
			R = 0;
			G = 0;
			B = 0;
		end
	end

endmodule