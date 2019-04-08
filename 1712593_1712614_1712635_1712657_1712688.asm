	.data
fin: .asciiz "./input.txt"
fin_buffer: .space 1024
fout: .asciiz "./output.txt"
fout_buffer: .space 1024
x: .double
d1: .word 0
m1: .word 0
y1: .word 0
d2: .word 0
m2: .word 0
y2: .word 0
	.text
	.globl main
main:
	la $a0, fin_buffer
	jal Doc_File
	
	#la $a0, fin_buffer
	#li $v0, 4
	#syscall
	
	# copy fin_buffer to fout_buffer
	la $t0, fin_buffer
	la $t1, fout_buffer
copy_loop:
	lb $t6, ($t0)
	sb $t6, ($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	beqz $t6, exit_loop
	j copy_loop
exit_loop:
	la $a0, fout_buffer
	jal Xuat_File
	
	j exit

# ===== Ham doc file input =====
#  void Doc_FILE($a0: buffer)
Doc_File:
	# push stack
	subu $sp, $sp, 4
	sw $ra, ($sp)
	#sw $a0, 4($sp)
	
	# open input file
	la $a0, fin
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	move $s6, $v0
	
	# read opened input file
	move $a0, $s6
	la $a1, fin_buffer
	li $a2, 1024
	li $v0, 14
	syscall
	move $t0, $v0 # input length
	
	# close input file
	move $a0, $s6
	li $v0, 16
	syscall
	
	# pop stack
	lw $ra, ($sp)
	#lw $a0, 4($a0)
	addu $sp, $sp, 4
	
	# exit from function
	jr $ra
# ================================

# ===== Ham xuat file output =====
# void Xuat_FILE($a0: buffer)
Xuat_File:
	# push stack
	subu $sp, $sp, 4
	sw $ra, ($sp)
	#sw $a0, 4($sp)
	
	# open output file
	la $a0, fout
	li $a1, 1
	li $a2, 0
	li $v0, 13
	syscall
	move $s6, $v0
	
	# write output file
	move $a0, $s6
	la $a1, fout_buffer
	li $a2, 1024
	li $v0, 15
	syscall
	
	# close output file
	move $a0, $s6
	li $v0, 16
	syscall
	
	# pop stack
	lw $ra, ($sp)
	#lw $a0, 4($a0)
	addu $sp, $sp, 4
	
	# exit from function
	jr $ra
# ================================
	
exit:
	li $v0, 10
	syscall
