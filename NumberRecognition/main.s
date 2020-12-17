.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args\
    addi t1 x0, 5
    bne a0 t1 wrong_num_args  #this is at the bottom of this main file

	# =====================================
    # LOAD MATRICES
    # =====================================

    lw s0, 4(a1) #store M0_PATH to saved register
    lw s1, 8(a1) #store M1_PATH to saved register
    lw s2, 12(a1) #store INPUT_PATH to saved register
    lw s3, 16(a1) #store OUTPUT_PATH to saved register

    # Load pretrained m0
    mv a0, s0     #set a0 to pointer to string MOPath
    addi sp, sp, -4
    # add t2, x0, x0
    # sw t2, 0(sp)
    mv a1, sp     #set a1 to pointer to integer, will be set to num rows
    addi sp, sp, -4
    # sw t2, 0(sp)
    mv a2, sp     #set a2 to pointer to integer, will be set to num cols
    jal ra read_matrix #open file to load matrix
    # blt a0, x0, eof_or_error #error if file cannot be opened
    mv s4, a0 #save pointer to matrix M0 into saved register


    # Load pretrained m1
    mv a0, s1     #set a0 to pointer to string M1Path
    addi sp, sp, -4
    mv a1, sp     #set a1 to pointer to integer, will be set to num rows
    addi sp, sp, -4
    mv a2, sp     #set a2 to pointer to integer, will be set to num cols
    jal ra read_matrix #open file to load matrix
    mv s5, a0 #save pointer to matrix M1 into saved register


    # Load input matrix
    mv a0, s2     #set a0 to pointer to string InputPath
    addi sp, sp, -4
    mv a1, sp     #set a1 to pointer to integer, will be set to num rows
    addi sp, sp, -4
    mv a2, sp     #set a2 to pointer to integer, will be set to num cols
    jal ra read_matrix #open file to load matrix
    mv s6, a0 #save pointer to matrix INPUT into saved register

    

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # malloc space for s7, my temp result matrix
    lw t2, 20(sp)
    lw t3, 0(sp)
    mul t4, t2, t3    # num elements in s7 matrix
    slli t5, t4, 2    # num bytes for elements in s7 matrix
    mv a0, t5
    jal ra malloc
    mv s7, a0         # set pointer to space for my temp result matrix
    

    # run matmul for hidden layer
#   a0 is the pointer to the start of m0
#   a1 is the # of rows (height) of m0
#   a2 is the # of columns (width) of m0
#   a3 is the pointer to the start of m1
#   a4 is the # of rows (height) of m1
#   a5 is the # of columns (width) of m1
#   a6 is the pointer to the the start of d
    mv a0, s4   #set pointer to M0 
    lw a1, 20(sp)
    lw a2, 16(sp)
    mv a3, s6   #set pointer to INPUT 
    lw a4, 4(sp)
    lw a5, 0(sp)
    mv a6, s7   #set pointer to temp result matrix 
    jal ra matmul

    # run relu
#   a0 is the pointer to the array
#   a1 is the # of elements in the array
    lw t2, 20(sp)
    lw t3, 0(sp)
    mul t4, t2, t3    # num elements in s7 matrix
    mv a0, s7   #set pointer to temp result matrix from previous matmul call
    mv a1, t4
    jal ra relu

    # malloc space for s8, my final temp result matrix
    lw t2, 12(sp)
    lw t3, 0(sp)
    mul t4, t2, t3    # num elements in s7 matrix
    slli t5, t4, 2    # num bytes for elements in s7 matrix
    mv a0, t5
    jal ra malloc
    mv s8, a0         # set pointer to space for my temp result matrix

    # run matmul again to calculate scores
#   a0 is the pointer to the start of m0
#   a1 is the # of rows (height) of m0
#   a2 is the # of columns (width) of m0
#   a3 is the pointer to the start of m1
#   a4 is the # of rows (height) of m1
#   a5 is the # of columns (width) of m1
#   a6 is the pointer to the the start of d
    mv a0, s5   #set pointer to M1
    lw a1, 12(sp)
    lw a2, 8(sp)
    mv a3, s7   #set pointer to Relu(hidden layer)
    lw a4, 20(sp)
    lw a5, 0(sp)
    mv a6, s8   #set pointer to another matrix, having malloc-ed more space
    jal ra matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    mv a0, s3            # set to pointer to output filename
    mv a1, s8            # set to pointer to start of the matrix in memory
    lw a2, 12(sp)         # set to number of rows in the matrix
    lw a3, 0(sp)        # set to number of cols in the matrix
    jal ra write_matrix

    addi sp, sp, 24
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns


    mv a0, s3            # set to pointer to output filename
    addi sp, sp, -4
    mv a1, sp         # set to pointer to an integer, we will set it to the number of rows
    addi sp, sp, -4
    mv a2, sp         # set to pointer to an integer, we will set it to the number of cols
    jal ra read_matrix
    # mv s8, a0            # store this matrix into memory

#   a0 is the pointer to the start of the vector
#   a1 is the # of elements in the vector
    # mv a0, s8       # set pointer to start of the vector, a0 is already set to the pointer to matrix
    lw t2, 4(sp)
    lw t3, 0(sp)
    mul t4, t2, t3  
    mv a1, t4       # set to # of elements in the vector
    jal ra argmax
    # mv s9, a0

    # Print classification
    # Printing integer result------------------
    mv a1 a0
    jal ra print_int

    addi sp, sp, 8    #reset stack pointer to beginning 

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

# exit w exit code 3
wrong_num_args:
    li a1 3
    jal exit2
