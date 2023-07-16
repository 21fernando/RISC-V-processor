nop             # Values initialized using addi (positive only)
nop             # Author: Oliver Rodas
nop
nop
nop             # Bypassing from lw to sw (M->X)
addi x1, x0, 830        # r1 = 830
nop            # Avoid RAW hazard to test only lw/sw
nop            # Avoid RAW hazard to test only lw/sw
sw x1, 8(x0)         # mem[2] = r1 = 830
nop            # Avoid RAW hazard to test only lw/sw
nop            # Avoid RAW hazard to test only lw/sw
lw x2, 8(x0)         # r2 = mem[2] = 830
sw x2, 16(x0)         # mem[3] = r2 = 830        (M->X)
lw x3, 16(x0)         # r3 = mem[3] = 830