/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    input clock,                          // I: The master clock
    input reset,                          // I: A reset signal

    // Imem
    output [31:0] address_imem,           // O: The address of the data to get from imem
    input [31:0] q_imem,                  // I: The data from imem

    // Dmem
    output [31:0] cpu_addr,           // O: The address of the data to get or put from/to dmem
    output[31:0] cpu_write_data,                    // O: The data to write to dmem
    output cpu_write_en,                          // O: Write enable for dmem
    output [2:0] cpu_read_type,
    input [31:0] cpu_read_data,                  // I: The data from dmem
    output cpu_device_id,

    // Regfile
    output ctrl_writeEnable,               // O: Write enable for RegFile
    output [4:0] ctrl_writeReg,            // O: Register to in RegFile
    output [4:0] ctrl_readRegA,            // O: Register to read from port A of RegFile
    output [4:0] ctrl_readRegB,            // O: Register to read from port B of RegFile
    output [31:0] data_writeReg,           // O: Data to write to for RegFile
    input [31:0] data_readRegA,            // I: Data from port A of RegFile
    input [31:0]data_readRegB              // I: Data from port B of RegFile
	 
	);

    //Stall wire
    wire stall;
    assign stall = bypassing_stall;
    
	/* YOUR CODE STARTS HERE */

    //=======================================================================//
    //========================== FETCH STAGE ================================//
    //=======================================================================//
    
    //Latch output wires
    wire [31:0] D_insn;
    wire [11:0] D_PC_plus, D_PC;

    //PC wires
    wire [11:0] PC_in, PC_out, PC_plus;

    pc_latch pc_reg(
        .clock(clock),
        .reset(reset), 
        .d(PC_in),
        .q(PC_out)
    );

    assign PC_plus = PC_out + 4;
    assign PC_in = (E_branched_jumped) ? E_PC_target : ((stall) ? PC_out : PC_plus);

    assign address_imem = {22'd0, PC_out[11:2]};
    
    fd_latch fd_latch_a(
        .clock(clock),
        .reset(reset),
        .i_insn((stall) ? D_insn : (E_branched_jumped) ? 32'd0 : q_imem),
        .i_PC_plus((stall) ? PC_out : PC_plus),
        .i_PC(PC_out),
        .o_insn(D_insn),
        .o_PC_plus(D_PC_plus),
        .o_PC(D_PC)
    );

    //=======================================================================//
    //========================== DECODE STAGE ===============================//
    //=======================================================================//
    
    //Latch output wires
    wire [11:0] E_PC_plus, E_PC;
    wire [31:0] E_insn, E_regfile_A, E_regfile_B, dx_latch_insn_in;
    
    assign ctrl_writeEnable = W_we;
    assign ctrl_writeReg = W_rd;
    assign ctrl_readRegA = D_insn[19:15]; //RS1
    assign ctrl_readRegB = D_insn[24:20]; //RS2
    assign data_writeReg = W_write_data;
    //Branch flush
    assign dx_latch_insn_in = (stall || E_branched_jumped) ? 32'd0 : D_insn;
    dx_latch dx_latch_a(
        .clock(clock),
        .reset(reset),
        .i_insn(dx_latch_insn_in),
        .i_PC_plus(D_PC_plus),
        .i_PC(D_PC),
        .i_regfile_A(data_readRegA),
        .i_regfile_B(data_readRegB),
        .o_insn(E_insn),
        .o_PC_plus(E_PC_plus), 
        .o_PC(E_PC),
        .o_regfile_A(E_regfile_A),
        .o_regfile_B(E_regfile_B)
    );

    //=======================================================================//
    //========================= EXECUTE STAGE ===============================//
    //=======================================================================//
    //ALU wires 
    wire [31:0] E_alu_op_a, E_alu_op_b, E_alu_out, E_ALU_o_selected;
    wire [3:0] E_alu_opcode;

    //Latch output wires
    wire [31:0] M_insn, M_alu_out, M_regfile_B; 
    
    wire [31:0] E_sx_immed, E_I_immed, E_S_immed, E_B_immed, E_U_immed, E_J_immed;
    wire E_immed_insn;

    //Bypassing
    wire [4:0] E_byp_B_part;
    assign E_byp_B_part = E_insn[24:20];
    wire [31:0] E_regfile_A_byp, E_regfile_B_byp;
    wire E_M_X_byp_A, E_M_X_byp_B, E_W_X_byp_A, E_W_X_byp_B, M_insn_doesnt_write_rd, W_insn_doesnt_write_rd;
    assign M_insn_doesnt_write_rd = (M_insn[6:0]==7'b0100011) || (M_insn[6:0]==7'b1100011);
    assign W_insn_doesnt_write_rd = (W_insn[6:0]==7'b0100011) || (W_insn[6:0]==7'b1100011);
    assign E_uses_rs2 = (E_insn[6:0] == 7'b0110011) || (E_insn[6:0] == 7'b0100011) || (E_insn[6:0] == 7'b1100011);
    assign E_M_X_byp_A = M_insn[11:7] == E_insn[19:15] && ~M_insn_doesnt_write_rd && E_insn[19:15] != 5'd0;
    assign E_W_X_byp_A = W_insn[11:7] == E_insn[19:15] && ~W_insn_doesnt_write_rd && E_insn[19:15] != 5'd0;
    assign E_M_X_byp_B = M_insn[11:7] == E_insn[24:20] && ~M_insn_doesnt_write_rd && E_uses_rs2 && E_insn[24:20] != 5'd0;
    assign E_W_X_byp_B = W_insn[11:7] == E_insn[24:20] && ~W_insn_doesnt_write_rd && E_uses_rs2 && E_insn[24:20] != 5'd0;
    assign E_regfile_A_byp = (E_M_X_byp_A)? M_alu_out:
                            (E_W_X_byp_A) ? W_write_data : 
                            E_regfile_A;
    assign E_regfile_B_byp = (E_M_X_byp_B)? M_alu_out:
                            (E_W_X_byp_B) ? W_write_data : 
                            E_regfile_B;

    assign E_not_immed_insn = (E_insn[6:0] == 7'b0110011) | (E_insn[6:4] == 3'b110);
    assign E_I_immed = {{21{E_insn[31]}}, E_insn[30:20]};
    assign E_S_immed = {{21{E_insn[31]}}, E_insn[30:25], E_insn[11:7]};
    assign E_B_immed = {{19{E_insn[31]}}, E_insn[7], E_insn[30:25], E_insn[11:8], 1'b0};
    assign E_U_immed = {E_insn[31], E_insn[30:20], E_insn[19:12], 13'd0};
    assign E_J_immed = {{12{E_insn[31]}}, E_insn[19:12], E_insn[20], E_insn[30:25], E_insn[24:21], 1'b0};
    assign E_sx_immed = (E_insn[6:0] == 7'b0100011) ? E_S_immed :
                        (E_insn[6:0] == 7'b1100011) ? E_B_immed : 
                        (E_insn[6:0] == 7'b1101111) ? E_J_immed :
                        (E_insn[4:0] == 5'b10111)   ? E_U_immed : E_I_immed;

    assign E_alu_op_a = E_regfile_A_byp;
    assign E_alu_op_b = (E_not_immed_insn) ? E_regfile_B_byp:  E_sx_immed; 
    wire [20:0] E_alu_opcode_bottom;
    wire E_alu_opcode_top;
    assign E_alu_opcode_bottom = (E_insn[4:0] == 5'b10011) ? E_insn[14:12] :  3'b000;
    assign E_alu_opcode_top = (E_insn[6:0] == 7'b0110011) ? E_insn[30] : 
                                (E_insn[6:0] == 7'b0010011 && E_insn[14:12] == 3'd5) ? E_insn[30] :
                                (E_insn[6:4] == 3'b110) ? 1'b1 : 1'b0;
    assign E_alu_opcode = {E_alu_opcode_top, E_alu_opcode_bottom};
    alu alu_a(
        .data_operandA(E_alu_op_a), 
        .data_operandB(E_alu_op_b), 
        .ctrl_ALUopcode(E_alu_opcode), 
        .data_result(E_alu_out)
    );

    //Branch Jump logic
    wire E_UI_insn, E_branched_jumped, E_B_insn, E_BEQ_insn, E_BNE_insn, E_BLT_insn, E_BGE_insn, E_BLTU_insn, E_BGEU_insn, E_JAL_insn, E_JALR_insn, E_BEQ_taken, E_BNE_taken, E_BLT_taken, E_BGE_taken, E_BLTU_taken, E_BGEU_taken;
    wire [31:0] E_PC_target, E_PC_adder_out, E_PC_adder_in_A, E_PC_adder_in_B;
    assign E_B_insn = (E_insn[6:0] == 7'b1100011);
    assign E_BEQ_insn = E_B_insn & (E_insn[14:12] == 3'd0);
    assign E_BNE_insn = E_B_insn & (E_insn[14:12] == 3'd1);
    assign E_BLT_insn = E_B_insn & (E_insn[14:12] == 3'd4);
    assign E_BGE_insn = E_B_insn & (E_insn[14:12] == 3'd5);
    assign E_BLTU_insn = E_B_insn & (E_insn[14:12] == 3'd6);
    assign E_BGEU_insn = E_B_insn & (E_insn[14:12] == 3'd7);
    assign E_JAL_insn = (E_insn[6:0] == 7'b1101111);
    assign E_JALR_insn = (E_insn[6:0] == 7'b1100111) & (E_insn[14:12] == 3'd0);
    assign E_BEQ_taken = E_BEQ_insn & (E_alu_out == 32'd0);
    assign E_BNE_taken = E_BNE_insn & (E_alu_out != 32'd0);
    assign E_BLT_taken = E_BLT_insn & (E_alu_out[31] & (E_alu_out != 32'd0));
    assign E_BGE_taken = E_BGE_insn & ~E_alu_out[31];
    assign E_BLTU_taken = E_BLTU_insn & ((~(E_alu_op_a[31] ^ E_alu_op_b[31]) & E_alu_out[31]) | (~E_alu_op_a[31] & E_alu_op_b));
    assign E_BGEU_taken = E_BGEU_insn & ((~(E_alu_op_a[31] ^ E_alu_op_b[31]) & ~E_alu_out[31]) | (E_alu_op_a[31] & ~E_alu_op_b));
    assign E_UI_insn = (E_insn[6:0] == 7'b0110111) || (E_insn[6:0] == 7'b0010111);
    or branch_or (E_branched_jumped, E_JAL_insn, E_JALR_insn, E_BEQ_taken, E_BNE_taken, E_BLT_taken, E_BGE_taken, E_BLTU_taken, E_BGEU_taken);
    assign E_PC_target = E_PC_adder_out;
    assign E_PC_adder_in_A = (E_B_insn) ? E_B_immed :
                                (E_JAL_insn) ? E_J_immed:
                                (E_UI_insn) ? E_U_immed:
                                E_I_immed;
    assign E_PC_adder_in_B = (E_JALR_insn) ? E_regfile_A_byp : 
                                (E_insn[6:0] == 7'b0110111) ? 32'd0: E_PC;

    assign E_PC_adder_out = E_PC_adder_in_A + E_PC_adder_in_B;

    assign E_ALU_o_selected = (E_insn[6:0] == 7'b1101111 | E_insn[6:0] == 7'b1100111) ? E_PC_plus : E_alu_out;

    assign bypassing_stall = (E_insn[6:0] == 7'b0000011) && ((ctrl_readRegA == E_insn[11:7]) || ((ctrl_readRegB == E_insn[11:7]) && (D_insn[6:0] != 7'b0100011 ))); 
    
    xm_latch xm_latch_a(
        .clock(clock),
        .reset(reset),
        .i_insn(E_insn),
        .i_ALU_O(E_ALU_o_selected),
        .i_regfile_B(E_regfile_B_byp),
        .o_insn(M_insn),
        .o_ALU_O(M_alu_out),
        .o_regfile_B(M_regfile_B)
    );  

    //=======================================================================//
    //========================== MEMORY STAGE ===============================//
    //=======================================================================//

    //Latch output wires
    wire [31:0] W_insn, W_alu_o, W_mem_D;

    //Bypassing
    wire[31:0] M_regfile_B_byp;
    wire [4:0] M_rs2;
    assign M_rs2 = M_insn[24:20];
    wire M_W_M_byp;
    assign M_W_M_byp = (W_rd == M_insn[24:20] && ~W_insn_doesnt_write_rd && M_insn[24:20] != 5'd0);
    assign M_regfile_B_byp = (M_W_M_byp) ? W_write_data : M_regfile_B;
     
    // Dmem
    assign cpu_addr = {2'd0, M_alu_out[31:2]};
    assign cpu_write_data = M_regfile_B_byp;
    assign cpu_read_type = M_insn[14:12];
    assign cpu_write_en = M_insn[6:0] == 7'b0100011;

    //IO
    assign cpu_device_id = (M_insn[6:0] == 7'b0100011 && M_alu_out == 32'd2032) ? 1'b1 : 1'b0;

    mw_latch mw_latch_a(
        .clock(clock),
        .reset(reset),
        .i_insn(M_insn),
        .i_ALU_O(M_alu_out),
        .i_mem_D(cpu_read_data),
        .o_insn(W_insn),
        .o_ALU_O(W_alu_o),
        .o_mem_D(W_mem_D)
    );

    //=======================================================================//
    //======================== WRITEBACK STAGE ==============================//
    //=======================================================================//
    wire W_we;
    wire[31:0] W_write_data;
    wire[4:0] W_rd;
    assign W_write_data = (W_insn[6:0] == 7'b0000011) ? W_mem_D : W_alu_o;
    assign W_rd =  W_insn[11:7];
    assign W_we = (W_insn[4:0] == 5'b10011) ? 1'b1 :
                  (W_insn[6:0] == 7'b0000011) ? 1'b1 : 
                  (W_insn[6:0] == 7'b1101111) ? 1'b1 :
                  (W_insn[6:0] == 7'b1100111) ? 1'b1 : 1'b0;
	

	/* END CODE */

endmodule
