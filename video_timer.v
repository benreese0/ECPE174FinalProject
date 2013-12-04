// -----------------------------------------------
// 640x480 @ 60Hz, from a 25MHz input clock
// line duration is slightly longer than spec, but 
// number of lines is fewer to compensate
// -----------------------------------------------
module video_timer(input clk25,
						 output hsyncOut,
						 output vsyncOut,
						 output [9:0] xposOut,
						 output [9:0] yposOut);

reg [9:0] xpos;
reg [9:0] ypos;

wire endline = (xpos == 799);

always @(posedge clk25) begin
	if (endline)
	  xpos <= 0;
	else
	  xpos <= xpos + 1;
end

always @(posedge clk25) begin
	if (endline) begin
		if (ypos == 520)
			ypos <= 0;
		else
			ypos <= ypos + 1;	
	end
end
	 
reg hsync, vsync;
always @(posedge clk25) begin
	hsync <= ~(xpos > 664 && xpos <= 759);  // active for 96 clocks
	vsync <= ~(ypos == 490 || ypos == 491);   // active for lines 490 and 491
end

assign hsyncOut = hsync;
assign vsyncOut = vsync;
assign xposOut = xpos;
assign yposOut = ypos;

endmodule
