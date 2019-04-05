.data
#any any data you need be after this line 
.align 4
buffer:		.space 2048


	.text
	.globl main
	
main:	# all subroutines you create must come below "main"
	la $s0,buffer
Load:
	li $t0,9
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,8
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,13
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,11
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,-1
	sw $t0,($s0)
	

	jal test

	
print:
	la $t0,buffer
	
Loop:	lw $s1,($t0)
	beq $s1,-1,End
	li $v0,1
	move $a0,$s1
	syscall
	li $v0,11
	li $a0,' '
	syscall
	addi $t0,$t0,4
	j Loop
End:
	li $v0,10
	syscall
	
test:
	addi $sp,$sp,4
	sw $ra,($sp)
	la $a0,buffer
	li $a1,0
	li $a2,2
	jal swap
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
	
swap:	mul $a1,$a1,4
	mul $a2,$a2,4
	add $a0,$a0,$a1
	lw $t0,($a0)
	sub $a0,$a0,$a1
	add $a0,$a0,$a2
	lw $t1,($a0)
	sw $t0,($a0)
	sub $a0,$a0,$a2
	add $a0,$a0,$a1
	sw $t1,($a0)
	jr $ra
	
Exit:
	li $v0,10
	syscall