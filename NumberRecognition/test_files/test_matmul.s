.import ../matmul.s
.import ../utils.s
.import ../dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0 m0
    la s1 m1
    la s2 d
    
    addi s3, x0, 3 #num rows (height) of s0
    addi s4, x0, 3 #num columns (width) of s0
    addi s5, x0, 3 #num rows (height) of s1
    addi s6, x0, 3 #num columns (width) of s1

    # Call matrix multiply, m0 * m1  
    mv a0, s0 #store pointer to start of m0
    mv a3, s1 #store pointer to start of m1
    mv a6, s2 #store pointer to start of d
    mv a1, s3 #store rows of s0
    mv a2, s4 #store columns of s0
    mv a4, s5 #store rows of s1
    mv a5, s6 #store columns of s1
    jal ra matmul

    # Print the output (use print_int_array in utils.s)
    mv a0, s2
    mv a1, s3
    mv a2, s6
    jal ra print_int_array

    # Exit the program
    jal exit
