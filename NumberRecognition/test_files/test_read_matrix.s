.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory

    la s0, file_path #a0 is the pointer to string representing the filename
    
    jal ra malloc
    mv a1, a0 #a1 is a pointer to an integer, we will set it to the number of rows
    jal ra malloc
    mv a2, a0 #a2 is a pointer to an integer, we will set it to the number of columns


    mv a0, s0 #set a0 back to file path
    jal ra read_matrix

    # Print out elements of matrix


    lw a1, 0(a1)
    lw a2, 0(a2)
    jal ra print_int_array


    # Terminate the program
    addi a0, x0, 10
    ecall
