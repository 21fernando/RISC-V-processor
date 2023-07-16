nop
nop
nop
nop
nop
add x3, x0, x0
nop
nop
jal x1, j_c
j_a: 
addi x3, x3, 10
nop
nop
jal x1, end
nop
nop
nop
nop
j_b: 
addi x3, x3, 5
nop
nop
nop
nop
j_c: 
addi x3, x3, 2
jalr x1, x1, 0
nop
nop
nop
nop
end: 
add x3, x3, x3
nop
nop

