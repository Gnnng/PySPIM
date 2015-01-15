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
	#srl     $k0, $k0, 2
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
INT00_SERVICE:
	li	$v0, 0xffff0100
	lw	$v0, 0($v0)
	andi	$v0, $v0, 0xff
	addi	$at, $zero, 1
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
	bne	$v0, $t0, INT08_SERVICE_END
	jal 	INT08_PRINT_CHAR
INT08_SERVICE_END:
	#return
	pop	$ra, $a0, $t0
	jr	$ra
INT08_PRINT_STRING:
	#syscall print string
	push	$ra, $v0, $a0, $a1, $t0, $t1
	#mov $t0, $a0
	add	$t0, $a0, $zero
	#li 	$v1, 0xffff0200
	#sw	$a0, 0($v1)
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
READ_COMMAND_BUF:
	push	$ra, $a0, $a1, $t0, $t1, $s0, $s1
READ_COMMAND_BUF_LOOP:
	# read keyboard hit
	# s0 = get_char, s1 = buf_len
	DEADLOOP:
	beq	$at, $zero, DEADLOOP
	add	$at, $zero, $zero
	# s0 = a0 = get_char
	add	$s0, $v0, $zero
	add	$a0, $s0, $zero
	# s1 = len
	la	$s1, COMMAND_LEN
	lw	$s1, 0($s1)
	# a1 = buf
	la	$a1, COMMAND_BUF
	# if a0 = backspace
	addi	$t0, $zero, 8
	beq	$a0, $t0, READ_COMMAND_BUF_BACKSPACE
	# if a0 = enter
	addi	$t0, $zero, 10
	beq	$a0, $t0, READ_COMMAND_BUF_ENTER
	# else
	j	READ_COMMAND_BUF_COMMON
READ_COMMAND_BUF_BACKSPACE:
	# if len==0, continue
	beq	$s0, $zero, READ_COMMAND_BUF_LOOP
	# else len--
	addi	$s1, $s1, -1
	la	$t0, COMMAND_LEN
	sw	$s1, 0($t0)
	# buf[len] = 0
	add	$a0, $zero, $zero
	add	$a1, $a1, $s1 # buf+len
	jal	Save_Byte
	# print backspace
	add	$a0, $s0, $zero
	addi	$v0, $zero, 11
	syscall
	# continue
	j	READ_COMMAND_BUF_LOOP
READ_COMMAND_BUF_ENTER:
	# buf[len] = 0
	add	$a0, $zero, $zero
	add	$a1, $a1, $s1 # buf + len
	jal	Save_Byte
	# len++
	addi	$s1, $s1, 1
	la	$t0, COMMAND_LEN
	sw	$s1, 0($t0)
	# print enter
	add	$a0, $s0, $zero
	addi	$v0, $zero, 11
	syscall
	# break
	j	READ_COMMAND_BUF_END
READ_COMMAND_BUF_COMMON:
	# if len==31, continue
	addi	$t0, $zero, 31
	beq	$s1, $t0, READ_COMMAND_BUF_LOOP
	# else buf[len] = a0
	add	$a1, $a1, $s1
	jal	Save_Byte
	# len++
	addi	$s1, $s1, 1
	la	$t0, COMMAND_LEN
	sw	$s1, 0($t0)
	# continue
	j	READ_COMMAND_BUF_LOOP
READ_COMMAND_BUF_END:
	pop	$ra, $a0, $a1, $t0, $t1, $s0, $s1
	jr	$ra
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
	sw	$v0, 0($a1)
	pop	$ra, $a0, $a1, $t0, $t1, $t2, $t3, $t4
	jr	$ra
SYS_INIT:
	#int00
	la	$t0, int00
	la	$t1, INT00_SERVICE
	sw	$t1, 0($t0)
	la	$t0, int08
	la	$t1, INT08_SERVICE
	sw	$t1, 0($t0)
	li 	$sp, 0x3ffc
	j 	SYS_INIT_BACK
CLEAR_COMMAND_BUF:
	push	$ra, $a0, $t0, $t1, $t2
	add	$t0, $zero, $zero
	la	$a0, COMMAND_BUF
	li	$t2, 32
