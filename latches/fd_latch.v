module fd_latch(
    input clock,
    input reset,
    input [31:0] i_insn,
    input [11:0] i_PC_plus,
    input [11:0] i_PC,
    output reg [31:0] o_insn,
    output reg [11:0] o_PC_plus ,
    output reg [11:0] o_PC
);

    always @(negedge clock or posedge reset) begin
       if (reset) begin
           o_insn <= 32'd0;
           o_PC_plus <= 12'd0;
           o_PC <= 12'd0;
       end else begin
           o_insn <= i_insn;
           o_PC_plus <= i_PC_plus;
           o_PC <= i_PC;
       end
   end

endmodule