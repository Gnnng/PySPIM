#############################
#Date: 2014/10/29           #
#Auth: Bai Long             #
#Func: OS on System         #
#############################
.text 0x00000000
#interrupt address initialization
	li  $sp, 0xfffc
	#int00
	la	$t0, int01
	la	$t1, INT01_SERVICE
	sw	$t1, 0($t0)
	#int08
	la	$t0, int08
	la	$t1, INT08_SERVICE
	sw	$t1, 0($t0)
#jump to kernel initialization
	j	KERNEL_INIT
.text 0x00000080
#interrupt handler
INT_HANDLER:
	#use $k0, $k1
	#$12: Status, $13: Cause, $14: EPC
	push $ra
	#addi	$sp, $sp, -4
	#sw	$ra, 0($sp)
	#Status 2~6 bit represents interrupt value
	mfc0	$13, $k0 #$12: Status
	andi	$k0, $k0, 0x007C #2~6 bits
	addi	$k0, $k0, 0x0100 #jump to interrupt
	lw	$k0, 0($k0)	 #get the address
	jalr	$k0, $ra
	pop	$ra
	#lw 	$ra, 0($sp)
	#addi 	$sp, $sp, 4
	eret
.data 0x00000100
#interrupt vector table
#init 0, everytime the program runs, load it
	int00:	.word	0 #all external interrupt
	int01:	.word 	0
		.word 	0
		.word 	0
		.word 	0
		.word 	0
		.word 	0
		.word 	0
	int08:	.word	0 #syscall
		.word 	0
.text 0x00000200
#interrupt services
INT_SERVICES:
INT01_SERVICE: #Keyboard interrupt
	#keyboard hit
	push	$ra, $t0, $t1, $t2, $a0
	#load scanning code
	lui	$t0, 0xffff
	ori	$t0, $t0, 0x0100
	lw	$t0, 0($t0)
	#put ZBCode into the buffer
	#addi	$t1, $zero, 0xF0
	#beq	$t0, $t1, READ_BREAK_CODE
#READ_MAKE_CODE:
	#add	$a0, $t0, $zero
	#jal	TURN_TO_ZB
	#add	$a0, $v0, $zero
	#jal	PUT_INTO_KEYBOARD_BUF
INT01_SERVICE_END:
	#return
	pop	$ra, $t0, $t1, $t2, $a0
	jr	$ra
INT08_SERVICE:
	#syscall
	mfc0	$11, $k0
	mfc0	$12, $k1
	push	$k0, $k1
	mfc0	$13, $k1
	push	$k1
	mfc0	$14, $k1
	push	$k1
	mfc0	$15, $k1
	push	$k1
	li	$k0, 0x80000000
	mtc0	$11, $k0
	push $ra, $a0, $t0
	#since read char is returned in $v0, so we shouldn't push $v0
	#print_string
	addi	$t0, $zero, 4
	beq	$v0, $t0, INT08_PRINT_STRING
	#print_char
	addi	$t0, $zero, 11
	beq	$v0, $t0, INT08_PRINT_CHAR
	#read_char
	addi	$t0, $zero, 12
	beq	$v0, $t0, INT08_READ_CHAR
	pop $ra, $a0, $t0
	#return
	pop	$k0, $k1
	mtc0	$11, $k0
	mtc0	$12, $k1
	pop	$k0, $k1
	mfc0	$13, $k0
	mfc0	$14, $k1
	pop	$k1
	mfc0	$15, $k1
	jr	$ra
INT08_PRINT_STRING:
	#syscall print string
	push	$ra, $v0, $a0, $t0
	#mov $t0, $a0
	add	$t0, $a0, $zero
PRINT_STRING_LOOP:
	#here add load byte
	#$a0 is address
	add	$a0, $t0, $zero
	jal	Load_Byte
	add	$a0, $v0, $zero
	#load byte end
	beq	$a0, $zero, PRINT_STRING_END_LOOP
	jal	INT08_PRINT_CHAR
	addi	$t0, $t0, 1
	j	PRINT_STRING_LOOP
PRINT_STRING_END_LOOP:
	pop	$ra, $v0, $a0, $t0
	#return
	jr	$ra
