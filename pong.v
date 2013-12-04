// -----------------------------------------------
// top-level module
// -----------------------------------------------
module pong(
    input clk50,
    input rota,
    input rotb,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output hsync,
    output vsync
    );

// divide input clock by two, and use a global 
// clock buffer for the derived clock
reg clk25_int;
always @(posedge clk50) begin
	clk25_int <= ~clk25_int;
end

wire clk25;
//BUFG bufg_inst(clk25, clk25_int);
//must buffer the clock


wire [9:0] xpos;
wire [9:0] ypos;

video_timer video_timer_inst(clk25, hsync, vsync, xpos, ypos);
game game_inst(clk25, xpos, ypos, rota, rotb, red, green, blue);
					
endmodule

