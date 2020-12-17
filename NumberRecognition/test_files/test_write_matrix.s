.import ../write_matrix.s
.import ../utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 # MAKE CHANGES HERE
file_path: .asciiz "test_output.bin"

.text
main:
    # Write the matrix to a file

    la s0, file_path #pointer to string representing the filename
    la s1, m0 #the pointer to the start of the matrix in memory
    
    addi a2, x0, 3 #a2 is the number of rows in the matrix
    addi a3, x0, 3 #a3 is the number of columns in the matrix
    
    mv a0, s0 #move pointer to string representing filename to a0
    mv a1, s1 #move pointer to start of matrix in memory

    jal ra write_matrix

    # Exit the program
    addi a0 x0 10
    ecall
