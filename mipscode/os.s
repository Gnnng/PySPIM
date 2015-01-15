#############################
#Date: 2014/10/29           #
#Auth: Bai Long             #
#Func: OS on System         #
#############################
.text 0x00000000
#interrupt address initialization
	j	SYS_INIT
#jump to kernel initialization
SYS_INIT_BACK:
	j	KERNEL_INIT
.text 0x00000080
#interrupt handler
INT_HANDLER:
	#use $k0, $k1
	#$12: Status, $13: Cause, $14: EPC
	push	$ra, $k0
	mfc0	$14, $k0
	push	$k0
	#Status 2~6 bit represents interrupt value
	mfc0	$13, $k0 #$12: Status
	sll     $k0, $k0, 2
	# andi	$k0, $k0, 0x00ff #2~6 bits
	addi	$k0, $k0, 0x0100 #jump to interrupt
	lw	$k0, 0($k0)	 #get the address
	jalr	$k0, $ra
	# jal 	INT_ENABLE
	pop	$k0
	mtc0	$14, $k0
	pop	$ra, $k0
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
	li	$t0, 0xffff0100
	lw	$t0, 0($t0)
	add	$a0, $t0, $zero
	andi	$a0, $a0, 0xff #highest bit is 1 !!!
	#it will be a state machine
	#0 represents no input
	#1 represents input
	#2 represents f0
	#$t1 = State
	la	$t1, Typing_State
	lw	$t1, 0($t1)
	add	$t2, $zero, $zero
	beq	$t1, $t2, INT01_STATE_0
	addi	$t2, $zero, 1
	beq	$t1, $t2, INT01_STATE_1
	addi	$t2, $zero, 2
	beq	$t1, $t2, INT01_STATE_2
INT01_STATE_0:
	#Domain_Word = $a0
	#Typing_State = 1 
	addi	$t2, $zero, 1
	la	$t1, Typing_State
	sw	$t2, 0($t1)
	#turn to ZB code
	jal	GET_ZB_CODE
	add	$a0, $v0, $zero
	jal	PUT_INTO_KEYBOARD_BUF
	j	INT01_SERVICE_END
INT01_STATE_1:
	#if $a0 == f0
	addi	$t0, $zero, 0xf0
	bne	$a0, $t0, INT01_STATE_1_EXEC
	#Typing_State = 2
	addi	$t2, $zero, 2
	la	$t1, Typing_State
	sw	$t2, 0($t1)
	j	INT01_SERVICE_END
INT01_STATE_1_EXEC:
	#turn to ZB code
	jal	GET_ZB_CODE
	add	$a0, $v0, $zero
	jal	PUT_INTO_KEYBOARD_BUF
	j	INT01_SERVICE_END
INT01_STATE_2:
	#Typing_State = 2
	addi	$t2, $zero, 0
	la	$t1, Typing_State
	sw	$t2, 0($t1)
	j	INT01_SERVICE_END
INT01_SERVICE_END:
	#return
	pop	$ra, $t0, $t1, $t2, $a0
	jr	$ra
INT08_SERVICE:
	#syscall
	push $ra, $a0, $t0
	#since read char is returned in $v0, so we shouldn't push $v0
INT08_JUMP_PRINT_STRING:
	#print_string
	addi	$t0, $zero, 4
	bne	$v0, $t0, INT08_JUMP_PRINT_CHAR
	jal 	INT08_PRINT_STRING
INT08_JUMP_PRINT_CHAR:
	#print_char
	addi	$t0, $zero, 11
	bne	$v0, $t0, INT08_JUMP_READ_CHAR
	jal 	INT08_PRINT_CHAR
INT08_JUMP_READ_CHAR:
	#read_char
	addi	$t0, $zero, 12
	bne	$v0, $t0, INT08_SERVICE_END
	jal 	INT08_READ_CHAR
INT08_SERVICE_END:
	#return
	pop	$ra, $a0, $t0
	jr	$ra
INT08_PRINT_STRING:
	#syscall print string
	push	$ra, $v0, $a0, $a1, $t0, $t1
	#mov $t0, $a0
	add	$t0, $a0, $zero
	li 	 	$v1, 0xffff0200
	sw 		$a0, 0($v1)
	#sll	$a1, $a1, 16
	#add	$t1, $zero, $a1
