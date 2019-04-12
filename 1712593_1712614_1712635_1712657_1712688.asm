.data
	tb_input: .asciiz "Nhap TIME: "
	tb_input_1: .asciiz "\nNhap TIME_1: "
	tb_input_2: .asciiz "\nNhap TIME_2: "
	tb_input_ngay: .asciiz "\nNhap ngay: "
	tb_input_thang: .asciiz "\nNhap thang: "
	tb_input_nam: .asciiz "\nNhap nam: "
	tb_input_error: .asciiz "\nDu lieu nhap vao khong hop le, moi nhap lai.\n"
	fin: .asciiz "./input.txt"
	fin_buffer: .space 1024
	fout: .asciiz "./output.txt"
	newline: .asciiz "\n"
	fout_buffer: .space 1024
	TIME_1: .space 100
	TIME_2: .space 100
	input_2: .space 3
	input_4: .space 5
	selection: .word 0
	d1: .word 0
	m1: .word 0
	y1: .word 0
	d2: .word 0
	m2: .word 0
	y2: .word 0
.text
.globl main

main:
	# nhap nam 
	#nhap ngay
	li $t0,12
	li $t1,4
	li $t2,2020
	sw $t0,d1
	sw $t1,m1
	sw $t2,y1
	lw $a0,d1
	lw $a1,m1
	lw $a2,y1
	la $a3,TIME_1
	jal Date

	li $t0,12
	li $t1,4
	li $t2,2019
	sw $t0,d2
	sw $t1,m2
	sw $t2,y2
	lw $a0,d2
	lw $a1,m2
	lw $a2,y2
	la $a3,TIME_2
	jal Date

	la $a0,TIME_1
	la $a1,TIME_2
	
	jal Distance2day
	move $a0,$v0
	
	li $v0,1
	syscall
	j end


#======================================
# ===== itoa =====================
# char itoa($a0: int 1 digit)
# return $v0: char
itoa:
	# push stack
	subu $sp, $sp, 4
	sw $ra, ($sp)
	
	addi $v0, $a0, '0'
	
	# pop stack
	lw $ra, ($sp)
	addu $sp, $sp, 4
	
	# ket thuc ham	
	jr $ra
# ================================


# ===== atoi =====================
# int atoi($a0: char 1 digit)
# return $v0: int
atoi:
	# push stack
	subu $sp, $sp, 4
	sw $ra, ($sp)
	
	subi $v0, $a0, '0'
	
	# pop stack
	lw $ra, ($sp)
	addu $sp, $sp, 4
	
	# ket thuc ham	
	jr $ra
# ================================

# ===== Lay do dai chuoi =========
# int strlen($a0: string)
# return $v0: int strlen
strlen:
	# push stack
	subu $sp, $sp, 16
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	la $s2, ($a0)
strlen_loop:
	lb $s1, ($s2)
	beqz $s1, strlen_end  # check null
	addi $s2, $s2, 1
	addi $s0, $s0, 1  # len = len + 1
	j strlen_loop
strlen_end:
	move $v0, $s0
	
	# pop stack
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 16
	
	# ket thuc ham	
	jr $ra
# ================================

# ===== Xuat TIME DD/MM/YYYY =====
# void Date($a0: int day, $a1: int month, $a2: int year, $a3: buffer of formatted string)
Date:
	# push stack
	subu $sp, $sp, 16
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s6, 12($sp)
	
	# convert day
	div $s0, $a0, 10
	mflo $s0
	mfhi $s1
	move $a0, $s0
	jal itoa
	move $s0, $v0
	move $a0, $s1
	jal itoa
	move $s1, $v0
	sb $s0, 0($a3)
	sb $s1, 1($a3)
	
	# add '/'
	addi $s0, $0, '/'
	sb $s0, 2($a3)
	
	# convert month
	div $s0, $a1, 10
	mflo $s0
	mfhi $s1
	move $a0, $s0
	jal itoa
	move $s0, $v0
	move $a0, $s1
	jal itoa
	move $s1, $v0
	sb $s0, 3($a3)
	sb $s1, 4($a3)
	
	# add '/'
	addi $s0, $0, '/'
	sb $s0, 5($a3)
	
	# convert year
	li $s6, 1 # i = 1
	move $s0, $a2
Date_YR_loop:
	# divide by 10 to get rightmost number
	div $s0, $s0, 10
	mflo $s0
	mfhi $s1
	move $a0, $s1
	jal itoa
	# push stack
	subu $sp, $sp, 4
	sw $v0, ($sp)
	
	addi $s6, $s6, 1
	beq $s6, 4, Date_i_equals_4 # if i == 4
	j Date_YR_loop
	
Date_i_equals_4:
	# pop stack 
	move $a0, $s0
	jal itoa
	sb $v0, 6($a3)
	
	lw $s0, ($sp)
	addu $sp, $sp, 4
	sb $s0, 7($a3)
	
	lw $s0, ($sp)
	addu $sp, $sp, 4
	sb $s0, 8($a3)
	
	lw $s0, ($sp)
	addu $sp, $sp, 4
	sb $s0, 9($a3)
	
	# add '\0'
	addu $s0, $0, '\0'
	sb $s0, 10($a3)
	
	# pop stack
	lw $s6, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 16
	
	# ket thuc ham	
	jr $ra
