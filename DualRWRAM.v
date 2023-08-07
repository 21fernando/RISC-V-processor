`timescale 1ns / 1ps
module DualRWRAM #( parameter DATA_WIDTH = 32, ADDRESS_WIDTH = 14, DEPTH = 4096) (
    input wire                     clk,
    
    //cpuESSOR CORE
    input wire                     wEn_cpu,
    input wire [ADDRESS_WIDTH-1:0] addr_cpu,
    input wire [2:0]               access_type,
    input wire [DATA_WIDTH-1:0]    dataIn_cpu,
    output [DATA_WIDTH-1:0]        dataOut_cpu,
    
    //IO
    input wire                     wEn_io,
    input wire [ADDRESS_WIDTH-1:0] addr_io,
    input wire [DATA_WIDTH-1:0]    dataIn_io,
    output reg [DATA_WIDTH-1:0]    dataOut_io
    );
    
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
    assign wEn_1 = wEn_cpu;
    assign wEn_2 = wEn_cpu && (access_type[0] == 1'b1 || access_type[1] == 1'b1);
    assign wEn_3 = wEn_cpu && access_type[1] == 1'b1;
    always @(posedge clk) begin
        if(wEn_1) begin
            MemoryArray[addr_cpu][7:0] <= dataIn_cpu[7:0];
        end
        if(wEn_2) begin
            MemoryArray[addr_cpu][15:8] <= dataIn_cpu[15:8];
        end
        if(wEn_3) begin
            MemoryArray[addr_cpu][31:16] <= dataIn_cpu[31:16];
        end
        dataOut_full <= MemoryArray[addr_cpu];
    end
    assign dataOut_cpu = (access_type[1] == 1'b1) ? dataOut_full :
                        (access_type[0] == 1'b1) ? {16'd0, dataOut_full[15:0]} : 
                        {24'd0, dataOut_full[7:0]};

    always @(posedge clk) begin
        if(wEn_io) begin
            MemoryArray[addr_io][7:0] <= dataIn_io[7:0];
            MemoryArray[addr_io][15:8] <= dataIn_io[15:8];
            MemoryArray[addr_io][31:16] <= dataIn_io[31:16];
        end
        dataOut_io <= MemoryArray[addr_io];
    end
                        
endmodule
