// ALU Functions:
// ADD  : 0000
// SUB  : 1000
// SLL  : 0001
// SLT  : 0010
// SLTU : 0011
// SRL  : 0101
// SRA  : 1101
// XOR  : 0100
// AND  : 0111
// OR   : 0110

module alu(
    input signed [31:0] data_operandA, 
    input signed [31:0] data_operandB, 
    input [3:0] ctrl_ALUopcode,
    output reg [31:0] data_result);

    wire[31:0] add_sub_out, add, sub;
    assign add = data_operandA + data_operandB;
    assign sub = data_operandA - data_operandB;
    assign add_sub_out = ctrl_ALUopcode[3] == 1'b0 ? 
        add : sub;

    wire[31:0] sr_out, sr_out_1, sr_out_2;
    wire [4:0] shamt;
    assign shamt = data_operandB[4:0];
    assign sr_out = (ctrl_ALUopcode[3] == 1'b0) ? 
        data_operandA >> data_operandB[4:0] : data_operandA >>> data_operandB[4:0];
    wire[31:0] slt_out, sltu_out;
    wire same_sign, slt_bit, sltu_bit;
    assign same_sign = data_operandA[31] ~^ data_operandB[31];
    assign slt_bit = (same_sign == 1'b1) ? ~sub[31] : data_operandB[31];
    assign sltu_bit = (same_sign == 1'b1) ? ~sub[31] : data_operandA[31];
    assign slt_out = {31'd0, slt_bit};
    assign sltu_out = {31'd0, sltu_bit};

    always @(*) begin
        case (ctrl_ALUopcode[2:0])
            3'b000: data_result = add_sub_out;
            3'b001: data_result = data_operandA << data_operandB[4:0];
            3'b010: data_result = slt_out;
            3'b011: data_result = sltu_out;
            3'b101: data_result = sr_out;
            3'b100: data_result = data_operandA ^ data_operandB;
            3'b110: data_result = data_operandA | data_operandB;
            3'b111: data_result = data_operandA & data_operandB; 
        endcase
    end

endmodule