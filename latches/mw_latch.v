module mw_latch(
    input clock,
    input reset,
    input [31:0] i_insn,
    input [31:0] i_ALU_O,
    input [31:0] i_mem_D,
    output reg [31:0] o_insn,
    output reg [31:0] o_ALU_O,
    output reg [31:0] o_mem_D
);

    always @(negedge clock or posedge reset) begin
       if (reset) begin
           o_insn <= 32'd0;
           o_ALU_O <= 32'd0;
           o_mem_D <= 32'd0;
       end else begin
           o_insn <= i_insn;
           o_ALU_O <= i_ALU_O;
           o_mem_D <= i_mem_D;
       end
   end

endmodule