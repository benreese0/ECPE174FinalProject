/***************************************************************
 * SystemVerilog Masterclk clock divider
 * 
 * Provides framework for clock divider code to step down
 *  the 50MHz internal clock
 * Set the XXX value in the define for the appropriate division
 *
 * Author: Elizabeth Basha
 * Date: 09/04/2013
 */
 
 module hclockdiv(input logic iclk,
						output logic oclk);

	// define the parameter for number of clock edges to count
	const int HALF_OF_CLK_CYCLE_VALUE = 32'd250000; // change this value was 794
	
	// internal variables for clock divider
	int count = 32'd0;
	logic clkstate = 1'b0;

	// generate clock signal
	always_ff @(posedge iclk)
		if(count == (HALF_OF_CLK_CYCLE_VALUE-1))
		begin
			// we have seen half of a cycle, toggle the clock
			count <= 32'd0;
			clkstate <= ~clkstate;
		end else begin
			count <= count + 32'd1;
			clkstate <= clkstate;
		end
		
	assign oclk = clkstate;
	
 endmodule