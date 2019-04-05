#studentName:
#studentID:

# This MIPS program should sort a set of numbers using the quicksort algorithm
# The program should use MMIO

.data
#any any data you need be after this line 
.align 4
prompt1:	.asciiz "Welcome to QuickSort\n"
prompt2:	.asciiz "The sorted array is: "
prompt3:	.asciiz "\nThe array is re-initialized.\n"
inputascii:		.space 2048
outputascii:	.space 2048
.align 4
intarray:	.space 2048

	.text
	.globl main

main:	# all subroutines you create must come below "main"
	la $a0,prompt1
	jal Write
	
mainloop:
	la $s1,inputascii
	j Read
	
	
	
	
Write:
	lui $t0, 0xffff 	#ffff0000
Loop: 	lw $t1, 8($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop
	lb $t2,($a0)
	beq $t2,0,End
	sw $t2, 12($t0) 	#data	
	addi $a0,$a0,1
	j Loop
	
Read:
	lui $t0, 0xffff 	#ffff0000
Loop1:	lw $t1, 0($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop1
	
	lw $t2, 4($t0) 		#data	
	beq $t2,99,clear
	beq $t2,115,sort	#only need to conver to ints when needing to sort
	beq $t2,113,Exit
	sb $t2,($s1)
	addi $s1,$s1,1
	j Loop1

clear:
	#we need to clear intarray,inputascii,outputascii
	#for intarray, we find the -1 at the end
	#for ascii arrays we find the null terminator
	
	la $a0,inputascii
	jal Write
	
	
	li $t0,0
	sb $t0,($s1)		#add a null terminator at the end of inputascii
	la $s2,inputascii
	la $s3,outputascii
	la $s4,intarray
	
	li $t1,-1
	sw $t1,($s4)

lp1:	lb $t1,($s2)
	beq $t1,0,lp2
	sb $t0,($s2)
	addi $s2,$s2,1
	j lp1
	
lp2:	lb $t1,($s3)
	beq $t1,0,lp3
	sb $t1,($s3)
	addi $s3,$s3,1
	j lp2
	
lp3:	lw $t1,($s4)
	beq $t1,-1,reinit
	sw $t1,($s4)
	addi $s4,$s4,4
	j lp3
	
reinit:
	la $a0,prompt3
	jal Write
	j mainloop
sort:
	la $a0,inputascii	#display the input
	jal Write		
	
	
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
	
End:	jr $ra
	
Exit:	li $v0,10
	syscall
