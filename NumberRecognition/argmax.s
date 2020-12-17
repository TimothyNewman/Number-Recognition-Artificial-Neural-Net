.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:
    # Prologue
    add t0, x0, x0    #t0 is a counter
    add t4, x0, x0    #t4 will store our best index (argmax)
    addi t5, x0, -2048    #t5 will store the value at our best index (max)

loop_start:
	beq t0, a1, loop_end    # if array size reached, go to loop_end
	slli t2, t0, 2      # set t2 = t0 * 4
	add t3, a0, t2      # set t3 to address of arr[t2]
	lw t1, 0(t3)        # load arr[t2] into t1
	blt t1, t5, loop_continue  # if value < max, continue
	beq t1, t5, loop_continue  # if value = max, continue

	#update t4 and t5 (argmax and max)
	add t4, x0, t0      # update argmax
	add t5, x0, t1      # update max
	sw t1, 0(t3)        # restore t1 back to arr[t2]
    j loop_continue 

loop_continue:   # incrementing the pointer counter and recurse
	addi t0, t0, 1
	j loop_start        # recurse to loop_start

loop_end:
    # Epilogue
    add a0, x0, t4   #set a0 equal to our best index (argmax)
    ret