# ================================
# ===== Tach DD, MM, YYYY ========
# void Time($a0: string DD/MM/YYYY, $a1: int 1 for D1, 2 for D2)
Time:
	# push stack
	subu $sp, $sp, 28
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	
	la $s0, ($a0)
	
	
	# trich day
	lb $a0, 0($s0)
	jal atoi
	mul $t0, $v0, 10	
	
	lb $a0, 1($s0)
	jal atoi
	move $t1, $v0
	
	add $s1, $t0, $t1  # day = $t0 + $t1
	
	
	# trich month
	lb $a0, 3($s0)
	jal atoi
	mul $t0, $v0, 10	
	
	lb $a0, 4($s0)
	jal atoi
	move $t1, $v0
	
	add $s2, $t0, $t1  # month = $t0 + $t1
	
	
	# trich year
	lb $a0, 6($s0)
	jal atoi
	mul $t0, $v0, 1000
	add $s3, $0, $t0
	
	lb $a0, 7($s0)
	jal atoi
	mul $t0, $v0, 100
	add $s3, $s3, $t0
	
	lb $a0, 8($s0)
	jal atoi
	mul $t0, $v0, 10
	add $s3, $s3, $t0
	
	lb $a0, 9($s0)
	jal atoi
	add $s3, $s3, $v0
	
	
	# luu vao dX mX yX
	beq $a1, 2, Time_Save2
Time_Save1:	
	sw $s1, d1
	sw $s2, m1
	sw $s3, y1
	j Time_Exit
	
Time_Save2:
	sw $s1, d2
	sw $s2, m2
	sw $s3, y2

Time_Exit:
	# pop stack
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $t0, 20($sp)
	lw $t1, 24($sp)
	addu $sp, $sp, 28
	# ket thuc ham	
	jr $ra
# ================================
# Khoang cach giua 2 ngay TIME_1 va TIME_2
# int Distance2day($a0: str TIME_1,$a1 str TIME_2
Distance2day:
	# Push Stack
	subu $sp,$sp,28
	sw $ra,($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $t0, 20($sp)
	sw $t1, 24($sp)
	# Load TIME_1 and TIME_2
	la $t0,($a0)
	la $t1,($a1)
	# TIME_1 => d1,m1,y1
	li,$a1,1
	jal Time
	# TIME_2 => d2,m2,y2
	la $a0,($t1)
	li $a1,2
	jal Time

	lw $a0,d1
	lw $a1,m1
	lw $a2,y1
	# Day from 1/1/1 to TIME 1
	jal DayFrom1
	move $s0,$v0

	lw $a0,d2
	lw $a1,m2
	lw $a2,y2
	# Day from 1/1/1 to TIME 2
	jal DayFrom1
	move $s1,$v0
	# Distance from Time_1 to Time_2
	sub $t0,$s0,$s1
	bltz $t0,Distance2day_Am # Minus
	j Distance2day_Exit
Distance2day_Am:
	sub $t0,$0,$t0
	j Distance2day_Exit
Distance2day_Exit:
	move $v0,$t0
	# Pop Stack
	lw $ra,($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $t0, 20($sp)
	lw $t1, 24($sp)
	addu $sp,$sp,28
	jr $ra
# ========================================================
# ===== ham Ngay thu may ke tu ngay 1/1/1 ( 1/1/1 la ngay thu 1) =====
# int DayFrom1($a0: int Day, $a1: int Month, $a2: int Year)
DayFrom1:
	# Push Stack
	subu $sp,$sp,28
	sw $ra,($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $a2,12($sp)
	sw $s0,16($sp)
	sw $s1,20($sp)
	sw $t0,24($sp)
	#Kiem tra dieu kien
	li $t0,3
	sub $t0,$a2,$t0
	bltz $t0,XuLiDK
	j XuLi


XuLiDK:
	sub $a2,$a2,1
	add $a1,$a1,12
	j XuLi
XuLi:
	#+365 * year
	li $s0,0
	li $t0,365
	mult $t0,$a2
	mflo $t0
	add $s0,$s0,$t0
	#+year/4
	li $t0,4
	div $a2,$t0
	mflo $t0
	add $s0,$s0,$t0
	#-year/100
	li $t0,100
	div $a2,$t0
	mflo $t0
	sub $s0,$s0,$t0
	#+year/400
	li $t0,400
	div $a2,$t0
	mflo $t0
	add $s0,$s0,$t0
	#+ (153 * month - 457)
	li $t0,153
	mult $t0,$a1
	mflo $s1
	li $t0,457
	sub $s1,$s1,$t0
	li $t0,5
	div $s1,$t0
	mflo $t0
	add $s0,$s0,$t0
	#+day-306
	add $s0,$s0,$a0
	li $t0,306
	sub $s0,$s0,306
	# return ket qua
	move $v0,$s0
	# popstack	
	lw $ra,($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $a2,12($sp)
	lw $s0,16($sp)
	lw $s1,20($sp)
	lw $t0,24($sp)
	addu $sp,$sp,28
	jr $ra
#==========================
end:
	li $v0,10
	syscall
