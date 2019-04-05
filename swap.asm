.data
#any any data you need be after this line 
.align 4
intarray:		.space 2048


	.text
	.globl main

main:	# all subroutines you create must come below "main"
	la $s0,intarray
Load:
	li $t0,13
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,8
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,7
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,13
	sw $t0,($s0)
	addi $s0,$s0,4
	
	li $t0,-1
	sw $t0,($s0)
	
	
	
	li $a1,0
	addi $a2,$0,3
	


	la $a0,intarray
	jal quicksort
	
	
	
	
print:
	la $t0,intarray
	
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
	
swap:	
	li $t9,4
	mul $a1,$a1,$t9
	mul $a2,$a2,$t9
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
	
partition:
	addi $sp,$sp,-4
	sw $ra,($sp)
	addi $t2,$a1,0		#low
	addi $t3,$t2,0		#p_pos=low
	addi $t5,$a2,0		#high
	


	la $s2,($a0)
	

	mul $t9,$t3,4
	add $s2,$s2,$t9
	lw $t4,($s2)		#pivot
	sub $s2,$s2,$t9
	
	addi $s3,$t2,1		#index i=low+1
	


	
loop1:	
	
	#addi $a0,$s3,0
	#li $v0,1
	#syscall
	#li $v0,11
	#li $a0,' '
	#syscall 
	
	
	bgt $s3,$t5,endloop1
	mul $t9,$s3,4
	add $s2,$s2,$t9
	lw $t6,($s2)		#get a[i]
	

	
	sub $s2,$s2,$t9
	blt $t6,$t4,less
	addi $s3,$s3,1
	j loop1
less:
	addi $t3,$t3,1
	la $a0,intarray
	addi $a1,$t3,0
	addi $a2,$s3,0
	jal swap
	addi $s3,$s3,1
	j loop1
	
endloop1:
	la $a0,intarray
	addi $a1,$t2,0
	addi $a2,$t3,0
	jal swap
	
	addi $v0,$t3,0
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra

quicksort:
	#save the registers
	addi $sp,$sp,-4
	sw $ra,($sp)
	move $s4,$a1		#low
	move $s5,$a2		#high
	

base:	blt $s4,$s5,recurse
	jr $ra
	
recurse:
	jal partition
	addi $s6,$v0,0
	
	addi $a1,$s4,0
	addi $a2,$s6,-1
	jal quicksort
	
	addi $a1,$s6,1
	addi $a2,$s5,0
	jal quicksort
	
	lw $ra,($sp)
	addi $sp,$sp,4
	jr $ra
	
	
	