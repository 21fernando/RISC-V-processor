nop             # Values initialized using addi (positive only)
nop             # Author: Oliver Rodas
nop
nop
nop             # EDGE CASE: Stalling 1 cycle for lw to ALUop
addi x1, x0, 830        # r1 = 830
nop            # Avoid RAW hazard to test only lw/sw
nop            # Avoid RAW hazard to test only lw/sw
sw x1, 4(x0)         # mem[2] = r1 = 830
lw x4, 4(x0)         # r4 = mem[2] = 830
addi x5, x4, 12        # r5 = r4 + 12 = 842    (M->D) 1 cycle stall required