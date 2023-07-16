nop
nop 	
nop
nop	
nop
addi x1, x0, 5		# r1 = 5
b1: 
addi x2, x2, 1		# r2 += 1
blt x2, x1, b1		# if r2 < r1 take branch (5 times)
b2: 
addi x1, x1, 1		# r1 += 1 ==> 6, 7, 8, 9, 10 
addi x3, x3, 2		# r3 += 2 ==> 2, 4, 6, 8, 10
blt x3, x1, b2		# if r3 < r1 take branch (4 times)
add x10, x2, x3		# r10 = r2 + r3 ==> r2 = rs A , r3 = rt B
nop
nop
nop
nop
# Final: x10 should be 15