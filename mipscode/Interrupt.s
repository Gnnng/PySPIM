#############################
#Date: 2014/10/29           #
#Auth: Bai Long             #
#Func: OS on System         #
#############################
.text 0x00000000
#interrupt address initialization
	#int00
	#la	$t0, int00
	#la	$t1, INT00_SERVICE
	#sw	$t1, 0($t0)
	#int08
	#la	$t0, int08
	#la	$t1, INT08_SERVICE
	#sw	$t1, 0($t0)
#jump to kernel initialization
	j	KERNEL_INIT
.text 0x00000004
#interrupt handler
INT_HANDLER:
	#use $k0, $k1
	#$12: Status, $13: Cause, $14: EPC
	#push $ra
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	#Status 2~6 bit represents interrupt value
	mfc0	$k0, $13 #$12: Status
	andi	$k0, $k0, 0x007C #2~6 bits
	addi	$k0, $k0, 0x0100 #jump to interrupt
	lw	$k0, 0($k0)	 #get the address
	jalr	$k0, $ra
	eret
.data 0x00000100
#interrupt vector table
#init 0，everytime the program runs，load it
	int00:	.word	INT00_SERVICE #all external interrupt
	int08:	.word	INT08_SERVICE #syscall
.text 0x00000200
#interrupt services
INT_SERVICES:
INT00_SERVICE:
INT08_SERVICE:
	#syscall
	#push $ra, $v0, $a0, $t0
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$v0, 4($sp)
	sw	$a0, 8($sp)
	sw	$t0, 12($sp)
	#print_string
	addi	$t0, $zero, 4
	beq	$v0, $t0, INT08_PRINT_STRING
	#print_char
	addi	$t0, $zero, 11
	beq	$v0, $t0, INT08_PRINT_CHAR
	#pop $ra, $v0, $a0, $t0
	lw	$ra, 0($sp)
	lw	$v0, 4($sp)
	lw	$a0, 8($sp)
	lw	$t0, 12($sp)
	addi	$sp, $sp, 16
	#return
	jr	$ra
INT08_PRINT_STRING:
	#syscall print string
	#push $ra, $v0, $a0, $t0, $a1, $a2, $t1
	addi	$sp, $sp, -28
	sw	$ra, 0($sp)
	sw	$v0, 4($sp)
	sw	$a0, 8($sp)
	sw	$t0, 12($sp)
	sw	$a1, 16($sp)
	sw	$a2, 20($sp)
	sw	$t1, 24($sp)
	#jal SHOW_CHAR
	add	$t0, $a0, $zero
PRINT_STRING_LOOP:
	lw	$a0, 0($t0) #a0 ascii，t0 address
	beq	$a0, $zero, PRINT_STRING_END_LOOP
	#Cursor
	lui	$t1, 0xffff
	ori	$t1, 0x0000
	lw	$a1, 0($t1) #X
	lw	$a2, 4($t1) #Y
	jal	SHOW_CHAR
	addi	$t0, $t0, 1
	#Cursor X+1
	addi	$a1, $a1, 1
	sw	$a1, 0($t1)
PRINT_STRING_END_LOOP:
	#pop $ra, $v0, $a0, $t0
	lw	$ra, 0($sp)
	lw	$v0, 4($sp)
	lw	$a0, 8($sp)
	lw	$t0, 12($sp)
	lw	$a1, 16($sp)
	lw	$a2, 20($sp)
	lw	$t1, 24($sp)
	addi	$sp, $sp, 28
	#return
	jr	$ra
SHOW_CHAR:
	#a0 ascii，a1 X，a2 Y
	addi	$sp, $sp, -8
	sw	$t0, 0($sp)
	sw	$a0, 4($sp)
	sll	$a0, $a0, 3
	#offset
	add	$t0, $zero, $a2
	sll	$t0, $t0, 7
	add	$t0, $t0, $a1
	sll	$t0, $t0, 2
	#save word
	lui	$t0, 0x1000 
	sw	$a0, 0($t0)
	#pop
	lw	$t0, 0($sp)
	lw	$a0, 4($sp)
	addi	$sp, $sp, 8
	#return
	jr	$ra
INT08_PRINT_CHAR:
	#push $ra, $v0, $a0, $a1, $a2, $t0
	addi	$sp, $sp, -24
	sw	$ra, 0($sp)
	sw	$v0, 4($sp)
	sw	$a0, 8($sp)
	sw	$a1, 12($sp)
	sw	$a2, 16($sp)
	sw	$t0, 20($sp)
	#a0 ascii，a1 X，a2 Y
	#Cursor
	lui	$t0, 0xffff
	ori	$t0, 0x0000
	lw	$a1, 0($t0) #X
	lw	$a2, 4($t0) #Y
	jal	SHOW_CHAR
	#pop
	lw	$ra, 0($sp)
	lw	$v0, 4($sp)
	lw	$a0, 8($sp)
	lw	$a1, 12($sp)
	lw	$a2, 16($sp)
	lw	$t0, 20($sp)
	addi	$sp, $sp, 24
	#return
	jr	$ra
#.data
#	CRTadr	.word
#	WEIGHT	.word
#	HEIGHT	.word
#	CursorX	.word
#	CursorY	.word
.data
	hi .asciiz "hello world!"
.text 0x00001000
#Kernel initialization begin
KERNEL_INIT:
	la	$a0, hi
	addi	$v0, $zero, 8
	syscall