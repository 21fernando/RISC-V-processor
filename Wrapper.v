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

module Wrapper #(parameter INSTR_FILE = "/Users/tharindu2003/Documents/FPGA/processor/Test/Memory/vga.mem")(
	input        clock, 
	input        reset,
    input [15:0]    SW,
	output [3:0] VGA_R, 
	output [3:0] VGA_G,
	output [3:0] VGA_B, 
	output       VGA_HS,
	output       VGA_VS,
    output       VGA_clk
);

	wire [31:0] cpu_addr;
    wire [2:0] cpu_read_type;
    wire [31:0] cpu_read_data;
    wire cpu_device_id;
    wire [31:0] cpu_write_data;
	wire cpu_write_en;

    wire [31:0] memory_addr;
    wire [2:0] memory_read_type;
    wire [31:0] memory_read_data;
    wire [31:0] memory_write_data;
    wire memory_write_en;

    wire [31:0] io_addr;
    wire [31:0] io_read_data;
    wire [31:0] io_write_data;
    wire io_write_en;

    wire interrupt;
    wire [4:0] interrupt_id;

	wire rwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, rData, regA, regB;
    assign VGA_clk = clock;
    wire locked;
    // clk_wiz_0 pll(
    //     .clk_out1(VGA_clk),            
    //     .reset(1'b0), 
    //     .locked(locked),
    //     .clk_in1(clock)
    //     );	
	
	system_bus sys_bus(
        .cpu_addr(cpu_addr),      //From cpu to peripheral
        .cpu_read_type(cpu_read_type),
        .cpu_read_data(cpu_read_data),     //From peripheral to cpu
        .cpu_device_id(cpu_device_id), 
        .cpu_write_data(cpu_write_data),     //From cpu to peripheral
        .cpu_write_en(cpu_write_en),

        .memory_addr(memory_addr),  //From cpu to memory
        .memory_read_type(memory_read_type),
        .memory_read_data(memory_read_data),   //From memory to cpu
        .memory_write_data(memory_write_data), //From cpu to memory
        .memory_write_en(memory_write_en),

        .io_addr(io_addr),      //From cpu to io
        .io_read_data(io_read_data),       //From io to cpu
        .io_write_data(io_write_data),     //From cpu to io
        .io_write_en(io_write_en)
    );

    // Main Processing Unit
    processor CPU(
        .clock(clock), 
        .reset(reset), 
        //Imem
        .address_imem(instAddr), 
        .q_imem(instData),
        //Regfile
        .ctrl_writeEnable(rwe),     
        .ctrl_writeReg(rd),
        .ctrl_readRegA(rs1),     
        .ctrl_readRegB(rs2), 
        .data_writeReg(rData), 
        .data_readRegA(regA), 
        .data_readRegB(regB),                    
        //System Bus
        .cpu_addr(cpu_addr),
        .cpu_write_data(cpu_write_data),
        .cpu_write_en(cpu_write_en),
        .cpu_read_type(cpu_read_type),
        .cpu_read_data(cpu_read_data),
        .cpu_device_id(cpu_device_id),
        //Interrupt
        .io_interrupt(interrupt),
        .io_interrupt_id(interrupt_id)
        ); 
    
    // Instruction Memory (ROM)
    ROM #(.MEMFILE(INSTR_FILE), .DATA_WIDTH(32), .ADDRESS_WIDTH(14), .DEPTH(16384))
    InstMem(.clk(clock), 
        .addr(instAddr[13:0]), 
        .dataOut(instData));
    
    // Register File
    regfile RegisterFile(
        .clock(clock), 
        .ctrl_writeEnable(rwe), 
        .ctrl_reset(reset), 
        .ctrl_writeReg(rd),
        .ctrl_readRegA(rs1), 
        .ctrl_readRegB(rs2), 
        .data_writeReg(rData), 
        .data_readRegA(regA), 
        .data_readRegB(regB));

    //IO controller
    io IO(
        .clk(clock),
        .wEn(io_write_en),
        .addr(io_addr),
        .dataIn(io_write_data),
        .dataOut(io_read_data),
        .interrupt(interrupt),
        .interrupt_id(interrupt_id),
        .SW(SW),
        .VGA_clk(VGA_clk),
        .VGA_R(VGA_R), 
        .VGA_G(VGA_G),
        .VGA_B(VGA_B), 
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS)
    );

    //RAM
    RAM #(.DATA_WIDTH(8), .ADDRESS_WIDTH(14), .DEPTH(4096))
    dram(
        .clk(clock),
        .wEn(memory_write_en),
        .addr(memory_addr[13:0]),
        .access_type(memory_read_type),
        .dataIn(memory_write_data),
        .dataOut(memory_read_data)
    );

endmodule
