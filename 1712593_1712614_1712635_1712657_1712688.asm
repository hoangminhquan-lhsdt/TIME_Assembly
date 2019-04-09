	.data
fin: .asciiz "./input.txt"
fin_buffer: .space 1024
fout: .asciiz "./output.txt"
newline: .asciiz "\n"
fout_buffer: .space 1024
TIME_1: .space 100
TIME_2: .space 100
d1: .word 0
m1: .word 0
y1: .word 0
d2: .word 0
m2: .word 0
y2: .word 0
	.text
	.globl main
main:
	la $a0, 10
	la $a1, 05
	la $a2, 2015
	la $a3, TIME_1
	jal Date
	
	la $a0, TIME_1
	li $v0, 4
	syscall
	
	j exit

# ===== Ham doc file input =====
#  void Doc_FILE()
Doc_File:
	# push stack
	subu $sp, $sp, 8
	sw $ra, ($sp)
	sw $s6, 4($sp)
	
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
	lw $s6, 4($sp)
	addu $sp, $sp, 8
	
	# exit from function
	jr $ra
# ================================

# ===== Ham xuat file output =====
# void Xuat_FILE()
Xuat_File:
	# push stack
	subu $sp, $sp, 8
	sw $ra, ($sp)
	sw $s6, 4($sp)
	
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
	lw $s6, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 8
	
	# exit from function
	jr $ra
# ================================

# ===== itoa =====
# char itoa($a0: int 1 digit)
# return $v0: char
itoa:
	# push stack
	subu $sp, $sp, 4
	sw $ra, ($sp)
	
	li $v0, 0
	addi $v0, $a0, '0'
	
	# pop stack
	lw $ra, ($sp)
	addu $sp, $sp, 4
	
	# exit from function
	jr $ra
# ================

# ===== Xuat TIME DD/MM/YYYY =====
# void Date($a0: int day, $a1: int month, $a2: int year, $a3: buffer of formatted string)
Date:
	# push stack
	subu $sp, $sp, 16
	sw $ra, ($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t6, 12($sp)
	
	# convert day
	div $t0, $a0, 10
	mflo $t0
	mfhi $t1
	move $a0, $t0
	jal itoa
	move $t0, $v0
	move $a0, $t1
	jal itoa
	move $t1, $v0
	sb $t0, ($a3)
	sb $t1, 1($a3)
	
	# add '/'
	addi $t0, $0, '/'
	sb $t0, 2($a3)
	
	# convert month
	div $t0, $a1, 10
	mflo $t0
	mfhi $t1
	move $a0, $t0
	jal itoa
	move $t0, $v0
	move $a0, $t1
	jal itoa
	move $t1, $v0
	sb $t0, 3($a3)
	sb $t1, 4($a3)
	
	# add '/'
	addi $t0, $0, '/'
	sb $t0, 5($a3)
	
	# convert year
	li $t6, 1 # i = 1
	move $t0, $a2
Date_YR_loop:
	div $t0, $t0, 10
	mflo $t0
	mfhi $t1
	move $a0, $t1
	jal itoa
	subu $sp, $sp, 4
	sw $v0, ($sp)
	
	addi $t6, $t6, 1
	beq $t6, 4, Date_i_equals_4 # if i == 4
	j Date_YR_loop
	
Date_i_equals_4:
	move $a0, $t0
	jal itoa
	sb $v0, 6($a3)
	
	lw $t0, ($sp)
	addu $sp, $sp, 4
	sb $t0, 7($a3)
	
	lw $t0, ($sp)
	addu $sp, $sp, 4
	sb $t0, 8($a3)
	
	lw $t0, ($sp)
	addu $sp, $sp, 4
	sb $t0, 9($a3)
	
	# pop stack
	lw $t6, 12($sp)
	lw $t1, 8($sp)
	lw $t0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 16
	
	# exit from function
	jr $ra
# ================================

exit:
	li $v0, 10
	syscall
