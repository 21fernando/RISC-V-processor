nop 	# simple blt test case
nop 
nop 
nop
nop
nop
addi    x1, x0, 4     # x1 = 4
addi    x2, x0, 5     # x2 = 5
nop
nop
sub     x3, x0, x1   # x3 = -4
sub     x4, x0, x2   # x4 = -5
nop
nop
nop 	
blt 	x1, x2, b3	# 1 < 2 --> taken
nop			# flushed instuction
nop			# flushed instuction
addi 	x20, x20, 1	# 20 += 1 (Incoect)
addi 	x20, x20, 1	# 20 += 1 (Incoect)
addi 	x20, x20, 1	# 20 += 1 (Incoect)
b3: 
addi x10, x10, 1	# 10 += 1 (Coect)
blt x2, x2, b4	# 2 == 2 --> not taken
nop			# nop in case of flush
nop			# nop in case of flush
nop			# Space 
addi x10, x10, 1	# 10 += 1 (Coect) 
b4: 			
nop			
blt x4, x1, b5	# 4 < 1 --> taken
nop			# flushed instuction
nop			# flushed instuction
addi x20, x20, 1	# 20 += 1 (Incoect)
addi x20, x20, 1	# 20 += 1 (Incoect)
addi x20, x20, 1	# 20 += 1 (Incoect)
b5: 
addi x10, x10, 1	# 10 += 1 (Coect)
blt x2, x1, b6	# 2 > 1 --> not taken
nop			# nop in case of flush
nop			# nop in case of flush
nop			# Space
addi x10, x10, 1	# 10 += 1 (Coect) 
b6: 
nop			
blt x4, x3, b7	# 4 < 3 --> taken
nop			# flushed instuction
nop			# flushed instuction
addi x20, x20, 1	# 20 += 1 (Incoect)
addi x20, x20, 1	# 20 += 1 (Incoect)
addi x20, x20, 1	# 20 += 1 (Incoect)
b7: 
addi x10, x10, 1	# 10 += 1 (Coect)
blt x3, x4, b8	# 3 > 4 --> not taken
nop			# nop in case of flush
nop			# nop in case of flush
nop			# Space
addi x10, x10, 1	# 10 += 1 (Coect) 
b8: 
nop			# Landing pad fo banch
nop			# Avoid add AW hazad
nop			
# Final: x10 should be 6, x20 should be 0