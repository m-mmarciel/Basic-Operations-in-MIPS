#Maximillian Marciel
#4/5/19
#This program performs division on two numbers.

.globl main # your program starts with a main, just like main func in C/C++/Java

main:
    #s0 is HI, s1 is LO
    #s4 is result, s5 is overflow flag.
    
    #s0 = dividend, s1 = divisor.
    addi $s0, $zero, 5 #in this case we're doing 5 / 2
    addi $s1, $zero, 2
    #a0 = s0, a1 = s1.
    add $a0, $s0, $zero
    add $a1, $s1, $zero
    
    jal doDiv
    #Quotient is s4, remainder is s5.
    add $s4, $zero, $v0
    add $s5, $zero, $v1
    
    j Exit

    
doDiv:
    #a0 = dividend
    #a1 = divisor
    #s0 = HI
    #s1 = LO

    addi $sp, $sp, -20
    sw $t0, 0($sp)      #PUSH T0-T2, S0-S1
    sw $t1, 4($sp)
    sw $t2, 8($sp)
    sw $s0, 12($sp)
    sw $s1, 16($sp)
    
    #S0 is HI, S1 is LO (initially dividend, a0)
    add $s0, $zero, $zero
    add $s1, $zero, $a0
    
    #Shift both left logically once before we begin
    sll $s0, $s0, 1
    sll $s1, $s1, 1
    
    #T0 is the COUNTER
    add $t0, $zero, $zero
    #T1 is the RESTORE FLAG, which tells us if a restore happened or not. Set to zero initially on iteration.
    
Iterate:
    add  $t1, $zero, $zero      #reset the restore flag to 0
    sub  $s0, $s0, $a1          #HI = HI - DIVISOR
    srl  $t2, $s0, 31           #extract MSB of HI and put into T2.
    addi $t3, $zero, 1          #load 1 into T3 for comparison.
    beq  $t2, $t3, restore      #If MSB of HI is 1, then RESTORE
    j shift                     #else just shift left
    
restore:
    add $s0, $s0, $a1       #to restore, HI = HI + DIVISOR
    addi $t1, $zero, 1      #SET RESTORE FLAG TO 1
    j shift

shift:
    srl $t2, $s1, 31       #retrieve the MSB of LO
    sll $s0, $s0, 1        #shift the HI
    sll $s1, $s1, 1        #shift the LO
    or  $s0, $s0, $t2      #add MSB of LO (which is t2) to the HI (s0)
    beq $t1, $zero, addOne #if the restore flag is 0, then we shift in a 1 to LO. else, we do nothing.
    j continue
    
addOne:
    addi $s1, $s1, 1
    j continue
    
wrapUp:
    add $v0, $s1, $zero #QUOTIENT = LO REGISTER
    srl $s0, $s0, 1     #Shift the HI register right to gain the remainder back
    add $v1, $s0, $zero #REMAINDER = HI REGISTER
    j finalExit
    
continue:
    addi $t0, $t0, 1        #ITERATE COUNTER T0
    addi $t2, $zero, 32     #load 31 to t2 to check if t0 has run 31 times.
    beq $t0, $t2, wrapUp    #if counter = 31, wrap up
    j Iterate               #else, iterate again

finalExit:
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)      #POP T0-T2, S0-S1
    lw $s0, 12($sp)
    lw $s1, 16($sp)
    
    addi $sp, $sp, 20
    
    jr $ra

Exit:
    ori $v0, $zero, 10 # you need these two lines as the end of your program
    syscall