`timescale 1ns / 1ps
module ROM #(parameter DATA_WIDTH = 8, ADDRESS_WIDTH = 14, DEPTH = 16383, MEMFILE = "C:\Users\taf27\Documents\FPGA\RISC-V-processor\Test\Assembly\arithmetic.mem") (
    input wire                     clk,
    input wire [13:0]              addr,
    output reg [31:0]    dataOut = 0);
    
    reg[31:0] MemoryArray[0:16383];
    
    initial begin
        if(MEMFILE > 0) begin
            $readmemb("C:/Users/taf27/Documents/FPGA/RISC-V-processor/Test/Memory/vga.mem", MemoryArray);
        end
    end
    
    always @(posedge clk) begin
        dataOut <=  MemoryArray[addr];
    end
endmodule
