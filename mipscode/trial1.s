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
INT00_SERVICE:
	li	$v0, 0xffff0100
	lw	$v0, 0($v0)
	andi	$v0, $v0, 0xff
	addi	$at, $zero, 1
	jr	$ra
READ_COMMAND_BUF:
	push	$ra, $a0, $a1, $t0, $t1, $s0, $s1
READ_COMMAND_BUF_LOOP:
	# read keyboard hit
	# s0 = get_char, s1 = buf_len
	DEADLOOP:
	beq	$at, $zero, DEADLOOP
	add	$at, $zero, $zero
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
	j	READ_COMMAND_BUF_LOOP
READ_COMMAND_BUF_ENTER:
	#buf[len] = 0
	la	$a1, COMMAND_BUF
	add	$a1, $a1, $s0
	add	$a0, $zero, $zero
	jal	Save_Byte
READ_COMMAND_BUF_END:
	#syscall
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
	#int08
	sw	$t1, 0($t0)
	li 	$sp, 0x3ffc
	li	$t0, 0x80000000
	mtc0	$11, $t0
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
KERNEL_INIT:
	jal	READ_COMMAND_BUF
	jal	CLEAR_COMMAND_BUF
	la	$t0, COMMAND_LEN
	sw	$zero, 0($t0)
	j	KERNEL_INIT

.data
	_LIST_RESULT:	.asciiz "list root\n"
	WEIGHT:	.word	40
	HEIGHT:	.word	30
	hi:	.asciiz	"Hello World\n"
	_DIR:	.asciiz "root"
	_ARROW:	.asciiz ">"
	_LIST:	.asciiz "ls"
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
			