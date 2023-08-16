module io (
    input            wEn,
    input  [31:0]    addr,
    input  [31:0]    dataIn,
    output  [31:0] dataOut,
    input             clk,
    output [3:0]      VGA_R, 
    output [3:0]      VGA_G,
    output [3:0]      VGA_B, 
    output            VGA_HS,
    output            VGA_VS
);
    wire [31:0] image_word;
    VGA vga(
        .clk_100MHz(clk), 
        .VGA_R(VGA_R), 
        .VGA_G(VGA_G),
        .VGA_B(VGA_B), 
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .image_word(image_word)
    );

    assign dataOut = 31'd0;
    assign image_word = dataIn;

endmodule