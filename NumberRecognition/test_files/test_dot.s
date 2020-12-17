.import ../dot.s
.import ../utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    addi s2, x0, 9   # set length of vectors
    addi s3, x0, 1   # set stride of vector 0
    addi s4, x0, 1   # set stride of vector 1

    # Call dot function
    mv a0, s0    # store pointer to start of vector 0
    mv a1, s1    # store pointer to start of vector 0
    mv a2, s2    # store length of vectors
    mv a3, s3    # store stride of vector 0
    mv a4, s4    # store stride of vector 1
    jal ra dot

    # Print integer result
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit
    jal exit
