#############################
#Date: 2014/10/29           #
#Auth: Bai Long             #
#Func: OS on System         #
#############################
.text 0x00000000
#interrupt address initialization
	li  $sp, 0xfffc
	#int00
	la	$t0, int00
	la	$t1, INT00_SERVICE
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
	#push $ra
	addi	$sp, $sp, -4
	sw		$ra, 0($sp)
	#Status 2~6 bit represents interrupt value
	mfc0	$k0, $13 #$12: Status
	andi	$k0, $k0, 0x007C #2~6 bits
	addi	$k0, $k0, 0x0100 #jump to interrupt
	lw		$k0, 0($k0)	 #get the address
	jalr	$k0, $ra
	lw 		$ra, 0($sp)
	addi 	$sp, $sp, 4
	eret
.data 0x00000100
#interrupt vector table
#init 0, everytime the program runs, load it
	int00:	.word	0 #all external interrupt
			.word 	0
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
INT00_SERVICE: #external device
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
	#$t0 = $a0
	add	$t0, $a0, $zero
PRINT_STRING_LOOP:
	lw	$a0, 0($t0) #a0 ascii, t0 address
	srl	$a0, $a0, 24
	beq	$a0, $zero, PRINT_STRING_END_LOOP
	jal	INT08_PRINT_CHAR
	addi	$t0, $t0, 1
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
	#a0 ascii, a1 X, a2 Y
	#push $t0, $a0
	addi	$sp, $sp, -16
	sw	$t0, 0($sp)
	sw	$a0, 4($sp)
	sw 	$t1, 8($sp)
	sw 	$ra, 12($sp)
	sll	$a0, $a0, 3
	#offset
	add	$t0, $zero, $a2
	sll	$t0, $t0, 7
	add	$t0, $t0, $a1
	sll	$t0, $t0, 2
	lui $t1, 0x1000 
	or  $t0, $t0, $t1
	#save word
	sw	$a0, 0($t0)
	#pop $t0, $a0
	lw	$t0, 0($sp)
	lw	$a0, 4($sp)
	lw 	$t1, 8($sp)
	lw 	$ra, 12($sp)
	addi	$sp, $sp, 16
	#return
	jr	$ra
INT08_PRINT_CHAR:
	#push $ra, $v0, $a0, $a1, $a2, $t0, $t1
	addi	$sp, $sp, -28
	sw	$ra, 0($sp)
	sw	$v0, 4($sp)
	sw	$a0, 8($sp)
	sw	$a1, 12($sp)
	sw	$a2, 16($sp)
	sw	$t0, 20($sp)
	sw	$t1, 24($sp)
	#a0 ascii, a1 X, a2 Y
	#Cursor X, Y
	lui	$t0, 0xffff
	#ori	$t0, $t0, 0x0000
	lw	$a1, 0($t0) #X
	lw	$a2, 4($t0) #Y
	#if a0 = enter
	addi	$t1, $zero, 13
	bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
	add	$a1, $zero, $zero
	addi	$a2, $a2, 1
	#jump to end
	j	INT08_PRINT_CHAR_END
INT08_PRINT_CHAR_EXEC:
	jal	SHOW_CHAR
	#X+1
	addi	$a1, $a1, 1
	#if X=WEIGHT
	la	$t1, WEIGHT
	lw	$t1, 0($t1)
	bne	$a1, $t1, INT08_PRINT_CHAR_END
	add	$a1, $zero, $zero
	addi	$a2, $a2, 1
	#if Full Page, scroll page
	#...
INT08_PRINT_CHAR_END:
	#save back X, Y
	sw	$a1, 0($t0)
	sw	$a2, 4($t0)
	#pop $ra, $v0, $a0, $a1, $a2, $t0
	lw	$ra, 0($sp)
	lw	$v0, 4($sp)
	lw	$a0, 8($sp)
	lw	$a1, 12($sp)
	lw	$a2, 16($sp)
	lw	$t0, 20($sp)
	lw	$t1, 24($sp)
	addi	$sp, $sp, 28
	#return
	jr	$ra
#.data
#	CRTadr	.word
#	WEIGHT	.word
#	HEIGHT	.word
#	CursorX	.word
#	CursorY	.word
.data 0x00000900
	WEIGHT:	.word	40
	HEIGHT:	.word	25
	hi:	.asciiz	"hello world!"
	
.text 0x00001000
#Kernel initialization begin
KERNEL_INIT:
	la	$a0, hi
	li  $v0, 4
	syscall
DEAD_LOOP:
	j   DEAD_LOOP
