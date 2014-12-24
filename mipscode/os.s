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
	sw	$ra, 0($sp)
	#Status 2~6 bit represents interrupt value
	mfc0	$k0, $13 #$12: Status
	andi	$k0, $k0, 0x007C #2~6 bits
	addi	$k0, $k0, 0x0100 #jump to interrupt
	lw	$k0, 0($k0)	 #get the address
	jalr	$k0, $ra
	lw 	$ra, 0($sp)
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
	#push $a, $a0, $t0
	#since read char is returned in $v0, so we shouldn't push $v0
	addi	$sp, $sp, -12
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$t0, 8($sp)
	#print_string
	addi	$t0, $zero, 4
	beq	$v0, $t0, INT08_PRINT_STRING
	#print_char
	addi	$t0, $zero, 11
	beq	$v0, $t0, INT08_PRINT_CHAR
	#read_char
	#addi	$t0, $zero, 12
	#beq	$v0, $t0, INT08_READ_CHAR
	#pop $ra, $a0, $t0
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$t0, 8($sp)
	addi	$sp, $sp, 12
	#return
	jr	$ra
INT08_PRINT_STRING:
	#syscall print string
	#push $ra, $v0, $a0, $t0, $a1, $a2, $t1
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$v0, 4($sp)
	sw	$a0, 8($sp)
	sw	$t0, 12($sp)
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
	#pop $ra, $v0, $a0, $t0
	lw	$ra, 0($sp)
	lw	$v0, 4($sp)
	lw	$a0, 8($sp)
	lw	$t0, 12($sp)
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
	lw	$a1, 0($t0) #X
	lw	$a2, 4($t0) #Y
	#if a0 = enter
	addi	$t1, $zero, 10
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
	#if Full Page(Y = HEIGHT), scroll page
	la	$t1, HEIGHT
	lw	$t1, 0($t1)
	bne	$a2, $t1, INT08_PRINT_CHAR_END
	#jal	SCROLL_PAGE
	#last row
	#addi	$a2, $a2, -1
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
.data 0x00000900
	WEIGHT:	.word	40
	HEIGHT:	.word	30
	hi:	.asciiz	"hello world! hello world! hello world! hello world! hello world! hello world!"
.text 0x00001000
#Kernel initialization begin
KERNEL_INIT:
	la	$a0, hi
	li	$v0, 4
	syscall
DEAD_LOOP:
	j	DEAD_LOOP
#========global functions========#
Load_Byte:
	#push $ra, $a0, $t0, $t1
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$t0, 8($sp)
	sw	$t1, 12($sp)
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
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$t0, 8($sp)
	lw	$t1, 12($sp)
	addi	$sp, $sp, 16
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
	jal	GET_VRAM_ADDR
	add	$t0, $zero, $v0
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
GET_VRAM_ADDR:
	addi	$sp, $sp, -20
	#push $ra, $a1, $a2, $t0, $v0
	sw	$ra, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$t0, 12($sp)
	#calculate vram addr
	#$a1 = X, $a2 = Y
	add	$v0, $zero, $a2
	sll	$v0, $v0, 7
	add	$v0, $v0, $a1
	sll	$v0, $v0, 2
	lui $t0, 0x1000 
	or  $v0, $v0, $t0
	# return $v0
	lw	$ra, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$t0, 12($sp)
	addi	$sp, $sp, 20
	jr	$ra
<<<<<<< HEAD
PAGE_SCROLL:
	addi	$sp, $sp, -24
=======

PAGE_SCROLL:
	addi	$sp, $sp, -28
>>>>>>> 8098cd74c51e95e6c5610ff85e5098c393f4b0b8
	#push $ra, $a1, $a2, $t0, $t1, $t2
	sw	$ra, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$t0, 12($sp)
	sw	$t1, 16($sp)
	sw	$t2, 20($sp)
<<<<<<< HEAD
=======
	sw	$t3, 24($sp)
>>>>>>> 8098cd74c51e95e6c5610ff85e5098c393f4b0b8
	# load X, Y
	la	$t1, WEIGHT
	lw	$t1, 0($t1)
	la	$t2, HEIGHT
	lw	$t2, 0($t2)
<<<<<<< HEAD
=======
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
	bne	$a1, $t1, PAGE_SCROLL_LOOP1
	bne	$a2, $t2, PAGE_SCROLL_LOOP2
>>>>>>> 8098cd74c51e95e6c5610ff85e5098c393f4b0b8
	#return
	lw	$ra, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$t1, 16($sp)
	lw	$t2, 20($sp)
<<<<<<< HEAD
	addi	$sp, $sp, 24
=======
	lw	$t3, 24($sp)
	addi	$sp, $sp, 28
>>>>>>> 8098cd74c51e95e6c5610ff85e5098c393f4b0b8
	jr	$ra
	