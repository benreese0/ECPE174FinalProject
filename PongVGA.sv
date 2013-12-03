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
						.DisplayArea(DisplayArea),.CounterX(CounterX),.CounterY(CounterY));
	
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
	
endmodule
	