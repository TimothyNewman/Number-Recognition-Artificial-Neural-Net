.import ../argmax.s
.import ../utils.s

.data
# v0: .word 3 -42 432 7 -5 6 5 -114 2 # MAKE CHANGES HERE
# v0: .word 5 0 10000000 -124378 4372890 10000000 # MAKE CHANGES HERE
v0: .word -1234 -1324 -234 0 -1 -1423 # MAKE CHANGES HERE

.text
main:
    # Load address of v0
    la s0 v0
    
    # Set length of v0
    # addi s1 x0 9 # MAKE CHANGES HERE
    addi s1 x0 6 # MAKE CHANGES HERE

    # Call argmax
    mv a0 s0
    mv a1 s1
    jal ra argmax

    # Print the output of argmax
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit program
    jal exit
