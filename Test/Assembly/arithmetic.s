nop 			# Basic Arithmetic Test with no Hazards
nop 			# Values initialized using addi (positive only) and sub
nop 			# Author: Oliver Rodas
nop
nop
nop 			# Initialize Values
addi x3, x0, 1	# r3 = 1
addi x4, x0, 35	# r4 = 35
addi x1, x0, 3	# r1 = 3
addi x2, x0, 21	# r2 = 21
sub x3, x0, x3	# r3 = -1
sub x4, x0, x4	# r4 = -35
nop 
nop 			# Positive Value Tests
add x5, x2, x1	# r5 = r2 + r1 = 24
sub x6, x2, x1	# r6 = r2 - r1 = 18
and x7, x2, x1	# r7 = r2 & r1 = 1
or x8, x2, x1 	# r8 = r2 | r1 = 23
slli x9, x1, 4 	# r9 = r1 << 4 = 48
srai x10, x2, 2	# r10 = r2 >> 2 = 5
