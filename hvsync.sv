//Sam Mills
//Final Project for VGA pong stuff
//beep boop, fired up and ready to serve
//This one is just a sync that was recommended, not really necissary
//source from fpga4fun.com
module hvsync (input logic clk, 
					output logic vga_h_sync, vga_v_sync, DisplayArea,
					output logic [9:0] CounterYout,
					output logic [8:0] CounterXout);
					
	logic [9:0] CounterX;
	logic [8:0] CounterY;			
	logic [9:0] CounterXmaxed=767;//(CounterX==767);
	
	//incriments the X counter up to max of 767
	always_ff @(posedge clk)
	begin
		if(CounterXmaxed)
			CounterX<=0;
		else
			CounterX<=CounterX+1;
	end
	
	//incriments the Y counter up to max 512
	always_ff @(posedge clk)
		if(CounterXmaxed) CounterY <= CounterY+1;
	
	//used to place the screen
	logic vga_hs, vga_vs;
	always_ff @(posedge clk)
	begin
		vga_hs <= (CounterX[9:4]==45);//change is value to move display horizontally
		vga_vs <= (CounterY==500);//change this value to move the display vertically
	end
	
	//display
	always_ff @(posedge clk)
	begin
		if(DisplayArea==0)
			DisplayArea<=(CounterXmaxed && CounterY<480);
		else
			DisplayArea <= !(CounterX==639);
	end
	
	assign vga_h_sync = ~vga_hs;
	assign vga_v_sync = ~vga_vs;
	assign CounterXout = CounterX;
	assign CounterYout = CounterY;
endmodule
