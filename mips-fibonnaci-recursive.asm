#Maximillian Marciel
#3/4/19
#This program shows the two different ways one can implement the fibonacci sequence-
#iteratively and recursively. Both results are stored in s0 and s1, and should be the same.

.globl main # your program starts with a main, just like main func in C/C++/Java

#--------------------------------------

main:
    addi $a0, $zero, 6
    add $v0, $zero, $zero #clear v0
    
    jal fibIterative
    add $s0, $v0, $zero #copy return value into a register
    jal fibRecursive
    add $s1, $v0, $zero #copy return value into a register
    j Exit
    
#--------------------------------------    
fibRecursive:
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    
    add $s0, $a0, $zero
    # if n == 1, return 1
    addi $v0, $zero, 1
    addi $t0, $zero, 2 # t0 is 2 (const)
    slt $t1, $t0, $s0
    beq $t1, $zero, recursiveExit
    addi $a0, $s0, -1
    jal fibRecursive
    
    add $s1, $v0, $zero
    addi $a0, $s0, -2
    jal fibRecursive
    
    add $v0, $s1, $v0 # add f(n-1)
    
recursiveExit:
    lw $ra, 8($sp)
    lw $s0, 4($sp)
    lw $s1, 0($sp)
    addi $sp, $sp, 12
    jr $ra

#--------------------------------------    

fibIterative:
    addi $sp, $sp, -4 #push t0
    sw $t0, 0($sp)
    addi $sp, $sp, -4 #push t1
    sw $t1, 0($sp)
    addi $sp, $sp, -4 #push t2
    sw $t2, 0($sp)
    addi $sp, $sp, -4 #push t3
    sw $t3, 0($sp)
    addi $sp, $sp, -4 #push t4
    sw $t4, 0($sp)
    addi $sp, $sp, -4 #push t5
    sw $t5, 0($sp)
    
    addi $t2, $zero, 1 #t2 is 1 (constant)
    add $t3, $zero, $zero # t3 = 0, x
    addi $t4, $zero, 1, #t4 = 1,    y
    add $t5, $zero, $zero #t5 = 0,  z
    add $t0, $zero, $zero #t0 is zero and the counter
    
LoopIterative:
    slt $t1, $t0, $a0
    bne $t1, $t2, ExitIterative
    #z = x + y, x = y, y = z;
    #t5 = t3, t3 = t4, t4 = t5
    add $t5, $t3, $t4
    add $t3, $t4, $zero
    add $t4, $t5, $zero
    addi $t0, $t0, 1
    j LoopIterative
    
ExitIterative:  
    add $v0, $t3, $zero
    lw $t5, 0($sp)    #pop t5
    addi $sp, $sp, 4 
    lw $t4, 0($sp)    #pop t4
    addi $sp, $sp, 4  
    lw $t3, 0($sp)    #pop t3
    addi $sp, $sp, 4
    lw $t2, 0($sp)    #pop t2
    addi $sp, $sp, 4
    lw $t1, 0($sp)    #pop t1
    addi $sp, $sp, 4
    lw $t0, 0($sp)    #pop t0
    addi $sp, $sp, 4
    
    jr $ra

#--------------------------------------    
    
Exit:
    ori $v0, $zero, 10 # you need these two lines as the end of your program
    syscall