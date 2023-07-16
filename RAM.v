`timescale 1ns / 1ps
module RAM #( parameter DATA_WIDTH = 8, ADDRESS_WIDTH = 14, DEPTH = 16384) (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [2:0]               access_type,
    input wire [31:0]    dataIn,
    output reg [31:0]    dataOut = 0);
    
    reg[DATA_WIDTH-1:0] MemoryArray[0:DEPTH-1];
    
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
            //Store the byte at addr regardless of the type
            MemoryArray[addr] <= dataIn[7:0];
            //Store the second byte for SH and SW
            if(access_type[0] == 1'b1 || access_type[1] == 1'b1) begin
                MemoryArray[addr + 1] <= dataIn[15:8];
            end
            //Store top two bytes for SW
            if(access_type[1] == 1'b1) begin
                MemoryArray[addr+2] <= dataIn[23:16];
                MemoryArray[addr+3] <= dataIn[31:24];
            end
        end else begin
            //Load bottom byte regardless
            dataOut[7:0] <= MemoryArray[addr];
            //Load second byte for LH, LW, SX handling for LBU
            dataOut[15:8] <= (access_type[0] == 1'b1 || access_type[1] == 1'b1) ? MemoryArray[addr + 1] : {8{~access_type[2] & MemoryArray[addr][7]}};
            //Load upper half word
            dataOut[31:16] <= (access_type[1] == 1'b1) ? {MemoryArray[addr + 2], MemoryArray[addr+3]} : {16{~access_type[2] & MemoryArray[addr+1][7]}};

        end
    end
endmodule