INT08_PRINT_CHAR:
	push	$ra, $v0, $a0, $a1, $a2, $t0, $t1
	#a0 ascii, a1 X, a2 Y
	#Cursor X, Y
	lui	$t0, 0xffff
	lw	$a1, 0($t0) #X
	lw	$a2, 4($t0) #Y
	#if a0 = enter
	addi	$t1, $zero, 10
	bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
	add	$a1, $zero, $zero
	addi	$a2, $a2, 1
	j	INT08_PRINT_CHAR_MOVE_X
	#if a0 = backspace
	addi	$t1, $zero, 8
	bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
	add	$a0, $zero, $zero
	bne	$a1, $zero, INT08_PRINT_CHAR_BACKSPACE
	beq	$a2, $zero, INT08_PRINT_CHAR_BACKSPACE_EXEC
	addi	$a2, $a2, -1
	la	$t1, WEIGHT
	lw	$a1, 0($t1)
INT08_PRINT_CHAR_BACKSPACE:
	addi	$a1, $a1, -1
INT08_PRINT_CHAR_BACKSPACE_EXEC:
	jal	SHOW_CHAR
	#jump to end
	j	INT08_PRINT_CHAR_END
	#backspace exec end
INT08_PRINT_CHAR_EXEC:
	jal	SHOW_CHAR
	#X+1
	addi	$a1, $a1, 1
INT08_PRINT_CHAR_MOVE_X:
	#if X=WEIGHT
	la	$t1, WEIGHT
	lw	$t1, 0($t1)
	bne	$a1, $t1, INT08_PRINT_CHAR_MOVE_Y
	add	$a1, $zero, $zero
	addi	$a2, $a2, 1
INT08_PRINT_CHAR_MOVE_Y:	
	#if Full Page(Y = HEIGHT), scroll page
	la	$t1, HEIGHT
	lw	$t1, 0($t1)
	bne	$a2, $t1, INT08_PRINT_CHAR_END
	jal	PAGE_SCROLL
	add	$a1, $zero, $zero
	addi	$a2, $a2, -1
INT08_PRINT_CHAR_END:	
	#save back X, Y
	sw	$a1, 0($t0)
	sw	$a2, 4($t0)
	pop	$ra, $v0, $a0, $a1, $a2, $t0, $t1
	#return
	jr	$ra
INT08_READ_CHAR:
	#return the ascii in $v0
	push	$ra, $t0, $t1
	pop	$ra, $t0, $t1
	jr	$ra
.data 0x00000900
	WEIGHT:	.word	40
	HEIGHT:	.word	30
	hi:	.asciiz	"1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n24\n25\n26\n27\n28\n29\n30\n31\n32\n33\n34\n35\n"
	KeyBoard_buf:	.word	0
			.word	0
			.word	0
			.word	0
			.word	0
			.word	0
			.word	0
			.word	0
	KeyBoard_head:	.word	0
	KeyBoard_tail:	.word	0
.text 0x00001000
#Kernel initialization begin
KERNEL_INIT:
la $a0,test_file_name
la $a1,test_string
addi $a2,$zero,600
jal fat_write_file
la $a0,test_file_name
la $a1,get_string
jal  fat_read_file
	addi	$v0, $zero, 4
	la	$a0, get_string
	syscall
	addi	$v0, $zero, 4
	la $a0,hi
	#addi $a0,$a0,512
	syscall 
DEAD_LOOP:
	j	DEAD_LOOP
#========global functions========#
#========Load_Byte========#
Load_Byte:
	push $ra, $a0, $t0, $t1
	#$t0 is the relative offset
	andi	$t0, $a0, 3
	addi	$t0, $t0, -3
	sub	$t0, $zero, $t0
	#$t1 saves the word
	lw	$t1, 0($a0)
Load_Byte_Loop:
	beq	$t0, $zero, Load_Byte_End
	srl	$t1, $t1, 8
	addi	$t0, $t0, -1
	j	Load_Byte_Loop
Load_Byte_End:
	#return in $v0
	andi	$v0, $t1, 0xff
	pop	$ra, $a0, $t0, $t1
	jr	$ra
