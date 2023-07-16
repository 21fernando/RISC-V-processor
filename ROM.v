`timescale 1ns / 1ps
module ROM #(parameter DATA_WIDTH = 8, ADDRESS_WIDTH = 14, DEPTH = 16384, MEMFILE = "") (
    input wire                     clk,
    input wire [13:0]              addr,
    output reg [31:0]    dataOut = 0);
    
    reg[7:0] MemoryArray[0:16383];
    
    initial begin
        if(MEMFILE > 0) begin
            $readmemb(MEMFILE, MemoryArray);
        end
    end
    
    always @(posedge clk) begin
        dataOut <= {MemoryArray[addr], MemoryArray[addr+1], MemoryArray[addr+2], MemoryArray[addr+3]};
    end
endmodule
