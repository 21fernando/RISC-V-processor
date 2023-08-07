`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2023 09:09:11 PM
// Design Name: 
// Module Name: VGA_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_counter(
    input VGA_clk,
    output h_sync,
    output v_sync,
    output active,
    output reg [10:0] x_pos = 11'd0,
    output reg [9:0] y_pos = 10'd0
    );

    localparam [10:0] H_FRONT_PORCH = 11'd72;
    localparam [10:0] H_ACTIVE = 11'd1368;
    localparam [10:0] H_SYNC = 11'd144;
    localparam [10:0] H_BACK_PORCH = 11'd216;
    localparam [10:0] H_TOTAL = 11'd1800;

    localparam [9:0] V_FRONT_PORCH = 10'd1;
    localparam [9:0] V_ACTIVE = 10'd768;
    localparam [9:0] V_SYNC = 10'd3;
    localparam [9:0] V_BACK_PORCH = 10'd23;
    localparam [9:0] V_TOTAL = 10'd795;

    reg end_of_line;

    always @(x_pos) begin
        end_of_line = (x_pos == H_TOTAL-1);
    end

    always @(posedge VGA_clk) begin
        if (x_pos < H_TOTAL - 1) x_pos <= x_pos + 1;
        else x_pos <= 11'd0;
    end

    always @(posedge VGA_clk) begin
        if (end_of_line) begin
            if (y_pos < V_TOTAL - 1) y_pos <= y_pos + 1;
            else y_pos <= 10'd0;
        end
    end

    assign h_sync = (x_pos >= H_SYNC);
    assign v_sync = (y_pos >= V_SYNC);
    assign active = (x_pos >= H_SYNC && x_pos < H_SYNC + H_ACTIVE && y_pos >= V_SYNC && y_pos < V_SYNC + V_ACTIVE);
endmodule
