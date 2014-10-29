#############################
#Date: 2014/10/29           #
#Auth: Bai Long             #
#Func: OS and App on System #
#############################

#===========Data============#
.data
WIDTH .2byte 80	#columns
ROW .2byte 25	#rows
CurCOL .2byte 0	#cursor column
CurROW .2byte 0 #cursor row

#===========Text============#
.text

#####syscall
DisplayChar:
	# push $a1, $s0, $t0, $t1
	addi	$sp, $sp, -16
	sw	$a1, 0($sp)
	sw	$s0, 4($sp)
	sw	$t0, 8($sp)
	sw	$t1, 12($sp)
	# load Width
	la	$t0, WIDTH
	lh	$s0, 0($t0)
	add	
PrintChar:
	# push $ra, $a0, $a1, $a2, $t0
	addi	$sp, $sp, -20
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	sw	$t0, 16($sp)
	# load CurCOL, CurROW
	la	$t0, CurROW
	lh	$a1, CurROW
	la	$t0, CurCOL
	lh	$a2, CurCOL
	li	$t0, 13 #ENTER
	# if input char $a0 is not ENTER
	beq $a0, $t0, NextLine
	jal DisplayChar
	
