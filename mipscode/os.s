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
	push $ra
	#addi	$sp, $sp, -4
	#sw	$ra, 0($sp)
	#Status 2~6 bit represents interrupt value
	mfc0	$k0, $13 #$12: Status
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
	#keyboard hit
	push $ra, $t0, $t1, $t2, $a0
	#load scanning code
	lui	$t0, 0xffff
	ori	$t0, $t0, 0x0100
	lw	$t0, 0($t0)
	#put scanning code into the buffer
	#la	$t1, KeyBoard_head
	#lw	$t1, 0($t1)
	#la	$t2, KeyBoard_tail
	#lw	$t2, 0($t2)
	#if (tail+1) % len == head then return
	#else put char in tail
	#addi	$t3, $t2, 1   
	#andi	$t3, $t3, 0x7	#$t3 = ($t2 + 1) % buf_len
	#beq	$t1, $t3, INT00_SERVICE_END	#$t3 != head
	#la	$t1, KeyBoard_buf
	#add	$t1, $t2, $t1
	#sw	$t0, 0($t1)	#write buf
	#la	$t2, KeyBoard_tail	#write tail
	#sw	$t3, 0($t2)
	add	$a0, $zero, $t0
	la	$t1, KeyBoard_buf
	sw	$a0, 0($t1)
	addi	$t0, $zero, 1
	la	$t1, KeyBoard_buf_notNull
	sw	$t0, 0($t1)
	#jal	INT08_PRINT_CHAR
INT00_SERVICE_END:
	#return
	pop	$ra, $t0, $t1, $t2, $a0
	jr	$ra
INT08_SERVICE:
	#syscall
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
	pop $ra, $v0, $a0, $t0
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
	#jump to end
	j	INT08_PRINT_CHAR_MOVE_X
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
INT08_READ_CHAR_LOOP:
	la	$t0, KeyBoard_buf_notNull
	lw	$t0, 0($t0)
	beq	$t0, $zero, INT08_READ_CHAR_LOOP
	la	$t1, KeyBoard_buf
	lw	$v0, 0($t1)
	la	$t0, KeyBoard_buf_notNull
	sw	$zero, 0($t0)
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
	KeyBoard_buf_notNull:	.word	0
	#KeyBoard_head:	.word	0
	#KeyBoard_tail:	.word	0
.text 0x00001000
#Kernel initialization begin
KERNEL_INIT:
	addi	$v0, $zero, 4
	la	$a0, hi
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
	push	$ra, $a0, $t0, $t1 
	sll	$a0, $a0, 3
	#offset
	jal	GET_VRAM_ADDR
	add	$t0, $zero, $v0
	#save word
	sw	$a0, 0($t0)
	pop	$ra, $a0, $t0, $t1
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
