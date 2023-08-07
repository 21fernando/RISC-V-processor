module io (
    output            wEn,
    output  [11:0]    addr,
    output  [31:0]    memDataIn,
    input wire [31:0] memDataOut,
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

    assign wEn = 1'b0;
    assign addr = 12'd1000;
    assign memDataIn = 31'd0;
    assign image_word = memDataOut;

endmodule