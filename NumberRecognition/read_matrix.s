.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    
    addi sp, sp, -40 #make room on stack
    sw ra, 0(sp)
    sw s0, 4(sp) #save space for pointer to filename
    sw s1, 8(sp) #save pointer for row int
    sw s2, 12(sp) #save pointer for column int
    sw s3, 16(sp) #save number for bytes to be read
    sw s4, 20(sp) #save for r*c
    sw s5, 24(sp) #save for r*c
    sw s6, 28(sp) #save for total number of bytes of file to read
    sw s7, 32(sp) # file descriptor
    sw s8, 36(sp) #matrix

    mv s0, a0 #store filename in saved register
    mv s1, a1 #store pointer of row integer to saved register
    mv s2, a2 #store pointer of column integer to saved register


    #open the file
    mv a1, s0 #set a1 to filename for fopen
    add a2, x0, x0 #set int val for read only permission    
    jal ra fopen #open file with read only permission
    blt a0, x0, eof_or_error #error if file cannot be opened
    mv s7, a0 #save file descriptor

    #grab row values
    addi s3, x0, 4 #num of bytes to read from file
    mv a3, s3 #set number of bytes to be read
    mv a2, s1 #set a2 to buffer for row int
    mv a1, s7 #set file descriptor
    jal ra fread #read the rows from the file
    bne a0, s3, eof_or_error #a0 != a3 then there is an error  
    
    #grab column values
    mv a1, s7 #set file descriptor
    mv a2, s2 #set a2 to buffer for column int
    mv a3, s3 # set a3 as num bytes
    jal ra fread #read the columns from the file
    bne a0, s3, eof_or_error #a0 != a3 then there is an error

    #read entire matrix
    lw s4, 0(s1) #load rows into s4
    lw s5, 0(s2) #load columns into s5
    mul s6, s4, s5 #total number of bytes to read from rest of file
    slli s6, s6, 2 # multiply total bytes by 4
    mv a0, s6 #move total bytes into a0 for malloc
    jal ra malloc # malloc the total number of bytes for the matrix
    
    mv s8, a0 #save malloced matrix
    mv a3, s6 #num of bytes to be read from file
    mv a1, s7 #change a1 to file descriptor
    mv a2, a0 #change a2 to pointer to the buffer that read bytes to
    jal ra fread #read all bytes from file
    bne a0, s6, eof_or_error #a0 != s6 error

    # Epilogue
    mv a1, s7 #change a0 back from file descriptor
    jal ra fclose #close the file
    blt a0, x0, eof_or_error #error if file can not close
    mv a1, s1
    mv a2, s2
    mv a0, s8

    #load my register back for use
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
    
    ret

eof_or_error:
    li a1 1
    jal exit2
    
