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
nop 			# Load/Store Tests
sw x1, 4(x0) 		# mem[1] = r1 = 3
sw x2, 8(x0) 		# mem[2] = r2 = 21
sw x3, 12(x0) 		# mem[r1] = r3 = -1 (should be mem[3])
lw x16, 4(x0) 	# r16 = mem[1] = 3
lw x17, 8(x0) 	# r17 = mem[2] = 21
lw x18, 12(x0) 	# r18 = mem[3] = -1