.data
	_DIR	.asciiz	"root>"
	_NOTEPAD	.asciiz	"notepad"
	_ADD	.asciiz "add"
.text
COMMANDER:
	push	$ra, $a0, $a1
COMMANDER_LOOP:
	#print "root>"
	la	$a0, _DIR
	addi	$v0, $zero, 4
	syscall
	#read string
	addi	$v0, $zero, 8
	syscall
	#compare
COM_NOTE_PAD:
	add	$a0, $zero, $v0
	la	$a1, _NOTEPAD
	jal	COMPARE_STRING
	beq	$v0, $zero, COM_ADD
	jal	NOTEPAD
COM_ADD:
	la	$a1, _ADD
	jal	COMPARE_STRING
	beq	$v0, $zero, COMMANDER_LOOP_END
	jal	ADD
COMMANDER_LOOP_END:
	j	COMMANDER_LOOP
#=====COMPARE_STRING=====#
COMPARE_STRING:
	push	$ra, $a0, $a1, $t0, $t1
	addi	$v0, $zero, 1
COMPARE_STRING_LOOP:
	lw	$t0, 0($a0)
	lw	$t1, 0($a1)
	bne	$t0, $t1, NOT_EQUAL
	beq	$t0, $zero, COMPARE_STRING_LOOP_END
	beq	$t1, $zero, COMPARE_STRING_LOOP_END
	addi	$a0, $a0, 1
	addi	$a1, $a1, 1
	j	COMPARE_STRING_LOOP
NOT_EQUAL:
	addi	$v0, $zero, 0
	j	COMPARE_STRING_LOOP_END
COMPARE_STRING_LOOP_END:
	push	$ra, $a0, $a1, $t0, $t1
	jr	$ra




