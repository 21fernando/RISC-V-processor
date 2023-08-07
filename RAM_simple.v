`timescale 1ns / 1ps
module RAM_simple #( parameter DATA_WIDTH = 8, ADDRESS_WIDTH = 14, DEPTH = 4096) (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0]    dataIn,
    output reg [DATA_WIDTH-1:0]    dataOut);
    
    reg[31:0] MemoryArray[0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            MemoryArray[i] <= 8'd0;
        end
        // if(MEMFILE > 0) begin
        //     $readmemh(MEMFILE, MemoryArray);
        // end
    end
    always @(posedge clk) begin
        if(wEn) begin
            MemoryArray[addr] <= dataIn;    
        end
        dataOut <= MemoryArray[addr];
    end
                        
endmodule
