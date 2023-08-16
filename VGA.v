`timescale 1ns / 1ps
module VGA(
    input clk_100MHz, 
    output [3:0] VGA_R, 
    output [3:0] VGA_G,
    output [3:0] VGA_B, 
    output VGA_HS,
    output VGA_VS,
    input [31:0] image_word
    );

    /**
    wire VGA_clk;
    wire locked;
    clk_wiz_0 pll(
        .clk_out1(VGA_clk),            
        .reset(1'b0), 
        .locked(locked),
        .clk_in1(clk_100MHz)
    );**/
    assign VGA_clk = clk_100MHz;
    
    wire active;
    wire [10:0] x_pos;
    wire [9:0] y_pos;
    VGA_counter counter(
        .VGA_clk(VGA_clk),
        .h_sync(VGA_HS),
        .v_sync(VGA_VS),
        .active(active),
        .x_pos(x_pos),
        .y_pos(y_pos)
    );

    // Image Memory
    wire [14:0] image_addr;
    wire [7:0] image_data;
    wire image_wEn;
    wire [14:0] image_ram_addr;
    assign image_addr = image_word[14:0];
    assign image_data = image_word[22:15];
    assign image_wEn = image_word[23];
    assign image_ram_addr = (image_wEn) ? image_addr : {y_pos[6:4] , x_pos};
    RAM_simple #( .DATA_WIDTH(8), 
                  .ADDRESS_WIDTH(15),
                  .DEPTH(16384)) 
    imagr_ram(
        .clk(clk_100MHz),
        .wEn(image_wEn),
        .addr(image_ram_addr),
        .dataIn(image_data),
        .dataOut(color_addr));

    
    //Color ROM: Supports 256 colors
    wire [7:0] color_addr;
    wire [11:0] color_data;
    //C:/Users/taf27/Documents/FPGA/Verilog_VGA/Verilog_VGA.srcs/sources_1/new/color_palette.mem
    ROM #(.MEMFILE("/Users/tharindu2003/Documents/FPGA/processor/color_palette.mem"),
            .DATA_WIDTH(12),
            .ADDRESS_WIDTH(8),
            .DEPTH(256))
	ColorMem(.clk(clk_100MHz), 
		.addr(color_addr), 
		.dataOut(color_data));

    always @(posedge clk_100MHz) begin
        
    end

    assign VGA_R = (active) ? color_data[11:8] : 4'b0000;
    assign VGA_G = (active) ? color_data[7:4] : 4'b0000;
    assign VGA_B = (active) ? color_data[3:0] : 4'b0000;

endmodule
