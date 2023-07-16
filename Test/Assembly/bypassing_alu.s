nop             # Values initialized using addi (positive only)
nop             # Author: Oliver Rodas
nop
nop
nop             # Basic Bypassing to ALU: X->D and M->D
addi x1, x0, 80        # r1 = 80
addi x2, x1, 22        # r2 = r1 + 22 = 102    (X->D)
addi x3, x1, 37        # r3 = r1 + 37 = 117    (M->D)
sub x4, x1, x3        # r4 = r1 - r3 = -37    (X->D)
and x5, x1, x3        # r5 = r1 & r3 = 80    (M->D)
srai x6, x4, 4         # r6 = r4 >> 4 = -3        (M->D)
slli x7, x6, 5         # r7 = r6 << 5 = -96    (X->D)