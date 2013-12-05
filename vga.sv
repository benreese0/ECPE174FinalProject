module vga(input logic clk50, output logic H_SYNC, V_SYNC, N_SYNC, N_BLANK, VGA_CLOCK, DISP_EN, output int XPOS, YPOS);

	//logic clk25;
	//vclockdiv vclk(.iclk(clk50),.oclk(V_SYNC));
	//hclockdiv hclk(.iclk(clk50),.oclk(H_SYNC));
	
	assign N_SYNC = 0;
	assign N_BLANK = 1;
	
	/*
	assign R = 1;
	assign G = 1;
	assign B = 1;
	*/
	
	
	int x=0;
	int y=0;
	
	const int XMAX = 640;
	const int YMAX = 480;
	
	const int XPULSE = 96;
	const int YPULSE = 2;
	
	const int X_BP = 48;
	const int Y_BP = 33;
	
	const int X_FP = 16;
	const int Y_FP = 10;
	
	//frontporch + pulse + pixels + backporch
	int XPER = 16+96+640+48;
	int YPER = 10+2+480+33;
	//int XPER = X_BP + XPULSE + XMAX + X_FP;
	//int YPER = Y_BP + YPULSE + YMAX + Y_FP;
	
	const logic HPOL = 0;
	const logic VPOL = 0;
	
	
	
	always_ff@(posedge clk50) begin
		VGA_CLOCK <= ~VGA_CLOCK;
	end
	
	always_ff@(posedge VGA_CLOCK) begin
		if(x<XPER-1)
			x = x+1;
		else begin
			x = 0;
			if(y < YPER-1)
				y = y+1;
			else
				y = 0;
		end
		
		if(x<XMAX+X_FP || x>XMAX+X_FP+XPULSE)
			H_SYNC = ~HPOL;
		else
			H_SYNC = HPOL;
			
		if(y<YMAX+Y_FP || y>YMAX+X_FP+YPULSE)
			V_SYNC = ~VPOL;
		else
			V_SYNC = VPOL;
			
		if(x < XMAX && y < YMAX) begin
			XPOS <= x;
			YPOS <= y;
			DISP_EN <= 1;
		end else begin
			DISP_EN <= 0;
		end
	end
	

endmodule