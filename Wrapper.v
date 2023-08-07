`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (
	input        clock, 
	input        reset,
	output [3:0] VGA_R, 
	output [3:0] VGA_G,
	output [3:0] VGA_B, 
	output       VGA_HS,
	output       VGA_VS
);

	wire rwe, mwe;
	wire [2:0] access_type;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
	

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "arithmetic.mem";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		.access_type(access_type)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[13:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	//RAM ProcMem(.clk(clock), 
	//	.wEn(mwe), 
	//	.addr(memAddr[11:0]), 
	//	.dataIn(memDataIn), 
	//	.dataOut(memDataOut),
	//	.access_type(access_type));
	wire wEn_io;
	wire [11:0] addr_io;
	wire [31:0] memDataIn_io, memDataOut_io;
	DualRWRAM #(.DATA_WIDTH(32), 	
				.ADDRESS_WIDTH(12), 
				.DEPTH(4096))
	ProcMem(.clk(clock), 
		.wEn_cpu(mwe), 
		.addr_cpu(memAddr[11:0]), 
		.dataIn_cpu(memDataIn), 
		.dataOut_cpu(memDataOut),
		.access_type(access_type),
		.wEn_io(wEn_io), 
		.addr_io(addr_io), 
		.dataIn_io(memDataIn_io), 
		.dataOut_io(memDataOut_io)
		);

	io IO(
		.wEn(wEn_io),
    	.addr(addr_io),
    	.memDataIn(memDataIn_io),
    	.memDataOut(memDataOut_io),
    	.clk(clock),
    	.VGA_R(VGA_R), 
    	.VGA_G(VGA_G),
    	.VGA_B(VGA_B), 
    	.VGA_HS(VGA_HS),
    	.VGA_VS(VGA_VS)
	);

endmodule