#========SHOW_CHAR========#
SHOW_CHAR:
	#a0 ascii, a1 X, a2 Y
	push	$ra, $a0, $t0 
	sll	$a0, $a0, 3
	#offset
	jal	GET_VRAM_ADDR
	add	$t0, $zero, $v0
	#save word
	sw	$a0, 0($t0)
	pop	$ra, $a0, $t0
	#return
	jr	$ra
#========GET_VRAM_ADDR========#
GET_VRAM_ADDR:
	push	$ra, $a1, $a2, $t0
	#calculate vram addr
	#$a1 = X, $a2 = Y
	add	$v0, $zero, $a2
	sll	$v0, $v0, 7
	add	$v0, $v0, $a1
	sll	$v0, $v0, 2
	lui $t0, 0x1000 
	or  $v0, $v0, $t0
	# return $v0
	pop	$ra, $a1, $a2, $t0
	jr	$ra
#========PAGE_SCROLL========#
PAGE_SCROLL:
	push	$ra, $a1, $a2, $t0, $t1, $t2, $t3
	# load X, Y
	la	$t1, WEIGHT
	lw	$t1, 0($t1)
	la	$t2, HEIGHT
	lw	$t2, 0($t2)
	#LOOP
	addi	$a2, $zero, 1
PAGE_SCROLL_LOOP1:
	add	$a1, $zero, $zero
PAGE_SCROLL_LOOP2:
	jal	GET_VRAM_ADDR
	add	$t0, $zero, $v0
	lw	$t0, 0($t0)
	addi	$a2, $a2, -1
	jal	GET_VRAM_ADDR
	add	$t3, $zero, $v0
	sw	$t0, 0($t3)
	addi	$a2, $a2, 1
	addi	$a1, $a1, 1
	bne	$a1, $t1, PAGE_SCROLL_LOOP2
	addi	$a2, $a2, 1
	bne	$a2, $t2, PAGE_SCROLL_LOOP1
	#clear last loop
	add	$a1, $zero, $zero
	addi	$a2, $a2, -1
PAGE_SCROLL_CLEAR_LAST:
	jal	GET_VRAM_ADDR
	add	$t0, $zero, $v0
	sw	$zero, 0($t0)
	addi	$a1, $a1, 1
	bne	$a1, $t1, PAGE_SCROLL_CLEAR_LAST
	#return
	pop	$ra, $a1, $a2, $t0, $t1, $t2, $t3
	jr	$ra
#========GET_ZB_CODE========#
GET_ZB_CODE:
	push	$ra, $a0, $t0
	addi 	$v0, $zero, 48
	xori 	$t0, $a0, 0x45 		# 0
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x16 		# 1
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x1e 		# 2
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x26 		# 3
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x25 		# 4
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x2e 		# 5
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x36 		# 6
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x3d 		# 7
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x3e 		# 8
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x46 		# 9
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 97
	xori	$t0, $a0, 0x1c		# a
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x32		# b
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x21 		# c
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x23 		# d
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x24 		# e
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x2b		# f
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x34		# g
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x33		# h
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x43		# i
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x3b		# j
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x42		# k
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x4b		# l
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x3a		# m
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x31		# n
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x44		# o
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x4d		# p
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x15		# q
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x2d		# r
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x1b		# s
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x2c		# t
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x3c		# u
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x2a		# v
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x1d		# w
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x22		# x
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x35		# y
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $v0, 1
	xori 	$t0, $a0, 0x1a		# z
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 96
	xori 	$t0, $a0, 0x0e 		# `
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 45
	xori 	$t0, $a0, 0x4e 		# -
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 61
	xori 	$t0, $a0, 0x55 		# =
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 8
	xori 	$t0, $a0, 0x66 		# backspace
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 32
	xori 	$t0, $a0, 0x29 		# space
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 9
	xori 	$t0, $a0, 0x0d 		# tab
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 10
	xori 	$t0, $a0, 0x5a 		# enter
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 27
	xori 	$t0, $a0, 0x76 		# esc
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 91
	xori 	$t0, $a0, 0x54 		# [
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 93
	xori 	$t0, $a0, 0x5b 		# ]
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 59
	xori 	$t0, $a0, 0x4c 		# ;
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 39
	xori 	$t0, $a0, 0x52 		# '
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 44
	xori 	$t0, $a0, 0x41 		# ,
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 46
	xori 	$t0, $a0, 0x49 		# .
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 47
	xori 	$t0, $a0, 0x4a 		# /
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 92			
	xori 	$t0, $a0, 0x5d 		# \
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 0x80			
	xori 	$t0, $a0, 0x75 		# up
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 0x81
	xori 	$t0, $a0, 0x72 		# down
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 0x82
	xori 	$t0, $a0, 0x6b 		# left
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 0x83
	xori 	$t0, $a0, 0x74 		# right
	beq 	$t0, $zero, GET_ZB_CODE_END
	addi 	$v0, $zero, 0
