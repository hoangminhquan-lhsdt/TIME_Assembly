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
input_2: .space 4
input_4: .space 6
selection: .word 7
d1: .word 0
m1: .word 0
y1: .word 0
d2: .word 0
m2: .word 0
y2: .word 0
	.text
	.globl main
main:
	lw $a0, selection
	jal Nhap
	
	la $a0, newline
	li $v0, 4
	syscall
	
	la $a0, TIME_1
	li $v0, 4
	syscall
	
	la $a0, newline
	li $v0, 4
	syscall
	
	la $a0, TIME_2
	li $v0, 4
	syscall

	
	j exit

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
	
	
	# trich ngay
	lb $a0, 0($s0)
	jal atoi
	mul $t0, $v0, 10	
	
	lb $a0, 1($s0)
	jal atoi
	move $t1, $v0
	
	add $s1, $t0, $t1  # day = $t0 + $t1
	
	
	# trich thang
	lb $a0, 3($s0)
	jal atoi
	mul $t0, $v0, 10	
	
	lb $a0, 4($s0)
	jal atoi
	move $t1, $v0
	
	add $s2, $t0, $t1  # month = $t0 + $t1
	
	
	# trich nam
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
	lw $t1, 24($sp)
	lw $t0, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 28
	
	# ket thuc ham	
	jr $ra
# ================================


# ===== Chuan hoa DD, MM =========
# void Format_DM($a0: string)
Format_DM:
	# push stack
	subu $sp, $sp, 12
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	# dua ki tu sang phai, them so 0 o truoc
	li $s0, 48
	lb $s1, 0($a0)
	sb $s0, 0($a0)
	sb $s1, 1($a0)
	sb $0, 2($a0)
	li $s0, 0
	
	# pop stack
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 12
	
	# ket thuc ham
	jr $ra
# ================================


# ===== Chuan hoa YEAR ===========
# void Format_YR($a0: string, $a1: int strlen)
Format_YR:
	# push stack
	subu $sp, $sp, 16
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $t0, 12($sp)
	#sw $t1, 16($sp)
	
	# push tung ki tu vao stack
	la $s0, ($a0)
	li $t0, 0  # i = 0
Format_YR_push:
	lb $s1, ($s0)
	
	subu $sp, $sp, 4
	sw $s1, ($sp)
	
	addu $s0, $s0, 1
	addi $t0, $t0, 1  # i = i + 1
	bne $t0, $a1, Format_YR_push  # do while (i != strlen)
	
	# ghi 0 vao cac ki tu truoc
	la $s0, ($a0)
	li $s1, '0'
	li $t0, 0  # i = 0
Format_YR_fill0:
	sb $s1, ($s0)
	addu $s0, $s0, 1
	addi $t0, $t0, 1
	bne $t0, 4, Format_YR_fill0  # do while (i != 4)
	
	# pop tung ki tu
	addu $s0, $a0, 3
	li $t0, 0
Format_YR_pop:
	lw $s1, ($sp)
	addu $sp, $sp, 4
	
	sb $s1, ($s0)
	
	subu $s0, $s0, 1
	addi $t0, $t0, 1
	bne $t0, $a1, Format_YR_pop
	
	
	# pop stack
	#lw $t1, 16($sp)
	lw $t0, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 16
	
	# ket thuc ham
	jr $ra
# ================================


# ===== Ham kiem tra input =======
# int KiemTra_Input($a0: string)
# return $v0: int 1 if valid, 0 if error
KiemTra_Input:
	# push stack
	subu $sp, $sp, 16
	sw $ra, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s6, 12($sp)
	
	# lay strlen
	jal strlen
	move $s6, $v0
	
	# check tung ki tu
KiemTra_Input_loop:
	lb $s2, ($a0)
	blt $s2, 48, Input_Invalid # if ($s2 < '0')
	bgt $s2, 57, Input_Invalid # if ($s2 > '9')
	addi $a0, $a0, 1
	subi $s6, $s6, 1
	
	beq $s6, $0, Input_Valid
	j KiemTra_Input_loop
	
Input_Valid:
	li $v0, 1
	j KiemTra_Input_Exit
Input_Invalid:
	li $v0, 0
	j KiemTra_Input_Exit

KiemTra_Input_Exit:
	# pop stack
	lw $s6, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 16
	
	# ket thuc ham	
	jr $ra
# ================================


# ===== Ham nhap bang tay ========
# void Nhap($a0: int mode)
Nhap:
	# push stack
	subu $sp, $sp, 20
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	move $s0, $a0
	
	beq $s0, 7, Nhap_2
	
	# Nhap 1 Date
	li $s0, 0
	la $a0, tb_input
	li $v0, 4
	syscall
Nhap_1:
	# Nhap ngay
	la $a0, tb_input_ngay
	li $v0, 4
	syscall
	
	la $a0, input_2
	li $a1, 3
	li $v0, 8
	syscall
	
	# Chuan hoa chuoi ngay
	la $a0, input_2
	jal strlen
	beq $v0, 2, Nhap_1_day_skip
	la $a0, input_2
	jal Format_DM
	
Nhap_1_day_skip:
	la $a0, input_2
	jal KiemTra_Input
	beqz $v0, Nhap_1_error
	
	# chuyen chuoi ngay da nhap thanh int
	li $s3, 10
	la $s1, input_2
	lb $a0, 0($s1)
	jal atoi
	move $s2, $v0
	mult $s2, $s3
	mflo $s3
	
	lb $a0, 1($s1)
	jal atoi
	move $s2, $v0
	add $s2, $s2, $s3
	
	sw $s2, d1  # luu vao d1
	
	
	# Nhap thang
	la $a0, tb_input_thang
	li $v0, 4
	syscall
	
	la $a0, input_2
	li $a1, 3
	li $v0, 8
	syscall
	
	# Chuan hoa chuoi thang
	la $a0, input_2
	jal strlen
	beq $v0, 2, Nhap_1_month_skip
	la $a0, input_2
	jal Format_DM
	
Nhap_1_month_skip:
	la $a0, input_2
	jal KiemTra_Input
	beqz $v0, Nhap_1_error
	
	# chuyen chuoi thang da nhap thanh int
	li $s3, 10
	la $s1, input_2
	lb $a0, 0($s1)
	jal atoi
	move $s2, $v0
	mult $s2, $s3
	mflo $s3
	
	lb $a0, 1($s1)
	jal atoi
	move $s2, $v0
	add $s2, $s2, $s3
	
	sw $s2, m1  # luu vao m1
	
	
	# Nhap nam
	la $a0, tb_input_nam
	li $v0, 4
	syscall
	
	la $a0, input_4
	li $a1, 5
	li $v0, 8
	syscall
	
	# Chuan hoa chuoi nam
	la $a0, input_4
	jal strlen
	beq $v0, 4, Nhap_1_year_skip
	la $a0, input_4
	la $a1, ($v0)
	jal Format_YR
	
Nhap_1_year_skip:
	la $a0, input_4
	jal KiemTra_Input
	beqz $v0, Nhap_1_error
	
	# chuyen chuoi nam da nhap thanh int
	li $s3, 1000
	li $s2, 0
	la $s1, input_4
Nhap_nam_1_loop:
	lb $a0, ($s1)	
	jal atoi
	mult $v0, $s3
	mflo $s0
	add $s2, $s2, $s0
	div $s3, $s3, 10
	addi $s1, $s1, 1
	bnez $s3, Nhap_nam_1_loop
	sw $s2, y1
	
	j Nhap_Exit
	
Nhap_1_error:
	la $a0, tb_input_error
	li $v0, 4
	syscall
	
	j Nhap_1
	

	# Nhap 2 Date
Nhap_2:	
	li $s0, 0
	la $a0, tb_input_1
	li $v0, 4
	syscall
	
	
	# Nhap ngay
	la $a0, tb_input_ngay
	li $v0, 4
	syscall
	
	la $a0, input_2
	li $a1, 3
	li $v0, 8
	syscall
	
	# Chuan hoa chuoi ngay
	la $a0, input_2
	jal strlen
	beq $v0, 2, Nhap_2_day_skip
	la $a0, input_2
	jal Format_DM
	
Nhap_2_day_skip:
	la $a0, input_2
	jal KiemTra_Input
	beqz $v0, Nhap_2_error
	
	# chuyen chuoi ngay da nhap thanh int
	li $s3, 10
	la $s1, input_2
	lb $a0, 0($s1)
	jal atoi
	move $s2, $v0
	mult $s2, $s3
	mflo $s3
	lb $a0, 1($s1)
	jal atoi
	move $s2, $v0
	add $s2, $s2, $s3
	
	sw $s2, d2  # luu vao d1
	
	
	# Nhap thang
	la $a0, tb_input_thang
	li $v0, 4
	syscall
	
	la $a0, input_2
	li $a1, 3
	li $v0, 8
	syscall
	
	# Chuan hoa chuoi thang
	la $a0, input_2
	jal strlen
	beq $v0, 2, Nhap_2_month_skip
	la $a0, input_2
	jal Format_DM
	
Nhap_2_month_skip:
	la $a0, input_2
	jal KiemTra_Input
	beqz $v0, Nhap_2_error
	
	# chuyen chuoi thang da nhap thanh int
	li $s3, 10
	la $s1, input_2
	lb $a0, 0($s1)
	jal atoi
	move $s2, $v0
	mult $s2, $s3
	mflo $s3
	
	lb $a0, 1($s1)
	jal atoi
	move $s2, $v0
	add $s2, $s2, $s3
	
	sw $s2, m2  # luu vao m1
	
	
	# Nhap nam
	la $a0, tb_input_nam
	li $v0, 4
	syscall
	
	la $a0, input_4
	li $a1, 5
	li $v0, 8
	syscall
	
	# Chuan hoa chuoi nam
	la $a0, input_4
	jal strlen
	beq $v0, 4, Nhap_2_year_skip
	la $a0, input_4
	la $a1, ($v0)
	jal Format_YR
	
Nhap_2_year_skip:	
	la $a0, input_4
	jal KiemTra_Input
	beqz $v0, Nhap_2_error
	
	# chuyen chuoi nam da nhap thanh int
	li $s3, 1000
	li $s2, 0
	la $s1, input_4
Nhap_nam_2_loop:
	lb $a0, ($s1)	
	jal atoi
	mult $v0, $s3
	mflo $s0
	add $s2, $s2, $s0
	div $s3, $s3, 10
	addi $s1, $s1, 1
	bnez $s3, Nhap_nam_2_loop
	sw $s2, y2
	
	# reset gia tri thanh ghi
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	
	la $a0, tb_input_2
	li $v0, 4
	syscall
	
	j Nhap_1
	
Nhap_2_error:
	la $a0, tb_input_error
	li $v0, 4
	syscall

	j Nhap_2
	
	
Nhap_Exit:
	# swap D1 <-> D2
	subu $sp, $sp, 12
	
	lw $s0, d1
	sw $s0, ($sp)
	
	lw $s0, m1
	sw $s0, 4($sp)
	
	lw $s0, y1
	sw $s0, 8($sp)
	
	lw $s0, y2
	sw $s0, y1
	
	lw $s0, 8($sp)
	sw $s0, y2
	
	lw $s0, m2
	sw $s0, m1
	
	lw $s0, 4($sp)
	sw $s0, m2
	
	lw $s0, d2
	sw $s0, d1
	
	lw $s0, ($sp)
	sw $s0, d2
	
	addu $sp, $sp, 12
	
	# luu d,m,y vao TIME
	lw $a0, d1
	lw $a1, m1
	lw $a2, y1
	la $a3, TIME_1
	jal Date
	
	lw $a0, d2
	lw $a1, m2
	lw $a2, y2
	la $a3, TIME_2
	jal Date
	
	# pop stack
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 20
	
	# ket thuc ham	
	jr $ra
# ================================


# ===== Ham ghi fout_buffer ======
# void Ghi_Fout($a0: string)
Ghi_Fout:
	# push stack
	subu $sp, $sp, 12
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	# copy string to buffer
	la $s0, fout_buffer
Ghi_Fout_loop:
	lb $s1, ($a0)
	sb $s1, ($s0)
	addi $a0, $a0, 1
	addi $s0, $s0, 1
	bnez $s1, Ghi_Fout_loop
	
	# pop stack
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 12
	
	# exit from function
	jr $ra
# ================================


# ===== Ham doc file input =======
# void Doc_FILE()
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
	move $s0, $v0  # input length
	
	# close input file
	move $a0, $s6
	li $v0, 16
	syscall
	
	# pop stack
	lw $ra, ($sp)
	lw $s6, 4($sp)
	addu $sp, $sp, 8
	
	# ket thuc ham	
	jr $ra
# ================================


# ===== Ham xuat file output =====
# void Xuat_FILE()
Xuat_File:
	# push stack
	subu $sp, $sp, 8
	sw $ra, ($sp)
	sw $s6, 4($sp)
	
	# add '\0'
	la $a0, fout_buffer
	jal strlen
	addi $s6, $s6, 1
	move $s6, $v0
	add $a0, $a0, $s6
	addu $s6, $0, '\0'
	sb $s6, ($a0)
	
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
	
	# ket thuc ham	
	jr $ra
# ================================


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
	subu $sp, $sp, 24
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	
	la $t0, newline
	lb $t1, ($t0)
	
	la $s2, ($a0)
strlen_loop:
	lb $s1, ($s2)
	beqz $s1, strlen_end  # check null
	beq $s1, $t1, strlen_end # check newline
	addi $s2, $s2, 1
	addi $s0, $s0, 1  # len = len + 1
	j strlen_loop
strlen_end:
	move $v0, $s0
	
	# pop stack
	lw $t1, 20($sp)
	lw $t0, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, ($sp)
	addu $sp, $sp, 24
	
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


exit:
	li $v0, 10
	syscall
