module pc_latch(
    input clock,
    input reset, 
    input [11:0] d,
    output reg [11:0] q
);

    always @(negedge clock or posedge reset) begin
       if (reset) begin
           q <= 12'd0;
       end else begin
           q <= d;
       end
   end

endmodule