GET_ZB_CODE_END:
	pop	$ra, $a0, $t0
	jr	$ra
#========READ_BREAK_CODE========#
READ_BREAK_CODE:
	push	$ra, $a0, $t0
	jal	GET_FROM_KEYBOARD_BUF
	add	$a0, $v0, $zero
	jal	GET_ZB_CODE
	#return
	pop	$ra, $a0, $t0
	jr	$ra
#========READ_BREAK_CODE========#
PUT_INTO_KEYBOARD_BUF:
	push	$ra, $a0, $t0, $t1, $t2
	#main
	la	$t0, KeyBoard_tail
	# if head-1 = tail then buf is full
	la	$t2, KeyBoard_head
	addi	$t2, $t2, -1
	andi	$t2, $t2, 0x7
	beq	$t0, $t2, PUT_INTO_KEYBOARD_BUF_END
	#load buf
	la	$t1, KeyBoard_buf
	# buf[tail] = a0
	add	$t1, $t1, $t0
	sw	$a0, 0($t1)
	# tail %= tail+1
	addi	$t0, $t0, 1
	andi	$t0, $t0, 0x7
	la	$t1, KeyBoard_tail
	sw	$t0, 0($t1)
PUT_INTO_KEYBOARD_BUF_END:
	#return
	pop	$ra, $a0, $t0, $t1, $t2
	jr	$ra
#========READ_BREAK_CODE========#
GET_FROM_KEYBOARD_BUF:
	push	$ra, $t0, $t1, $t2
	#if head=tail then buf is empty
	la	$t0, KeyBoard_head
	la	$t1, KeyBoard_tail
	beq	$t0, $t1, GET_FROM_KEYBOARD_BUF_END
	# load buf
	la	$t1, KeyBoard_buf
	# v0 = buf[head]
	add	$t1, $t1, $t0
	lw	$v0, 0($t1)
	# head %= head + 1
	addi	$t0, $t0, 1
	andi	$t0, $t0, 0x7
	la	$t1, KeyBoard_head
	sw	$t0, 0($t1)
GET_FROM_KEYBOARD_BUF_END:
	#return
	pop	$ra, $t0, $t1, $t2
	jr	$ra
#00002000start
#00010000virtual disk
#10000000+ buffer
#000


.data 0x00003000
	test_file_name: .asciiz "hello"
	test_string:	.asciiz "hello world"
.data 0x00003400
					.asciiz "hello world again!"
	get_string: 	.asciiz "nihao zhongguo=~="

.data 0x00004000
.data 0x00007000

.text
fat_half_read:
	push $ra
	lw $t1,0($a0)#disk
	andi $t2,$a0,2
	beq $t2,$zero,read_first_half
	j read_second_half
	read_first_half:
	srl $v0,$t1,16
	pop $ra
	jr $ra
	read_second_half:
	li $t2,0x0000FFFF
	and $v0,$t1,$t2
	pop $ra
	jr $ra
fat_half_write:
	#a0 disk #a1 word
	push $ra
	lw $t1,0($a0)#disk
	andi $t2,$a0,2
	beq $t2,$zero,write_first_half
	j write_second_half
	write_first_half:
	sll $a1,$a1,16
	li $t2,0x0000FFFF
	and $t1,$t2,$t1
	or $t1,$a1,$t1
	sw $t1,0($a0)
	pop $ra
	jr $ra
	write_second_half:
	li $t2,0xFFFF0000
	and $t1,$t2,$t1
	or $t1,$a1,$t1
	sw $t1,0($a0)
	pop $ra
	jr $ra
