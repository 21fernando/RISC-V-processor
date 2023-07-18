`timescale 1ns / 1ps
module RAM #( parameter DATA_WIDTH = 8, ADDRESS_WIDTH = 14, DEPTH = 4096) (
    input wire                     clk,
    input wire                     wEn,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [2:0]               access_type,
    input wire [31:0]    dataIn,
    output [31:0]    dataOut);
    
    reg[31:0] MemoryArray[0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1) begin
            MemoryArray[i] <= 32'd0;
        end
        // if(MEMFILE > 0) begin
        //     $readmemh(MEMFILE, MemoryArray);
        // end
    end
    reg [31:0] dataOut_full = 0;
    assign wEn_1 = wEn;
    assign wEn_2 = wEn && (access_type[0] == 1'b1 || access_type[1] == 1'b1);
    assign wEn_3 = wEn && access_type[1] == 1'b1;
    always @(posedge clk) begin
        if(wEn_1) begin
            MemoryArray[addr][7:0] <= dataIn[7:0];
        end
        if(wEn_2) begin
            MemoryArray[addr][15:8] <= dataIn[15:8];
        end
        if(wEn_3) begin
            MemoryArray[addr][31:16] <= dataIn[31:16];
        end
        dataOut_full <= MemoryArray[addr];
    end
    assign dataOut = (access_type[1] == 1'b1) ? dataOut_full :
                        (access_type[0] == 1'b1) ? {16'd0, dataOut_full[15:0]} : 
                        {24'd0, dataOut_full[7:0]};
                        
endmodule