PRINT_STRING_LOOP:
	#here add load byte
	#$a0 is address
	add	$a0, $t0, $zero
	jal	Load_Byte
	add	$a0, $v0, $zero
	#add	$a0, $a0, $a1
	#load byte end
	#beq	$a0, $t1, PRINT_STRING_END_LOOP
	beq	$a0, $zero, PRINT_STRING_END_LOOP
	jal	INT08_PRINT_CHAR
	addi	$t0, $t0, 1
	j	PRINT_STRING_LOOP
PRINT_STRING_END_LOOP:
	pop	$ra, $v0, $a0, $a1, $t0, $t1
	#return
	jr	$ra
INT08_PRINT_CHAR:
	push	$ra, $v0, $a0, $a1, $a2, $t0, $t1
	#a0 ascii, a1 X, a2 Y
	#Cursor X, Y
	lui	$t0, 0xffff
	lw	$a1, 0($t0) #X
	lw	$a2, 4($t0) #Y
	#if a0 = \0
	beq	$a0, $zero, INT08_PRINT_CHAR_END
	#if a0 = enter
	addi	$t1, $zero, 10
	bne	$a0, $t1, INT08_PRINT_CHAR_JUDGE_BACKSPACE
	add	$a1, $zero, $zero
	addi	$a2, $a2, 1
	j	INT08_PRINT_CHAR_MOVE_X
INT08_PRINT_CHAR_JUDGE_BACKSPACE:
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
INT_ENABLE:
	push	$k0
	li 	$k0, 0x80000000
	mtc0	$11, $k0
	pop 	$k0
	jr 	$ra
INT_UNABLE:
	mtc0	$11, $zero
	jr 	$ra
INT08_READ_CHAR:
	#return the ascii in $v0
	push	$ra, $t0, $t1
	#while keyboard buf is empty
	jal 	INT_ENABLE
INT08_READ_CHAR_LOOP:
	la	$t0, KeyBoard_head
	lw	$t0, 0($t0)
	la	$t1, KeyBoard_tail
	lw	$t1, 0($t1)
	beq	$t0, $t1, INT08_READ_CHAR_LOOP
INT08_READ_CHAR_LOOP_END:
	jal 	INT_UNABLE
	jal	GET_FROM_KEYBOARD_BUF
	pop	$ra, $t0, $t1
	jr 	$ra
.data 0x00000900
	_LIST_RESULT:	.asciiz "list root\n"
	WEIGHT:	.word	40
	HEIGHT:	.word	30
	hi:	.asciiz	"Hello World\n"
	_DIR:	.asciiz "root"
	_ARROW:	.asciiz ">"
	_LIST:	.asciiz "ls"
	_LIST2: .asciiz "ls"
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
	Typing_State:	.word	0
	Domain_Word:	.word	0
	COMMAND_LEN:	.word	0
	COMMAND_BUF:	.word	0
			.word	0
			.word	0
			.word	0
			.word	0
			.word	0
			.word	0
			.word	0
			.word	0
.text 0x00001000
#Kernel initialization begin
KERNEL_INIT:
DEAD_LOOP:
	la	$a0, _DIR
	addi	$v0, $zero, 4
	syscall
	la	$a0, _ARROW
	addi	$v0, $zero, 4
	syscall
	add	$t1, $zero, $zero
DEAD_LOOP_2:
	jal	READ_COMMAND_BUF
	jal	EXEC_COMMAND
	la	$t0, COMMAND_LEN
	sw	$zero, 0($t0)
	jal	CLEAR_COMMAND_BUF
	j	DEAD_LOOP
#========global functions========#
#========Load_Byte========#
Load_Byte:
	push	$ra, $a0, $t0, $t1
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
#========Save_Byte========#
Save_Byte:
	push	$ra, $a0, $a1, $t0, $t1, $t2, $t3, $t4
	# a1 - addres of byte, a0 - data
	andi 	$a0, $a0, 0xff
	#offset t0
	andi	$t0, $a1, 0x3
	addi	$t0, $t0, -3
	sub	$t0, $zero, $t0
	#word t1
	lw	$t1, 0($a1)
	add	$v0, $zero, $zero
	addi	$t2, $zero, 0xff
