#############################
#Date: 2014/10/29           #
#Auth: Bai Long             #
#Func: OS and App on System #
#############################

#===========Data============#
.data
CRTadr .4byte
#CRTstart .4byte
WIDTH .4byte 80
HEIGHT .4byte 25
CurX .4byte 0
CurY .4byte 0
SCRmod .4byte 0 #Text(0)/vga(1) mode
#
hello .asciiz "Hello world!"
#===========Text============#
.text
MAIN:
	la	$a0, hello
	addi	$v0, $zero, 4
	j	SYSCALL
	j	END
#####syscall
#syscall
SYSCALL:
	# push ra, a0, t0
	addi	$sp, $sp, -12
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$t0, 8($sp)
	# init t0
	add	$t0, $zero, $zero
	addi	$t0, $t0, 4
CheckPrintString:
	bne	$v0, $t0, Syscall_END
	j	PrintString
Syscall_END
	jr	$ra
#syscall - DisplayChar
DisplayChar:
	# push $a0, $s0, $t0, $t1, $t2
	# 4byte: 2byte Y, 2byte X
	addi	$sp, $sp, -20
	sw	$a0, 0($sp)	# ch
	sw	$s0, 4($sp)
	sw	$t0, 8($sp)	# x
	sw	$t1, 12($sp)	# y
	sw	$t2, 16($sp)
	#s0 = Y<<128 + X
	sll	$s0, $t1, 8
	# CRTadr+$s0 is the address where we fill in $a0
	or	$s0, $s0, $t0
	la	$t2, CRTadr
	add	$s0, $s0, $t2
	sw	$a0, 0($s0)
	# bring back data
	lw	$a0, 0($sp)
	lw	$s0, 4($sp)
	lw	$t0, 8($sp)
	lw	$t1, 12($sp)
	lw	$t2, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#syscall - PrintChar
PrintChar:
	# push $ra, $a0, $a1, $a2, $t0, $t1
	addi	$sp, $sp, -24
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	sw	$t0, 16($sp)
	sw	$t1, 20($sp)
	# load CurX in $a1, CurY in $a2
	la	$t0, CurX
	lw	$a1, 0($t0)
	la	$t0, CurY
	lw	$a2, 0($t0)
	# if input char $a0 is not ENTER, DisplayChar
	li	$t0, 13 #ENTER
	beq $a0, $t0, PrintChar_NextLine #move cursor to next line
	#set t0 = X, t1 = Y
	add	$t0, $zero, $a1
	add	$t1, $zero, $a2
	jal DisplayChar
	# X+1
	addi	$a1, $a1, 1
	#load WIDTH
	la	$t0, WIDTH
	lw	$t0, 0($t0)
	#if X>=WIDTH, next line
	slt	$at, $a1, $t0
	bne	$at, $zero, PrintChar_NextLine
PrintChar_NextLine:
	#load HEIGHT
	la	$t0, HEIGHT
	lw	$t0, 0($t0)
	#Y+1 X=0
	addi	$a2, $a2, 1
	add	$a1, $zero, $zero
	#if Y>=HEIGHT, scroll up, Y-1
	slt	$at, $a2, $t0
	addi	$a2, $a2, -1
	#bne	$at, $zero, SCROLLUP
	#save Cursor
	la	$t0, CurX
	sw	$a1, 0($t0)
	la	$t0, CurY
	sw	$a2, 0($t0)
PrintChar_End:
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$a1, 8($sp)
	lw	$a2, 12($sp)
	lw	$t0, 16($sp)
	lw	$t0, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra
#syscall - PrintString
PrintString:
	#push $ra, $a0, $t0, $t1
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$t0, 8($sp)
	sw	$t1, 12($sp)
	#t0 = a0
	add	$t0, $a0, $zero
PrintString_LOOP:
	lw	$t1, 0($t0)
	beq	$t1, $zero, PrintString_End_LOOP
	#a0 = t1
	add	$a0, $t1, $zero
	PrintChar
	addi	$t0, $t0, 4
	j	PrintString_LOOP
PrintString_End_LOOP:
	#pop
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	lw	$t0, 8($sp)
	lw	$t1, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra
	
#============END===========#
END:
