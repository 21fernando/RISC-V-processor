module io (
    input             clk,
    input             wEn,
    input  [31:0]     addr,
    input  [31:0]     dataIn,
    output [31:0]     dataOut,
    output reg        interrupt,
    output reg [4:0]  interrupt_id,
    input  [15:0]     SW,
    output [3:0]      VGA_R, 
    output [3:0]      VGA_G,
    output [3:0]      VGA_B, 
    output            VGA_HS,
    output            VGA_VS,
    input            VGA_clk
);
    wire [31:0] image_word;
    VGA vga(
        .VGA_clk(VGA_clk),
        .clock(clk),
        .io_device_id(io_device_id), 
        .VGA_R(VGA_R), 
        .VGA_G(VGA_G),
        .VGA_B(VGA_B), 
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .image_word(image_word)
    );

    assign dataOut = 31'd0;
    assign image_word = dataIn;

    reg [15:0] SW_M, SW_Q, SW_last;
    always @(posedge clk) begin
        SW_M <= SW;
        SW_Q <= SW_M;
        SW_last <= SW_Q;
        if (SW_Q != SW_last) begin
            interrupt <= 1'b1;
        end else begin
            interrupt <= 1'b0;
        end
        case (SW_Q)
            16'b0000000000000001: interrupt_id <= 5'd1;
            16'b0000000000000010: interrupt_id <= 5'd2;
            16'b0000000000000100: interrupt_id <= 5'd3;
            16'b0000000000001000: interrupt_id <= 5'd4;
            16'b0000000000010000: interrupt_id <= 5'd5;
            16'b0000000000100000: interrupt_id <= 5'd6;
            16'b0000000001000000: interrupt_id <= 5'd7;
            16'b0000000010000000: interrupt_id <= 5'd8;
            16'b0000000100000000: interrupt_id <= 5'd9;
            16'b0000001000000000: interrupt_id <= 5'd10;
            16'b0000010000000000: interrupt_id <= 5'd11;
            16'b0000100000000000: interrupt_id <= 5'd12;
            16'b0001000000000000: interrupt_id <= 5'd13;
            16'b0010000000000000: interrupt_id <= 5'd14;
            16'b0100000000000000: interrupt_id <= 5'd15;
            16'b1000000000000000: interrupt_id <= 5'd16;
            default: interrupt_id <= 5'd0;
        endcase
    end 

endmodule