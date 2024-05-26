`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to test your processor for functionality.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. 
 * You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v 
 * and memory modules to work with the Wrapper interface as provided.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must set the parameter when compiling to use the memory file of 
 * the test you created using the assembler and load the appropriate 
 * verification file.
 *
 * For example, you would add sample as your parameter after assembling sample.s
 * using the command
 *
 * 	 iverilog -o proc -c FileList.txt -s Wrapper_tb -PWrapper_tb.FILE=\"sample\"
 *
 * Note the backslashes (\) preceding the quotes. These are required.
 *
 **/

module Wrapper_tb #(parameter FILE = "vga");

	localparam DIR = "/Users/tharindu2003/Documents/FPGA/processor/Test/Output/";
	integer cycles= 0;
	integer num_cycles=1000;
	// Inputs to the processor
	reg clock = 0, reset = 0;
	reg [15:0] SW;
	wire [3:0] VGA_R; 
	wire [3:0] VGA_G;
	wire [3:0] VGA_B; 
	wire       VGA_HS;
	wire       VGA_VS;
	wire       VGA_clk;

	Wrapper  #(
		.INSTR_FILE({"/Users/tharindu2003/Documents/FPGA/processor/Test/Memory/",FILE,".mem"})
		) 
	DUT(
		.clock(clock), 
		.reset(reset),
		.SW(SW),
		.VGA_R(VGA_R), 
		.VGA_G(VGA_G),
		.VGA_B(VGA_B), 
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_clk(VGA_clk)     
	);

	// Create the clock
	always
		#10 clock = ~clock; 

	initial begin

		// Output file name
		$dumpfile({DIR, FILE, ".vcd"});
		// Module to capture and what level, 0 means all wires
		$dumpvars(0, Wrapper_tb);

		// Clear the Processor at the beginning
		reset = 1;
		#1
		reset = 0;

		// Run for the number of cycles specified 
		for (cycles = 0; cycles < num_cycles; cycles = cycles + 1) begin
			@(posedge clock);
		end

		#100;
		$finish;
	end
endmodule
