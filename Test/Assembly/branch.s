nop
nop
nop
nop
nop
add x1, x0, x0
addi x2, x0, 2
addi x3, x0, 3
nop
nop
nop
blt x2, x3, blt_taken # taken
addi x1, x1, 1
blt_taken:
nop
nop
blt x3, x2, blt_not_taken # not taken
addi x1, x1, 1 # r1 = 1
blt_not_taken:
nop
nop
addi x4, x0, (-4)
addi x5, x0, (-6)
nop
nop
nop
bge x4, x5, bge_taken # taken
addi x1, x1, 2
bge_taken:
nop
nop
bge x5, x4, bge_not_taken # not taken
addi x1, x1, 2 # r1 = 3
bge_not_taken:
nop
nop
addi x3, x0, 2
nop
nop
nop
beq x2, x3, beq_taken # taken
addi x1, x1, 4
beq_taken:
nop
nop
beq x3, x5, beq_not_taken # not taken
addi x1, x1, 4 # r1 = 7
beq_not_taken:
nop
nop
nop
bne x3, x5, bne_taken # taken
addi x1, x1, 8
bne_taken:
nop
nop
bne x2, x3, bne_not_taken # not taken
addi x1, x1, 8 # r1 = 15
bne_not_taken:
nop
nop
nop
addi x2, x0, 5
addi x3, x0, (-1)
addi x5, x0, 4
nop
nop
nop
bltu x2, x3, bltu_taken # taken
addi x1, x1, 16
bltu_taken:
nop
nop
bltu x2, x5, bltu_not_taken # not taken
addi x1, x1, 16 # r1 = 31
bltu_not_taken:
nop
nop
nop
bgeu x3, x2, bgeu_taken # taken
addi x1, x1, 32
bgeu_taken:
nop
nop
bgeu x5, x3, bgeu_not_taken # not taken
addi x1, x1, 32 # r1 = 63
bgeu_not_taken:
nop
nop

