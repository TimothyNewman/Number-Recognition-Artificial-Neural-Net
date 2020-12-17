.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul: 
	# list of counters: 
	# s7 is counter for elts in d
    # s8 is counter for rows of m0
    # s9 is counter for columns of m1

	# Error if mismatched dimensions
    bne a2 a4 mismatched_dimensions

    # Prologue
    # save values of a0-a6 to avoid changing these arg params
    addi sp, sp, -44
    sw ra, 0(sp)   # save my registers in test_matmul, so I can use the saved registers s0-s6 and ra
	sw s0, 4(sp)
	sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

    mv s0, a0      # now I can store my args into saved registers
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6

    add s7, x0, x0   # s7 is a counter for elts in d
    add s8, x0, x0   # s8 is a counter for rows of m0

outer_loop_start:                # fill output d matrix by incrementing rows of m0
	beq s8, s1, outer_loop_end   # if array size reached (aka last row of m0), go to loop_end
	add s9, x0, x0               # s9 is a counter for columns of m1
    j inner_loop_start           # call inner_loop to loop on columns of m1

inner_loop_start:  
	beq s9, s5, inner_loop_end   # if columns all seen, iterate to next row

	slli t3, s8, 2      # keep the same row
	mul t6, t3, s2
	add t0, s0, t6      # set t0 to address of m0, row s8

	slli t3, s9, 2      # increment the column
	add t1, s3, t3      # set t1 to address of m1, col s9

	mv a0, t0  #set pointer to m0[row i]
	mv a1, t1  #set pointer to m1[col i]
	mv a2, s2  #length of vector is length of rows of m0
	li a3, 1   #stride of m0 is 1; go by all elts in the row
	mv a4, s5  #stride of m1 is s5; go by all elts in the col
	jal ra dot

 #	  # Print integer result------------------
 #    mv a1 a0
 #    jal ra print_int
 #    #_____________________________________


	slli t3, s7, 2      # set t3 = s7 * 4
	add t4, s6, t3      # set t4 to address of d[t3]
	sw a0, 0(t4)        # load value into d, aka fill the output matrix!

	addi s7, s7, 1      # incrementing d's pointer counter
	addi s9, s9, 1      # incrementing m1's pointer counter

	j inner_loop_start


inner_loop_end:
    # increment PC and recurse
	addi s8, s8, 1         # incrementing m0's pointer counter
	j outer_loop_start     # recurse to outer_loop_start

outer_loop_end:

    # Epilogue
    lw ra, 0(sp)   # load my registers back for use in test_matmul
	lw s0, 4(sp)
	lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44

    ret

mismatched_dimensions:
    li s1 2
    jal exit2
