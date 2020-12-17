.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    add t0, x0, x0      # t0 is a counter

loop_start:   
	beq t0, a1, loop_end    # if array size reached, go to loop_end
	slli t2, t0, 2      # set t2 = t0 * 4
	add t3, a0, t2      # set t3 to address of arr[t2]
	lw t1, 0(t3)        # load arr[t2] into t1
	bge t1, x0, loop_continue  # if elt >= 0, skip to next elt

	#change neg value to 0
	add t1, x0, x0            # set t1 = 0
	sw t1, 0(t3)              # change elt at index to value 0 
    j loop_continue    

loop_continue:    # incrementing the pointer counter and recurse
	addi t0, t0, 1
	j loop_start        # recurse to loop_start

loop_end:
    # Epilogue
	ret