Save_Byte_loop:
	beq	$t0, $zero, Save_Byte_end
	sll	$t2, $t2, 8
	sll	$a0, $a0, 8
	addi	$t0, $t0, -1
	j	Save_Byte_loop
Save_Byte_end:
	li	$t3, 0xffffffff
	xor	$t2, $t2, $t3
	and	$v0, $t2, $t1
	or	$v0, $a0, $v0
	sw	$v0, 0($a0)
	pop	$ra, $a0, $a1, $t0, $t1, $t2, $t3, $t4
	jr	$ra
#========SHOW_CHAR========#
SHOW_CHAR:
	#a0 ascii, a1 X, a2 Y
	push	$ra, $a0, $t0 
	#offset
	li	$t0, 0x00070000
	or 	$a0, $a0, $t0
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
	sll	$v0, $v0, 6
	add	$v0, $v0, $a1
	sll	$v0, $v0, 2
	lui	$t0, 0x1000 
	or	$v0, $v0, $t0
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
#========PUT_INTO_KEYBOARD_BUF========#
PUT_INTO_KEYBOARD_BUF:
	push	$ra, $a0, $t0, $t1, $t2
	#main
	la	$t0, KeyBoard_tail
	lw	$t0, 0($t0)
	# if head-1 = tail then buf is full
	la	$t2, KeyBoard_head
	lw	$t2, 0($t2)
	addi	$t2, $t2, -4
	andi	$t2, $t2, 0x1f
	beq	$t0, $t2, PUT_INTO_KEYBOARD_BUF_END
	#load buf
	la	$t1, KeyBoard_buf
	# buf[tail] = a0
	add	$t1, $t1, $t0
	sw	$a0, 0($t1)
	# tail %= tail+1
	addi	$t0, $t0, 4
	andi	$t0, $t0, 0x1f
	la	$t1, KeyBoard_tail
	sw	$t0, 0($t1)
PUT_INTO_KEYBOARD_BUF_END:
	#return
	pop	$ra, $a0, $t0, $t1, $t2
	jr	$ra
#========GET_FROM_KEYBOARD_BUF========#
GET_FROM_KEYBOARD_BUF:
	push	$ra, $t0, $t1, $t2
	#if head=tail then buf is empty
	la	$t0, KeyBoard_head
	lw	$t0, 0($t0)
	la	$t1, KeyBoard_tail
	lw	$t1, 0($t1)
	beq	$t0, $t1, GET_FROM_KEYBOARD_BUF_END
	# load buf
	la	$t1, KeyBoard_buf
	# v0 = buf[head]
	add	$t1, $t1, $t0
	lw	$v0, 0($t1)
	# head %= head + 1
	addi	$t0, $t0, 4
	andi	$t0, $t0, 0x1f
	la	$t1, KeyBoard_head
	sw	$t0, 0($t1)
GET_FROM_KEYBOARD_BUF_END:
	#return
	pop	$ra, $t0, $t1, $t2
	jr	$ra
#========SYS_INIT========#
SYS_INIT:
	#int00
	la	$t0, int01
	la	$t1, INT01_SERVICE
	sw	$t1, 0($t0)
	#int08
	la	$t0, int08
	la	$t1, INT08_SERVICE
	sw	$t1, 0($t0)
	li 	$sp, 0x3ffc
	li	$t0, 0x80000000
	mtc0	$11, $t0
	j 	SYS_INIT_BACK
#=====COMPARE_STRING=====#
COMPARE_STRING:
	push	$ra, $a0, $a1, $t0, $t1, $s0, $s1, $t2
	add	$s0, $a0, $zero
	add	$s1, $a1, $zero
	#ans
	addi	$t2, $zero, 1
COMPARE_STRING_LOOP:
	#read string 1
	add	$a0, $zero, $s0
	jal	Load_Byte
	add	$t0, $v0, $zero
	#read  string 2
	add	$a0, $zero, $s1
	jal	Load_Byte
	add	$t1, $v0, $zero
	#compare
	bne	$t0, $t1, NOT_EQUAL
	#break
	beq	$t0, $zero, COMPARE_STRING_LOOP_END
	beq	$t1, $zero, COMPARE_STRING_LOOP_END
	addi	$s0, $s0, 1
	addi	$s1, $s1, 1
	j	COMPARE_STRING_LOOP
