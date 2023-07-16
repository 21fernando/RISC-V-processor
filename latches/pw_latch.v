module pw_latch(
    input clock,
    input reset,
    input [31:0] i_insn,
    input [31:0] i_result,
    input i_MD_rdy,
    output reg [31:0] o_insn,
    output reg [31:0] o_result,
    output reg o_MD_rdy
);

    always @(negedge clock or posedge reset) begin
       if (reset) begin
           o_insn <= 32'd0;
           o_result <= 32'd0;
           o_MD_rdy <= 1'd0;
       end else begin
           o_insn <= i_insn;
           o_result <= i_result;
           o_MD_rdy <= i_MD_rdy;
       end
   end

endmodule