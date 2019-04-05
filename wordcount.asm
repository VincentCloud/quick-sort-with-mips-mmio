#studentName:
#studentID:

# This MIPS program should count the occurence of a word in a text block using MMIO

.data
#any any data you need be after this line 
Welcome:	.asciiz "Word Count\nEnter the text segment:\n"
Word:		.asciiz "Enter the search word: \n"
Option:		.asciiz "Press 'e' to enter another segment of text or 'q' to quit.\n"
text:		.space 600
searchword:	.space 600
times:		.space 100
output1:		.asciiz "\nThe word '"
output2:		.asciiz "' occurred "
output3:		.asciiz " time(s).\n"
debug:			.asciiz "Here"

	.text
	.globl main

main:	# all subroutines you create must come below "main"		# reading and writing using MMIO
	la $a0,Welcome
	jal Write
	
	la $a0,text
	jal Read
	
	la $a0,Word
	jal Write
	
	la $a0,searchword
	jal Read
	
	la $a0,text
	la $a1,searchword
	jal count
	
	addi $a0,$v0,0
	la $a1,times
	jal num
	
	la $a0,output1
	jal Write
	
	la $a0,searchword
	jal Write
	
	la $a0,output2
	jal Write
	
	la $a0,times
	jal Write
	
	la $a0,output3
	jal Write
	
	la $a0,Option
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

	



	#subroutine for search and count the number of occurrence 
count:
	li $s0,0
	la $t0,($a0)
	la $t1,($a1)
	
reset:
	la $t1,($a1)
	
Lp:
	lb $t2,($t0)
	beq $t2,32,space		#if there is a space check the corresponding position of the pointer to the word
	beq $t2,$0,last			#if reaching the last word, chekc if the last word is the same as the searched word
	
	lb $t3,($t1)
	bne $t2,$t3,nextword		#if not equal skip to the next word
	addi $t0,$t0,1
	addi $t1,$t1,1
	j Lp
	
last:
	lb $t3,($t1)			#if we reach the last word, check if the last word 
	bne $t3,$0,endcount		#is a searched word. If so, add it to the counter
	addi $s0,$s0,1
	j endcount
	
Add:
	addi $s0,$s0,1
	addi $t0,$t0,1
	j reset
	
space:
	lb $t3,($t1)
	beq $t3,0,Add
	addi $t0,$t0,1
	j reset
	
nextword:
	addi $t0,$t0,1
	lb $t2,($t0)
	beq $t2,$0,endcount
	beq $t2,32,next
	j nextword
next:
	addi $t0,$t0,1
	j reset
	
endcount:
	addi $v0,$s0,0
	jr $ra
	
num:	
	la $s0,($a1)
	blt $a0,10,onedigit

	li $t5,10
	div   $a0,$t5   #  Hi contains the remainder,  Lo contains quotient
	mfhi  $t3        
	mflo  $t4
	addi $t4,$t4,48
	sb $t4,($s0)
	addi $s0,$s0,1
	addi $t3,$t3,48
	sb $t3,($s0)
	addi $s0,$s0,1
	jr $ra
onedigit: addi $t3,$a0,48
	sb $t3,($s0)
	addi $s0,$s0,1
	jr $ra    	
	

