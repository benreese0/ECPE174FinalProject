/***************************************************************
 * Audio
 * 
 * Sends output to WM8731
 *		Code borrows modules from Altera MegaModules
 * 
 * Project: ECPE 174: Advanced Digital Design Final Project
 * Author:Ben Reese
 * Date: 2013-11-08
 ***************************************************************/
 
 
 module Audio (
	input logic clk,			//Should be 50MHz
	input logic rst,			//Active low
	input logic wall_hit,	//High ->ball has bounced off wall
	input logic paddle_hit,	//High ->ball has bounced off paddle
	input logic point, 		//High ->player scored a point
	input logic win,			//High ->player has won a game
	input logic lvl_up,		//High ->game up a level
	//the things: Whatever needs to interface with CODEC
	output I2C_SCLK,			//Assign to PIN_B7
	inout I2C_SDAT,			//Assign to PIN_A8
	// Audio CODEC
	output AUD_XCK,			//Assign to PIN_E1
	input AUD_DACLRCK,		//Assign to PIN_E3
	input	AUD_ADCLRCK,		//Assign to PIN_C2 
	input AUD_BCLK,			//Assign to PIN_F2
	input AUD_ADCDAT,			//Assign to PIN_D2
	output AUD_DACDAT		//Assign to PIN_D1
	);
	
logic [31:0] sample;
logic [31:0] bounce_data;
logic [31:0] score_data;
logic [31:0] level_up_data;
logic [11:0] score_addr;
logic [10:0] level_up_addr;
logic	[9:0]  bounce_addr;


assign sample = bounce_data + score_data +level_up_data;
	//sequential logic
	always_ff @(posedge clk or negedge rst) begin
		if (!rst) begin
			bounce_data=0;
			score_data=0;
			level_up_data=0;
			score_addr=0;
			level_up_addr=0;
			bounce_addr=0;
		end
		else begin
			currentstate <= nextstate;
		end
	end
	
	//sub modules
		clock_generator my_clock_gen(
			.CLOCK_27(clk),
			.reset(rst),
			.AUD_XCK(AUD_XCK)
		);

	audio_and_video_config cfg(
		.clk(clk),
		.reset(rst),
		.I2C_SDAT(I2C_SDAT),
		.I2C_SCLK(I2C_SCLK)
	);

	audio_codec codec(
		.clk(clk),
		.reset(rst),
		.read(),
		.write(),
		.writedata_left(),
		.writedata_right(),
		.AUD_ADCDAT(AUD_ADCDAT),
		.AUD_BCLK(AUD_BCLK),
		.AUD_ADCLRCK(AUD_ADCLRCK),
		.AUD_DACLRCK(AUD_DACLRCK),
		.read_ready(), 
		.write_ready(),
		.readdata_left(sample),
		.readdata_right(sample),
		.AUD_DACDAT(AUD_DACDAT)
	);
	
	Score_mem score(
		.address (score_addr),
		.clock(clk),
		.data(0),
		.wren(0),
		.q(score_data) );
	
	Bounce_mem bounce(
		.address (bounce_addr),
		.clock(clk),
		.data(0),
		.wren(0),
		.q(bounce_data) );

	level_up_mem level_up(
		.address (level_up_addr),
		.clock(clk),
		.data(0),
		.wren(0),
		.q(level_up_data) );
	
endmodule