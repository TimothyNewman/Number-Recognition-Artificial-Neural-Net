.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -36 #make room on the stack
    sw ra, 0(sp)
    sw s0, 4(sp) #save space for pointer to the filename
    sw s1, 8(sp) #save space for row int
    sw s2, 12(sp) #save space for column int
    sw s9, 16(sp) #save space for pointer to the matrix in memory
    sw s7, 20(sp) #save space for file descriptor
    sw s3, 24(sp) #save space for number of bytes to write for R&C
    sw s8, 28(sp) #save space for size of 1 element
    # sw s4, 32(sp) #save space for calculating Row*Column
    # sw s5, 36(sp) #save space for calculating Row*Column
    sw s6, 32(sp) #save for total num of r*c to write
     

    mv s0, a0 #store filename in saved register
    mv s1, a2 #store pointer of row integer to saved register
    mv s2, a3 #store pointer of column integer to saved register
    mv s9, a1 #store pointer of start of matrix to saved register
    
    #open the file
    mv a1, s0 #set a1 to filename for fopen
    addi a2, x0, 1 #set int val for write permission
    jal ra fopen #open file with write permission
    blt a0, x0, eof_or_error #error if file cannot be opened
    mv s7, a0 #save file descriptor


    #write row value
    addi s3, x0, 4 #num of bytes to write from file for row
    addi s8, x0, 1 #num of elements to write to file for row
    
    addi sp, sp, -4
    sw s1, 0(sp) #save space for buffer for row int
    mv a4, s3 #set number of bytes for each buffer element
    mv a3, s8 #set a3 to num of elements to write
    mv a2, sp #pointer to buffer for row int, use sp
    mv a1, s7 #set file descriptor 
    jal ra fwrite
    bne a0, s8, eof_or_error #if a0 != a3 then error
    # addi sp, sp, 4

    #write column value
    # addi sp, sp, -4
    sw s2, 0(sp) #save space for buffer for col int
    mv a4, s3 #set number of bytes for each buffer element
    mv a3, s8 #set a3 to num of elements to write
    mv a2, sp #pointer to buffer for column int, use sp
    mv a1, s7 #set file descriptor
    jal ra fwrite
    bne a0, s8, eof_or_error #if a0 != a3 then error
    addi sp, sp, 4

    #write entire matrix
    # lw s4, 0(s1) #load rows into s4
    # lw s5, 0(s2) #load columns into s5
    mul s6, s1, s2 #total num of elements to write
    mv a1, s7 #set file descriptor for fwrite
    mv a2, s9 #set pointer to matrix in memory for fwrite
    mv a3, s6 #num of elements to write out of buffer for fwrite
    mv a4, s3 #size of each element in bytes
    jal ra fwrite
    bne a0, s6, eof_or_error #if a0 != a3 then error

    # Epilogue
    mv a1, s7 #set a1 back to file descriptor
    jal ra fclose
    blt a0, x0, eof_or_error #error if file can not close
    mv a0, s0
    mv a1, s9
    mv a2, s1
    mv a3, s2

    #load my registers back
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s9, 16(sp)
    lw s7, 20(sp)
    lw s3, 24(sp)
    lw s8, 28(sp)
    # lw s4, 32(sp)
    # lw s5, 36(sp)
    lw s6, 32(sp)
    addi sp, sp, 36

    ret

eof_or_error:
    li a1 1
    jal exit2
    
