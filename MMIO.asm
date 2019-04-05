	.data
	
str1:	.asciiz "\nStart entering characters in the MMIO Simulator"
Welcome:	.asciiz "Word Count\nEnter the text segment:\n"
Word:		.asciiz "Enter the search word: \n"
Option:		.asciiz "Press 'e' to enter another segment of text or 'q' to quit.\n"
text:		.space 600
searchword:	.space 600
times:		.space 10
output1:		.asciiz "\nThe word '"
output2:		.asciiz "' occurred "
output3:		.asciiz " time(s).\n"

	.text 
	


	li $v0, 4		# single print statement	
	la $a0, str1
	syscall
	
main:		# reading and writing using MMIO
	la $a0,text
	jal Read
	
	la $a0,text
	jal Write
	
	la $a0,searchword
	jal Read
	
	la $a0,searchword 
	jal Write

	j Read2
	
Exit: 	li $v0,10
	syscall


Read:  	lui $t0, 0xffff 	#ffff0000
Loop1:	lw $t1, 0($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop1
	
	lw $t2, 4($t0) 		#data	
	beq $t2,10,End
	sb $t2,($a0)
	addi $a0,$a0,1
	j Loop1
	jr $ra

Write:  lui $t0, 0xffff 	#ffff0000
Loop2: 	lw $t1, 8($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop2
	lb $t2,($a0)
	beq $t2,0,End
	sw $t2, 12($t0) 	#data	
	addi $a0,$a0,1
	j Loop2
	
Read2:  	
	lui $t0, 0xffff 	#ffff0000
Loop3:	
	lw $t1, 0($t0) 		#control
	andi $t1,$t1,0x0001
	beq $t1,$zero,Loop3
	lw $t2, 4($t0) 		#data	
	beq $t2,113,Exit
	beq $t2,101,restart1
	j Loop3
	
restart1:
	li $t0,0
	la $t1,text
	la $t2,searchword
reloop1:	
	lb $t3,($t1)
	beq $t3,0,restart2
	sb $t0,($t1)
	addi $t1,$t1,1
	j reloop1
	
restart2:
	lb $t4,($t2)
	beq $t4,0,main
	sb $t0,($t2)
	addi $t2,$t2,1
	j restart2
	


End:
	jr $ra
