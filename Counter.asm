#studentName:
#studentID:

# This MIPS program should count the occurence of a word in a text block using MMIO

.data
#any any data you need be after this line 
Text:		.asciiz "peter picked pepper picked"
word:		.asciiz "picked"
Times:		.space 100


	.text
	.globl main

main:	la $a0,Text
	la $a1,word
	jal count
	move $s1,$v0
	
	addi $a0,$v0,0
	la $a1,Times
	jal num
	
	li $v0,4
	la $a0,Times
	syscall

	
	j Exit
	
	

	
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
	
Exit:
	nop

	