fat_word_read:
	push $ra
	lw $t1,0($a0)#disk
	sw $t1,0($a1)#memory
	pop $ra
	jr $ra
fat_word_write:
	push $ra
	lw $t1,0($a1)#memory
	sw $t1,0($a0)#disk
	pop $ra
	jr $ra
fat_read_cluster:#512B
	push $ra,$s0,$s1,$s2,$s3,$s4
	addi $s0,$zero,0
	addi $s1,$zero,512//4
	addi $s2,$a0,0#cluster_number
	la $t0,fat_data_start_address
	lw $t1,0($t0)
	addi $a0,$a0,-1
	sll $a0,$a0,9
	add $s2,$a0,$t1#disk address
	addi $s3,$a1,0#memory address
	fat_read_cluster_loop:	
		add $a0,$s0,$s2
		add $a1,$s3,$zero
		jal fat_word_read
		addi $s3,$s3,4
		addi $s0,$s0,4
		bne $s0,$s1,fat_read_cluster_loop
	add $v0,$s1,$zero
	pop	$ra,$s0,$s1,$s2,$s3,$s4
	jr $ra
fat_write_cluster:#512B
    #$a2 length $a0 number ,$a1,memory address
	push $ra,$s0,$s1,$s2,$s3,$s4,$s5
	addi $s0,$zero,0
	addi $s1,$zero,512//4
	addi $s2,$a0,0#cluster_number
	la $t0,fat_data_start_address
	lw $t1,0($t0)
	addi $a0,$a0,-1
	sll $a0,$a0,9
	add $s2,$a0,$t1#$disk
	addi $s3,$a1,0#memory address
	addi $s5,$a2,0
	fat_clear_cluster_loop:
		la $t0,fat_zero	
		add $a1,$zero,$t0
		add $a0,$s2,$s0
		jal fat_word_write
		addi $s0,$s0,4
		bne $s0,$s1,fat_clear_cluster_loop
	addi $s0,$zero,0
	addi $s1,$s5,0
	fat_write_cluster_loop:	
		add $a0,$s0,$s2
		add $a1,$s3,$zero
		jal fat_word_write
		addi $s3,$s3,4
		addi $s0,$s0,4
		bne $s0,$s1,fat_write_cluster_loop
	add $v0,$s1,$zero
	pop	$ra,$s0,$s1,$s2,$s3,$s4,$s5
	jr $ra
.data
fat_first_address:  .word   0x0004000#0
dir_last_address:	.word 	0x0004100#0
dir_first_address: 	.word 	0x0004100#0 
fat_zero:			.word 	0x0000000#0
fat_data_start_address:	.word 	0x0004500#0
.text
str_compare:
	addi $t1,$zero,0
	fat_judge_str:
		add $t3,$a0,$t1
		lw $t0,0($t3)
		add $t3,$a1,$t1
		lw $t2,0($t3)
		li $t5,0xFF000000
		and $t3,$t0,$t5
		and $t4,$t2,$t5
		bne $t3,$t4,fat_not_equal_str
		beq $t3,$zero,fat_equal_str
		li $t5,0x00FF0000
		and $t3,$t0,$t5
		and $t4,$t2,$t5
		bne $t3,$t4,fat_not_equal_str
		beq $t3,$zero,fat_equal_str
		li $t5,0x0000FF00
		and $t3,$t0,$t5
		and $t4,$t2,$t5
		bne $t3,$t4,fat_not_equal_str
		beq $t3,$zero,fat_equal_str
		li $t5,0x000000FF
		and $t3,$t0,$t5
		and $t4,$t2,$t5
		bne $t3,$t4,fat_not_equal_str
		beq $t3,$zero,fat_equal_str
		addi $t1,$t1,4
		j fat_judge_str
	fat_not_equal_str:
		addi $v0,$zero,0
		jr $ra
	fat_equal_str:
		addi $v0,$zero,1
		jr $ra