NOT_EQUAL:
	add	$t2, $zero, $zero
COMPARE_STRING_LOOP_END:
	add	$v0, $zero, $t2
	push	$ra, $a0, $a1, $t0, $t1, $s0, $s1, $t2
	jr	$ra
#=====READ_COMMAND_BUF=====#
READ_COMMAND_BUF:
	push	$ra, $a0, $a1, $t0, $t1, $s0, $s1
READ_COMMAND_BUF_LOOP:
	# read keyboard hit
	addi	$v0, $zero, 12
	syscall
	# s0 = get_char, s1 = buf_len
	add	$s0, $v0, $zero
	la	$t1, COMMAND_LEN
	lw	$s1, 0($t1)
	# if s0 != backspace
	addi	$t0, $zero, 8
	bne	$s0, $t0, READ_COMMAND_BUF_READ
	#if command_len == 0, loop
	beq	$s1, $zero, READ_COMMAND_BUF_LOOP
	# buf[len] = 0;
	la	$a1, COMMAND_BUF
	add	$a1, $a1, $s1
	add	$a0, $zero, $zero
	jal	Save_Byte
	# len--;
	addi	$s1, $s1, -1
	la	$t1, COMMAND_LEN
	sw	$s1, 0($t1)
	# print char
	add	$a0, $s0, $zero
	addi	$v0, $zero, 11
	syscall
	j	READ_COMMAND_BUF_LOOP
READ_COMMAND_BUF_READ:
	#if len==32, loop
	addi	$t1, $zero, 32
	beq	$s1, $t1, READ_COMMAND_BUF_LOOP
	#if a0 = enter
	addi	$t0, $zero, 10
	beq	$s0, $t0, READ_COMMAND_BUF_ENTER
	# buf[len] = a0
	add	$a0, $s0, $zero
	la	$a1, COMMAND_BUF
	add	$a1, $a1, $s1
	jal	Save_Byte
	# len++
	addi	$s1, $s1, 1
	la	$t1, COMMAND_LEN
	sw	$s1, 0($t1)
	# print char
	addi	$v0, $zero, 11
	syscall
	j	READ_COMMAND_BUF_LOOP
READ_COMMAND_BUF_ENTER:
	#buf[len] = 0
	la	$a1, COMMAND_BUF
	add	$a1, $a1, $s0
	add	$a0, $zero, $zero
	jal	Save_Byte
	#print char
	addi	$a0, $zero, 10
	addi	$v0, $zero, 11
	syscall
READ_COMMAND_BUF_END:
	#addi	$v0, $zero, 4
	#la	$a0, COMMAND_BUF
	#syscall
	pop	$ra, $a0, $a1, $t0, $t1, $s0, $s1
	jr	$ra
#=====EXEC_COMMAND=====#
EXEC_COMMAND:
	push	$ra, $a0, $a1
	la 	$a0, COMMAND_BUF
	li 	$v0, 4
	syscall
	# compare
	la	$a0, COMMAND_BUF
	la	$a1, _LIST
	jal str_compare
	# jal	strcmp
	# if !compare return 0
	beq	$v0, $zero, EXEC_COMMAND_END
	# print result
	la	$a0, _LIST_RESULT
	addi	$v0, $zero, 4
	syscall
EXEC_COMMAND_END:
	pop	$ra, $a0, $a1
	jr	$ra
#=====CLEAR_COMMAND_BUF=====#	
CLEAR_COMMAND_BUF:
	push	$ra, $a0, $t0, $t1, $t2
	add	$t0, $zero, $zero
	li	$a0, COMMAND_BUF
	li	$t2, 32
CLEAR_COMMAND_BUF_LOOP:
	add	$t1, $t0, $a0
	sw	$zero, 0($t1)
	addi	$t0, $t0, 4
	bne	$t0, $t2, CLEAR_COMMAND_BUF_LOOP
	pop	$ra, $a0, $t0, $t1, $t2
	jr	$ra
	
str_compare:
	push $t0, $t1, $t2, $t3, $t4, $t5
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
		pop $t0, $t1, $t2, $t3, $t4, $t5
		jr $ra
	fat_equal_str:
		addi $v0,$zero,1
		pop $t0, $t1, $t2, $t3, $t4, $t5
		jr $ra
