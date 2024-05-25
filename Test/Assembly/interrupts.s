j main
jal ih_1
jal ih_2
jal ih_3
jal ih_4
jal ih_5

main:
addi x2, x2, 100
j main

ih_1: 
addi x2, x2, 1
jr ra

ih_2: 
addi x2, x2, 2
jr ra

ih_3: 
addi x2, x2, 3
jr ra

ih_4: 
addi x2, x2, 4
jr ra

ih_5: 
addi x2, x2, 5
jr ra