fat_read_file:
    #filename a0,memory address a1
	push $ra,$s0,$s1,$s2,$s3,$s4,$s5
	la $t0,dir_first_address
	lw $s0,0($t0)
	addi $s1,$zero,0
	addi $s2,$a0,0 #filname string address
	addi $s3,$a1,0 #memory address
	
	#[0..10]B name
	#[11]type
	#[22-25]time
	#[26-27]address
	#[28-31]length
	fat_read_dir_loop:
		#whether dir end
		la $t1,dir_last_address
		lw $t1,0($t1)	
		beq $t1,$s0,fat_no_this_file
		addi $s5,$zero,0
		fat_load_dir_loop:
			add  $a0,$s0,$s5
			add  $a1,$s3,$s5
			jal fat_word_read
			addi $s5,$s5,4
			addi $t0,$zero,32
			bne $t0,$s5,fat_load_dir_loop
		addi $a0,$s3,0
		addi $a1,$s2,0
		jal str_compare
		beq $v0,$zero,fat_read_dir_loop
		addi $a0,$s3,26
		jal fat_half_read
		addi $s4,$v0,0
		fat_read_every_cluster:
			addi $a0,$s4,0
			addi $a1,$s3,0
			jal fat_read_cluster
			add $s3,$s3,$v0
			la $t1,fat_first_address
			lw $t0,0($t1)
			sll $t4,$s4,1
			add $t3,$t0,$t4
			addi $a0,$t3,0
			jal fat_half_read
			addi $s4,$v0,0
			li $t0,0xFFFF
			bne $s4,$t0,fat_read_every_cluster
		addi $v0,$zero,1
		pop $ra,$s0,$s1,$s2,$s3,$s4,$s5
		jr $ra
	fat_no_this_file:
	addi $v0,$zero,0
	pop $ra,$s0,$s1,$s2,$s3,$s4,$s5
	jr $ra
fat_write_file:
    # a0=filename a1=memory address a2=length
	push $ra,$s0,$s1,$s2,$s3,$s4,$s5
	la $t0,dir_last_address
	lw $s0,0($t0)
	addi $s0,$s0,32
	sw $s0,0($t0)
	addi $s0,$s0,-32#dir address
	addi $s1,$s1,0
	addi $s1,$zero,0
	addi $s2,$a0,0 #filname string address
	addi $s3,$a1,0 #memory address
	addi $s4,$a2,0 #length
	addi $s5,$zero,0
	fat_write_file_name_loop:
		add $a0,$s5,$s0
		add $a1,$s5,$s2
		jal fat_word_write
		addi $s5,$s5,4
		addi $t0,$zero,12
		bne $s5,$t0,fat_write_file_name_loop
	la $t0,fat_first_address
	lw $t0,0($t0)
	addi $s5,$zero,0#now cluster_number
	fat_find_null:
		addi $s5,$s5,1
		sll $t2,$s5,1
		add $t2,$t2,$t0
		add $a0,$zero,$t2
		jal fat_half_read
		bne $v0,$zero,fat_find_null
	sw $s5,24($s0)
	slti $t0,$s4,512
	beq $t0,$zero,fat_more_than_one
	fat_last_one:
	add $a2,$zero,$s4
	addi $a1,$s3,0
	addi $a0,$s5,0
	jal fat_write_cluster
	sll $t2,$s5,1
	la $t0,fat_first_address
	lw $t0,0($t0)
	add $t2,$t2,$t0
	addi $a0,$t2,0
	li $a1,0x0000FFFF
	jal fat_half_write
	pop $ra,$s0,$s1,$s2,$s3,$s4,$s5
	jr $ra
	fat_more_than_one:
	push $s5
	addi $a2,$zero,512
	addi $a1,$s3,0
	addi $a0,$s5,0
	jal fat_write_cluster
	fat_find_null_in_m:
		addi $s5,$s5,1
		sll $t2,$s5,1
		add $t2,$t2,$t0
		add $a0,$zero,$t2
		jal fat_half_read
		bne $v0,$zero,fat_find_null_in_m
	pop $t0
	la $t1,fat_first_address
	lw $t1,0($t1)
	sll $t0,$t0,1
	add $t3,$t0,$t1
	addi $a0,$t3,0
	addi $a1,$s5,0
	jal fat_half_write
	addi $s4,$s4,-512
	slti $t0,$s4,512
	beq $t0,$zero,fat_more_than_one
	j fat_last_one

	




	
