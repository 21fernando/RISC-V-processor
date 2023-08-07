addi sp, x0, 2000 #Initialize stack pointer to 2000
addi a0, x0, 100 # Set the pixel address to 100
addi a1, x0, 1 # Set the color to 1
jal ra, set_pixel
addi x5, x0, 10
addi x5, x5, 10
addi x5, x5, 10

set_pixel:
    addi sp, sp, -8
    sw t0, -4(sp)
    sw t1, -8(sp)
    addi t0, zero, 1 #Set write enable
    slli t0, t0, 8 
    add t0, t0, a1 #Set color
    slli t0, a1, 15 #shift pixel color clearing lower 15 bits
    add t0, t0, a0 #Set address
    sw t0, 1000(zero) #put the command at memory address 1000
    lw t0, -4(sp)
    lw t1, -8(sp)
    addi sp, sp, 8
    jr ra