CLEAR_COMMAND_BUF_LOOP:
	add	$t1, $t0, $a0
	sw	$zero, 0($t1)
	addi	$t0, $t0, 4
	bne	$t0, $t2, CLEAR_COMMAND_BUF_LOOP
	pop	$ra, $a0, $t0, $t1, $t2
	jr	$ra
EXEC_COMMAND_ERROR:
	la	$a0, _ERROR
	addi	$v0, $zero, 4
	syscall
EXEC_COMMAND_END:
	pop	$ra, $a0, $a1
	jr	$ra
KERNEL_INIT:
	jal	READ_COMMAND_BUF
	jal	EXEC_COMMAND
	la	$t0, COMMAND_LEN
	sw	$zero, 0($t0)
	#jal	CLEAR_COMMAND_BUF
	j	KERNEL_INIT
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

#========GET_VRAM_ADDR========#
GET_VRAM_ADDR:
	push	$ra, $a1, $a2, $t0
	#calculate vram addr
	#$a1 = X, $a2 = Y
	add	$v0, $zero, $a2
	sll	$v0, $v0, 7
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
#========SHOW_CHAR========#
SHOW_CHAR:
	#a0 ascii, a1 X, a2 Y
	push	$ra, $a0, $t0 
	#offset
	#li	$t0, 0x00070000
	#or 	$a0, $a0, $t0
	sll	$a0, $a0, 3
	jal	GET_VRAM_ADDR
	add	$t0, $zero, $v0
	#save word
	sw	$a0, 0($t0)
	pop	$ra, $a0, $t0
	#return
	jr	$ra
#=====EXEC_COMMAND=====#
EXEC_COMMAND:
	push	$ra, $a0, $a1
	# compare
EXEC_COMMAND_CMP_LS:
	la	$a0, COMMAND_BUF
	la	$a1, _LIST
	jal	str_compare
	# if !compare return 0
	beq	$v0, $zero, EXEC_COMMAND_CMP_EDIT
	# print result
	la	$a0, _LIST_RESULT
	addi	$v0, $zero, 4
	syscall
	j	EXEC_COMMAND_END
EXEC_COMMAND_CMP_EDIT:
	la	$a0, COMMAND_BUF
	la	$a1, _EDIT
	jal	str_compare
	# if !compare return 0
	beq	$v0, $zero, EXEC_COMMAND_CMP_RUN
	# print result
	la	$a0, _EDIT_RESULT
	addi	$v0, $zero, 4
	syscall
	j	EXEC_COMMAND_END
EXEC_COMMAND_CMP_RUN:
	la	$a0, COMMAND_BUF
	la	$a1, _RUN
	jal	str_compare
	# if !compare return 0
	beq	$v0, $zero, EXEC_COMMAND_CHAT
	# print result
	la	$a0, _RUN_RESULT
	addi	$v0, $zero, 4
	syscall
	j	EXEC_COMMAND_END
EXEC_COMMAND_CHAT:
	la	$a0, COMMAND_BUF
	la	$a1, _CHAT
	jal	str_compare
	# if !compare return 0
	beq	$v0, $zero, EXEC_COMMAND_ERROR
	# print result
	la	$a0, _CHAT_RESULT
	addi	$v0, $zero, 4
	syscall
	j	EXEC_COMMAND_END
EXEC_COMMAND_ERROR:
	la	$a0, _ERROR
	addi	$v0, $zero, 4
	syscall
	j	EXEC_COMMAND_END
EXEC_COMMAND_END:
	pop	$ra, $a0, $a1
	jr	$ra
	
.data 0x00000900
	WEIGHT:	.word	40
	HEIGHT:	.word	30
	hi:	.asciiz	"Hello World\n"
	_DIR:	.asciiz "root"
	_ARROW:	.asciiz ">"
	_LIST:	.asciiz "ls"
	_EDIT: .asciiz "edit"
	_RUN:	.asciiz	"run"
	_CHAT:	.asciiz	"chat"
	_LIST_RESULT:	.asciiz "list root\n"
	_EDIT_RESULT:	.asciiz	"edit text\n"
	_RUN_RESULT:	.asciiz	"run program\n"
	_CHAT_RESULT:	.asciiz	"chat with me\n"
	_ERROR:	.asciiz	"error command!\n"
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
