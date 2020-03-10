#Maximillian Marciel
#3/27/19
#This program performs multiplication on two signed numbers using booth's algorithm.

.globl main # your program starts with a main, just like main func in C/C++/Java

main:
    #s0 is HI, s1 is LO
    #s4 is result, s5 is overflow flag.
    
    #a0 = multiplier, a1 = multiplicand.
    addi $a0, $zero, 5
    addi $a1, $zero, -1
    jal doProduct
    add $s4, $v0, $zero
    add $s5, $v1, $zero
    j Exit

    
doProduct:
    #s0 is HI, s1 is LO
    #s4 is result, s5 is overflow flag.
    #6 x 3 = 12, Multiplier x Multiplicand = Product
    #a0 is multiplier, a1 is multiplicand. a0 x a1 = result

    addi $sp, $sp, -20
    sw $t0, 0($sp)      #PUSH T0-T2
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    
    add $s0, $zero, $zero #load ZERO into the HI register to begin with. S0 IS HI!
    add $s1, $a1, $zero #Load the multiplicand into the LO register.
    add $t0, $zero, $zero #T0 is the iteration count. Runs 31 times. Starts at zero.
    add $t3, $zero, $zero #T3 is the right bit of booth's algorithm.
    
Iterate:
    addi $t1, $zero, 1 #Load 1 into t1 for comparisons
    andi $t2, $s1, 1 #Get LSB from LO and put into T2.
    sll  $t2, $t2, 1 #Shift T2 by 1 to the left to make room for the extra bit.
    or   $t2, $t2, $t3 #Combine: Put T3 into T2's LSB.
    
    #IF t2 = 01, do add. If T2 = 10, do sub. Else, only shift.
    beq $t1, $t2, doAdd #if t1 = 01
    addi $t1, $zero, 2 #load 10 (2) into t1 for comparisons
    beq $t1, $t2, doSub #if t2 = 10
    j doShift #else, do shift.
    
    
doAdd:
    #addi $t1, $zero, 30 #load 30 to t1 to check if t0 has run 30 times (on last iteration)
    #beq  $t0, $t1, doSub #if it is last iteration, do a subtraction instead. else, add.
    add $s0, $s0, $a0   #add the multiplier to the HI register. HI = HI + Multiplier
    j doShift
    
doSub:
    sub $s0, $s0, $a0 #sub the multiplayer from the HI register. HI = HI - Multiplier
    j doShift
    
doShift:
    andi $t2, $s0, 1 #Get the LSB from the HI register.
    andi $t4, $s1, 1 #Get the LSB from the LO register.
    sll $t2, $t2, 31 #Turn the LSB into an MSB.
    sra $s0, $s0, 1 #Shift HI by one.
    srl $s1, $s1, 1 #Shift LO by one.
    or  $s1, $s1, $t2 #add the new MSB into the LO register.
    
    #Load the old LSB of the LO register into t3.
    add $t3, $t4, $zero
    
    j continue
    
continue:
    addi $t0, $t0, 1 #ITERATE T0
    addi $t1, $zero, 31 #load 31 to t1 to check if t0 has run 31 times.
    beq $t0, $t1, exitDoProduct
    j Iterate #else, iterate again
    
exitDoProduct:
    sra $s1, $s1, 2 #???
    add $v0, $zero, $s1 #put result into v0
    srl  $t2, $s1, 31 #extract MSB of LO
    andi $t1, $s0, 1  #extract LSB of HI
    beq $t1, $t2, noOverflow #if they are equal there is no overflow, else there is overflow.
overflow:
    addi $v1, $zero, 1
    j finalExit
noOverflow:
    add $v1, $zero, $zero
    j finalExit
    
finalExit:
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $t2, 8($sp)      #POP T0-T2
    lw $t1, 12($sp)
    lw $t0, 16($sp)
    
    addi $sp, $sp, 20
    
    jr $ra

Exit:
    ori $v0, $zero, 10 # you need these two lines as the end of your program
    syscall