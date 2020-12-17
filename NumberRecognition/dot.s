.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
	
	addi sp, sp -8
    sw s10, 0(sp)
    sw s11, 4(sp)
    # Prologue
    
    add t0, x0, x0      # t0 is a counter
    add t1, x0, x0      # t1 is the dot product sum
    slli a3, a3, 2      # set a3 * 4
    slli a4, a4, 2      # set a4 * 4

loop_start:   
	beq t0, a2, loop_end    # if array size reached, go to loop_end
	
	mul s10, t0, a3     # mult v0 index by stride
	add t2, a0, s10     # set t2 to address of v0[t1]
	lw t4, 0(t2)        # load v0[t1] into t4
	
	mul s11, t0, a4     # mult v1 index by stride
	add t3, a1, s11     # set t3 to address of v1[t1]
	lw t5, 0(t3)        # load v1[t1] into t5

	# calculating the dot product and restoring values
	mul t6, t4, t5      # multiply v0[t1] * v1[t1]
	add t1, t1, t6      # add to ongoing dot product sum
	sw t4, 0(t2)        # store v0[t1] back into t4
	sw t5, 0(t3)        # store v1[t1] back into t5

	# increment PC and recurse
	addi t0, t0, 1      # incrementing the pointer counter
	j loop_start        # recurse to loop_start

loop_end:
	add a0, t1, x0      # set a0 = ongoing dot product sum = t1
	
    # Epilogue
    lw s10, 0(sp)
    lw s11, 4(sp)
    addi sp, sp 8

	ret
