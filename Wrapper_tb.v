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

	// FileData
	localparam DIR = "Test/";
	localparam MEM_DIR = "Memory/";
	localparam OUT_DIR = "Output/";
	localparam VERIF_DIR = "Verification/";
	localparam DEFAULT_CYCLES = 255;

	// Inputs to the processor
	reg clock = 0, reset = 0;

	// I/O for the processor
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
    wire io_device_id;

	wire rwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, rData, regA, regB;

	wire [3:0] VGA_R; 
	wire [3:0] VGA_G;
	wire [3:0] VGA_B; 
	wire       VGA_HS;
	wire       VGA_VS;

	// Wires for Test Harness
	wire[4:0] rs1_test, rs1_in;
	reg testMode = 0; 
	reg[11:0] num_cycles = 3000;
	reg[15*8:0] exp_text;
	reg null;

	// Connect the reg to test to the for loop
	assign rs1_test = reg_to_test;

	// Hijack the RS1 value for testing
	assign rs1_in = testMode ? rs1_test : rs1;

	// Expected Value from File
	reg signed [31:0] exp_result;

	// Where to store file error codes
	integer expFile, diffFile, actFile, expScan; 

	// Do Verification
	reg verify = 1;

	// Metadata
	integer errors = 0,
			cycles = 0,
			reg_to_test = 0;

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
		.io_write_en(io_write_en),
		.io_device_id(io_device_id)
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
		.cpu_device_id(cpu_device_id)); 
	
	// Instruction Memory (ROM) Windows
	ROM #(.MEMFILE({FILE, ".mem"}), .DATA_WIDTH(32), .ADDRESS_WIDTH(14), .DEPTH(16384))
        InstMem(.clk(clock), 
            .addr(instAddr[13:0]), 
            .dataOut(instData));
	// Instruction Memory (ROM) MAC
//	ROM #(.MEMFILE({DIR, MEM_DIR, FILE, ".mem"}), .DATA_WIDTH(32), .ADDRESS_WIDTH(14), .DEPTH(16384))
//	InstMem(.clk(clock), 
//		.addr(instAddr[13:0]), 
//		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(
		.clock(clock), 
		.ctrl_writeEnable(rwe), 
		.ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1_in), 
		.ctrl_readRegB(rs2), 
		.data_writeReg(rData), 
		.data_readRegA(regA), 
		.data_readRegB(regB));

	//IO controller
	io IO(
		.wEn(io_write_en),
    	.addr(io_addr),
    	.dataIn(io_write_data),
    	.dataOut(io_read_data),
    	.clk(clock),
    	.io_device_id(io_device_id),
    	.VGA_clk(clock),
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

	// Create the clock
	always
		#10 clock = ~clock; 

	//////////////////
	// Test Harness //
	//////////////////

	initial begin
		// Check if the parameter exists
		if(FILE == 0) begin
			$display("Please specify the test");
			$finish;
		end

		$display({"Loading ", FILE, ".mem\n"});

		// Read the expected file
		expFile = $fopen({DIR, VERIF_DIR, FILE, "_exp.txt"}, "r");

			// Check for any errors in opening the file
		if(!expFile) begin
			$display("Couldn't read the expected file.",
				"\nMake sure there is a %0s_exp.txt file in the \"%0s\" directory.", FILE, {DIR ,VERIF_DIR});
			$display("Continuing for %0d cycles without checking for correctness,\n", DEFAULT_CYCLES);
			verify = 0;
		end

		// Output file name
		$dumpfile({DIR, OUT_DIR, FILE, ".vcd"});
		// Module to capture and what level, 0 means all wires
		$dumpvars(0, Wrapper_tb);

		$display();

		// Create the files to store the output
		actFile = $fopen({DIR, OUT_DIR, FILE, "_actual.txt"},   "w");

		if (verify) begin
			diffFile = $fopen({DIR, OUT_DIR, FILE, "_diff.txt"},  "w");

			// Get the number of cycles from the file
			expScan = $fscanf(expFile, "num cycles:%d", 
				num_cycles);

			// Check that the number of cycles was read
			if(expScan != 1) begin
				$display("Error reading the %0s file.", {FILE, "_exp.txt"});
				$display("Make sure that file starts with \n\tnum cycles:NUM_CYCLES");;
				$display("Where NUM_CYCLES is a positive integer\n");
			end
		end

		// Clear the Processor at the beginning
		reset = 1;
		#1
		reset = 0;

		// Run for the number of cycles specified 
		for (cycles = 0; cycles < num_cycles; cycles = cycles + 1) begin
			
			// Every rising edge, write to the actual file
			@(posedge clock);
			if (rwe && rd != 0) begin
				$fdisplay(actFile, "Cycle %3d: Wrote %0d into register %0d", cycles, rData, rd);
			end
		end

		$fdisplay(actFile, "============== Testing Mode ==============");

		if (verify)
			$display("\t================== Checking Registers ==================");

		// Activate the test harness
		testMode = 1;

		// Check the values in the regfile
		for (reg_to_test = 0; reg_to_test < 32; reg_to_test = reg_to_test + 1) begin
			
			if (verify) begin
				// Obtain the register value
				expScan =  $fscanf(expFile, "%s", exp_text);
				expScan = $sscanf(exp_text, "r%d=%d", null, exp_result);

				// Check for errors when reading
				if (expScan != 2) begin
					$display("Error reading value for register %0d.", reg_to_test);
					$display("Please make sure the value is in the format");
					$display("\tr%0d=EXPECTED_VALUE", reg_to_test);

					// Close the Files
					$fclose(expFile);
					$fclose(actFile);
					$fclose(diffFile);

					#100;
					$finish;
				end
			end 
			
			// Allow the regfile output value to stabilize
			#1;

			// Write the register value to the actual file
			$fdisplay(actFile, "Reg %2d: %11d", rs1_test, regA);
			
			// Compare the Values 
			if (verify) begin
				if (exp_result !== regA) begin
					$fdisplay(diffFile, "Reg: %2d Expected: %11d Actual: %11d",
						rs1_test, $signed(exp_result), $signed(regA));
					$display("\tFAILED Reg: %2d Expected: %11d Actual: %11d",
						rs1_test, $signed(exp_result), $signed(regA));
					errors = errors + 1;
				end else begin
					$display("\tPASSED Reg: %2d", rs1_test);
				end
			end
		end

		// Close the Files
		$fclose(expFile);
		$fclose(actFile);

		if (verify)
			$fclose(diffFile);

		// Display the tests and errors
		if (verify)
			$display("\nFinished %0d cycle%c with %0d error%c", cycles, "s"*(cycles != 1), errors, "s"*(errors != 1));
		else 
			$display("Finished %0d cycle%c", cycles, "s"*(cycles != 1));

		#100;
		$finish;
	end
endmodule
