========program start=======
#############################
======NOW instruction======
#############################
===========================
#Date: 2014/10/29           #
======NOW instruction======
#Date: 2014/10/29           #
===========================
#Auth: Bai Long             #
======NOW instruction======
#Auth: Bai Long             #
===========================
#Func: OS on System         #
======NOW instruction======
#Func: OS on System         #
===========================
#############################
======NOW instruction======
#############################
===========================
.text 0x00000000
======NOW instruction======
.text 0x00000000
===========================
append
#interrupt address initialization
======NOW instruction======
#interrupt address initialization
===========================
li  $sp, 0xfffc
======NOW instruction======
li  $sp, 0xfffc
===========================
no temp
instruction init
entered add_instruction
oins:li  $sp, 0xfffc
not matched
nolabel_ins:li  $sp, 0xfffc
===entered add_content===
now label: None
add!
#int00
======NOW instruction======
#int00
===========================
la	$t0, int00
======NOW instruction======
la	$t0, int00
===========================
no temp
instruction init
entered add_instruction
oins:la	$t0, int00
not matched
nolabel_ins:la	$t0, int00
===entered add_content===
now label: None
add!
la	$t1, INT00_SERVICE
======NOW instruction======
la	$t1, INT00_SERVICE
===========================
no temp
instruction init
entered add_instruction
oins:la	$t1, INT00_SERVICE
not matched
nolabel_ins:la	$t1, INT00_SERVICE
===entered add_content===
now label: None
add!
sw	$t1, 0($t0)
======NOW instruction======
sw	$t1, 0($t0)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t1, 0($t0)
not matched
nolabel_ins:sw	$t1, 0($t0)
===entered add_content===
now label: None
add!
#int08
======NOW instruction======
#int08
===========================
la	$t0, int08
======NOW instruction======
la	$t0, int08
===========================
no temp
instruction init
entered add_instruction
oins:la	$t0, int08
not matched
nolabel_ins:la	$t0, int08
===entered add_content===
now label: None
add!
la	$t1, INT08_SERVICE
======NOW instruction======
la	$t1, INT08_SERVICE
===========================
no temp
instruction init
entered add_instruction
oins:la	$t1, INT08_SERVICE
not matched
nolabel_ins:la	$t1, INT08_SERVICE
===entered add_content===
now label: None
add!
sw	$t1, 0($t0)
======NOW instruction======
sw	$t1, 0($t0)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t1, 0($t0)
not matched
nolabel_ins:sw	$t1, 0($t0)
===entered add_content===
now label: None
add!
#jump to kernel initialization
======NOW instruction======
#jump to kernel initialization
===========================
j	KERNEL_INIT
======NOW instruction======
j	KERNEL_INIT
===========================
no temp
instruction init
entered add_instruction
oins:j	KERNEL_INIT
not matched
nolabel_ins:j	KERNEL_INIT
===entered add_content===
now label: None
add!
.text 0x00000080
======NOW instruction======
.text 0x00000080
===========================
append
#interrupt handler
======NOW instruction======
#interrupt handler
===========================
INT_HANDLER:
======NOW instruction======
INT_HANDLER:
===========================
no temp
instruction init
entered add_instruction
oins:INT_HANDLER:
matched

nolabel_ins:
===entered add_content===
now label: ['INT_HANDLER']
#use $k0, $k1
======NOW instruction======
#use $k0, $k1
===========================
#$12: Status, $13: Cause, $14: EPC
======NOW instruction======
#$12: Status, $13: Cause, $14: EPC
===========================
#push $ra
======NOW instruction======
#push $ra
===========================
addi	$sp, $sp, -4
======NOW instruction======
addi	$sp, $sp, -4
===========================
have temp
entered add_instruction
oins:addi	$sp, $sp, -4
not matched
nolabel_ins:addi	$sp, $sp, -4
===entered add_content===
now label: ['INT_HANDLER']
add!
sw		$ra, 0($sp)
======NOW instruction======
sw		$ra, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw		$ra, 0($sp)
not matched
nolabel_ins:sw		$ra, 0($sp)
===entered add_content===
now label: None
add!
#Status 2~6 bit represents interrupt value
======NOW instruction======
#Status 2~6 bit represents interrupt value
===========================
mfc0	$k0, $13 #$12: Status
======NOW instruction======
mfc0	$k0, $13 #$12: Status
===========================
no temp
instruction init
entered add_instruction
oins:mfc0	$k0, $13 #$12: Status
not matched
nolabel_ins:mfc0	$k0, $13 #$12: Status
===entered add_content===
now label: None
final content:mfc0	$k0, $13 
add!
andi	$k0, $k0, 0x007C #2~6 bits
======NOW instruction======
andi	$k0, $k0, 0x007C #2~6 bits
===========================
no temp
instruction init
entered add_instruction
oins:andi	$k0, $k0, 0x007C #2~6 bits
not matched
nolabel_ins:andi	$k0, $k0, 0x007C #2~6 bits
===entered add_content===
now label: None
final content:andi	$k0, $k0, 0x007C 
add!
addi	$k0, $k0, 0x0100 #jump to interrupt
======NOW instruction======
addi	$k0, $k0, 0x0100 #jump to interrupt
===========================
no temp
instruction init
entered add_instruction
oins:addi	$k0, $k0, 0x0100 #jump to interrupt
not matched
nolabel_ins:addi	$k0, $k0, 0x0100 #jump to interrupt
===entered add_content===
now label: None
final content:addi	$k0, $k0, 0x0100 
add!
lw		$k0, 0($k0)	 #get the address
======NOW instruction======
lw		$k0, 0($k0)	 #get the address
===========================
no temp
instruction init
entered add_instruction
oins:lw		$k0, 0($k0)	 #get the address
not matched
nolabel_ins:lw		$k0, 0($k0)	 #get the address
===entered add_content===
now label: None
final content:lw		$k0, 0($k0)	 
add!
jalr	$k0, $ra
======NOW instruction======
jalr	$k0, $ra
===========================
no temp
instruction init
entered add_instruction
oins:jalr	$k0, $ra
not matched
nolabel_ins:jalr	$k0, $ra
===entered add_content===
now label: None
add!
lw 		$ra, 0($sp)
======NOW instruction======
lw 		$ra, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw 		$ra, 0($sp)
not matched
nolabel_ins:lw 		$ra, 0($sp)
===entered add_content===
now label: None
add!
addi 	$sp, $sp, 4
======NOW instruction======
addi 	$sp, $sp, 4
===========================
no temp
instruction init
entered add_instruction
oins:addi 	$sp, $sp, 4
not matched
nolabel_ins:addi 	$sp, $sp, 4
===entered add_content===
now label: None
add!
eret
======NOW instruction======
eret
===========================
no temp
instruction init
entered add_instruction
oins:eret
not matched
nolabel_ins:eret
===entered add_content===
now label: None
add!
.data 0x00000100
======NOW instruction======
.data 0x00000100
===========================
append
#interrupt vector table
======NOW instruction======
#interrupt vector table
===========================
#init 0, everytime the program runs, load it
======NOW instruction======
#init 0, everytime the program runs, load it
===========================
int00:	.word	0 #all external interrupt
======NOW instruction======
int00:	.word	0 #all external interrupt
===========================
instruction init
entered add_instruction
oins:int00:	.word	0 #all external interrupt
matched
	.word	0 #all external interrupt
nolabel_ins:	.word	0 #all external interrupt
===entered add_content===
now label: ['int00']
final content:	.word	0 
label: ['int00']
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
int08:	.word	0 #syscall
======NOW instruction======
int08:	.word	0 #syscall
===========================
instruction init
entered add_instruction
oins:int08:	.word	0 #syscall
matched
	.word	0 #syscall
nolabel_ins:	.word	0 #syscall
===entered add_content===
now label: ['int08']
final content:	.word	0 
label: ['int08']
.word 	0
======NOW instruction======
.word 	0
===========================
instruction init
entered add_instruction
oins:.word 	0
not matched
nolabel_ins:.word 	0
===entered add_content===
now label: None
label: None
.text 0x00000200
======NOW instruction======
.text 0x00000200
===========================
append
#interrupt services
======NOW instruction======
#interrupt services
===========================
INT_SERVICES:
======NOW instruction======
INT_SERVICES:
===========================
no temp
instruction init
entered add_instruction
oins:INT_SERVICES:
matched

nolabel_ins:
===entered add_content===
now label: ['INT_SERVICES']
INT00_SERVICE: #external device
======NOW instruction======
INT00_SERVICE: #external device
===========================
have temp
entered add_instruction
oins:INT00_SERVICE: #external device
matched
#external device
nolabel_ins:#external device
===entered add_content===
now label: ['INT_SERVICES', 'INT00_SERVICE']
final content:
INT08_SERVICE:
======NOW instruction======
INT08_SERVICE:
===========================
have temp
entered add_instruction
oins:INT08_SERVICE:
matched

nolabel_ins:
===entered add_content===
now label: ['INT_SERVICES', 'INT00_SERVICE', 'INT08_SERVICE']
#syscall
======NOW instruction======
#syscall
===========================
#push $ra, $v0, $a0, $t0
======NOW instruction======
#push $ra, $v0, $a0, $t0
===========================
addi	$sp, $sp, -16
======NOW instruction======
addi	$sp, $sp, -16
===========================
have temp
entered add_instruction
oins:addi	$sp, $sp, -16
not matched
nolabel_ins:addi	$sp, $sp, -16
===entered add_content===
now label: ['INT_SERVICES', 'INT00_SERVICE', 'INT08_SERVICE']
add!
sw	$ra, 0($sp)
======NOW instruction======
sw	$ra, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$ra, 0($sp)
not matched
nolabel_ins:sw	$ra, 0($sp)
===entered add_content===
now label: None
add!
sw	$v0, 4($sp)
======NOW instruction======
sw	$v0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$v0, 4($sp)
not matched
nolabel_ins:sw	$v0, 4($sp)
===entered add_content===
now label: None
add!
sw	$a0, 8($sp)
======NOW instruction======
sw	$a0, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a0, 8($sp)
not matched
nolabel_ins:sw	$a0, 8($sp)
===entered add_content===
now label: None
add!
sw	$t0, 12($sp)
======NOW instruction======
sw	$t0, 12($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t0, 12($sp)
not matched
nolabel_ins:sw	$t0, 12($sp)
===entered add_content===
now label: None
add!
#print_string
======NOW instruction======
#print_string
===========================
addi	$t0, $zero, 4
======NOW instruction======
addi	$t0, $zero, 4
===========================
no temp
instruction init
entered add_instruction
oins:addi	$t0, $zero, 4
not matched
nolabel_ins:addi	$t0, $zero, 4
===entered add_content===
now label: None
add!
beq	$v0, $t0, INT08_PRINT_STRING
======NOW instruction======
beq	$v0, $t0, INT08_PRINT_STRING
===========================
no temp
instruction init
entered add_instruction
oins:beq	$v0, $t0, INT08_PRINT_STRING
not matched
nolabel_ins:beq	$v0, $t0, INT08_PRINT_STRING
===entered add_content===
now label: None
add!
#print_char
======NOW instruction======
#print_char
===========================
addi	$t0, $zero, 11
======NOW instruction======
addi	$t0, $zero, 11
===========================
no temp
instruction init
entered add_instruction
oins:addi	$t0, $zero, 11
not matched
nolabel_ins:addi	$t0, $zero, 11
===entered add_content===
now label: None
add!
beq	$v0, $t0, INT08_PRINT_CHAR
======NOW instruction======
beq	$v0, $t0, INT08_PRINT_CHAR
===========================
no temp
instruction init
entered add_instruction
oins:beq	$v0, $t0, INT08_PRINT_CHAR
not matched
nolabel_ins:beq	$v0, $t0, INT08_PRINT_CHAR
===entered add_content===
now label: None
add!
#pop $ra, $v0, $a0, $t0
======NOW instruction======
#pop $ra, $v0, $a0, $t0
===========================
lw	$ra, 0($sp)
======NOW instruction======
lw	$ra, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$ra, 0($sp)
not matched
nolabel_ins:lw	$ra, 0($sp)
===entered add_content===
now label: None
add!
lw	$v0, 4($sp)
======NOW instruction======
lw	$v0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$v0, 4($sp)
not matched
nolabel_ins:lw	$v0, 4($sp)
===entered add_content===
now label: None
add!
lw	$a0, 8($sp)
======NOW instruction======
lw	$a0, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a0, 8($sp)
not matched
nolabel_ins:lw	$a0, 8($sp)
===entered add_content===
now label: None
add!
lw	$t0, 12($sp)
======NOW instruction======
lw	$t0, 12($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$t0, 12($sp)
not matched
nolabel_ins:lw	$t0, 12($sp)
===entered add_content===
now label: None
add!
addi	$sp, $sp, 16
======NOW instruction======
addi	$sp, $sp, 16
===========================
no temp
instruction init
entered add_instruction
oins:addi	$sp, $sp, 16
not matched
nolabel_ins:addi	$sp, $sp, 16
===entered add_content===
now label: None
add!
#return
======NOW instruction======
#return
===========================
jr	$ra
======NOW instruction======
jr	$ra
===========================
no temp
instruction init
entered add_instruction
oins:jr	$ra
not matched
nolabel_ins:jr	$ra
===entered add_content===
now label: None
add!
INT08_PRINT_STRING:
======NOW instruction======
INT08_PRINT_STRING:
===========================
no temp
instruction init
entered add_instruction
oins:INT08_PRINT_STRING:
matched

nolabel_ins:
===entered add_content===
now label: ['INT08_PRINT_STRING']
#syscall print string
======NOW instruction======
#syscall print string
===========================
#push $ra, $v0, $a0, $t0, $a1, $a2, $t1
======NOW instruction======
#push $ra, $v0, $a0, $t0, $a1, $a2, $t1
===========================
addi	$sp, $sp, -28
======NOW instruction======
addi	$sp, $sp, -28
===========================
have temp
entered add_instruction
oins:addi	$sp, $sp, -28
not matched
nolabel_ins:addi	$sp, $sp, -28
===entered add_content===
now label: ['INT08_PRINT_STRING']
add!
sw	$ra, 0($sp)
======NOW instruction======
sw	$ra, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$ra, 0($sp)
not matched
nolabel_ins:sw	$ra, 0($sp)
===entered add_content===
now label: None
add!
sw	$v0, 4($sp)
======NOW instruction======
sw	$v0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$v0, 4($sp)
not matched
nolabel_ins:sw	$v0, 4($sp)
===entered add_content===
now label: None
add!
sw	$a0, 8($sp)
======NOW instruction======
sw	$a0, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a0, 8($sp)
not matched
nolabel_ins:sw	$a0, 8($sp)
===entered add_content===
now label: None
add!
sw	$t0, 12($sp)
======NOW instruction======
sw	$t0, 12($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t0, 12($sp)
not matched
nolabel_ins:sw	$t0, 12($sp)
===entered add_content===
now label: None
add!
sw	$a1, 16($sp)
======NOW instruction======
sw	$a1, 16($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a1, 16($sp)
not matched
nolabel_ins:sw	$a1, 16($sp)
===entered add_content===
now label: None
add!
sw	$a2, 20($sp)
======NOW instruction======
sw	$a2, 20($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a2, 20($sp)
not matched
nolabel_ins:sw	$a2, 20($sp)
===entered add_content===
now label: None
add!
sw	$t1, 24($sp)
======NOW instruction======
sw	$t1, 24($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t1, 24($sp)
not matched
nolabel_ins:sw	$t1, 24($sp)
===entered add_content===
now label: None
add!
#$t0 = $a0
======NOW instruction======
#$t0 = $a0
===========================
add	$t0, $a0, $zero
======NOW instruction======
add	$t0, $a0, $zero
===========================
no temp
instruction init
entered add_instruction
oins:add	$t0, $a0, $zero
not matched
nolabel_ins:add	$t0, $a0, $zero
===entered add_content===
now label: None
add!
PRINT_STRING_LOOP:
======NOW instruction======
PRINT_STRING_LOOP:
===========================
no temp
instruction init
entered add_instruction
oins:PRINT_STRING_LOOP:
matched

nolabel_ins:
===entered add_content===
now label: ['PRINT_STRING_LOOP']
lw	$a0, 0($t0) #a0 ascii, t0 address
======NOW instruction======
lw	$a0, 0($t0) #a0 ascii, t0 address
===========================
have temp
entered add_instruction
oins:lw	$a0, 0($t0) #a0 ascii, t0 address
not matched
nolabel_ins:lw	$a0, 0($t0) #a0 ascii, t0 address
===entered add_content===
now label: ['PRINT_STRING_LOOP']
final content:lw	$a0, 0($t0) 
add!
srl	$a0, $a0, 24
======NOW instruction======
srl	$a0, $a0, 24
===========================
no temp
instruction init
entered add_instruction
oins:srl	$a0, $a0, 24
not matched
nolabel_ins:srl	$a0, $a0, 24
===entered add_content===
now label: None
add!
beq	$a0, $zero, PRINT_STRING_END_LOOP
======NOW instruction======
beq	$a0, $zero, PRINT_STRING_END_LOOP
===========================
no temp
instruction init
entered add_instruction
oins:beq	$a0, $zero, PRINT_STRING_END_LOOP
not matched
nolabel_ins:beq	$a0, $zero, PRINT_STRING_END_LOOP
===entered add_content===
now label: None
add!
jal	INT08_PRINT_CHAR
======NOW instruction======
jal	INT08_PRINT_CHAR
===========================
no temp
instruction init
entered add_instruction
oins:jal	INT08_PRINT_CHAR
not matched
nolabel_ins:jal	INT08_PRINT_CHAR
===entered add_content===
now label: None
add!
addi	$t0, $t0, 1
======NOW instruction======
addi	$t0, $t0, 1
===========================
no temp
instruction init
entered add_instruction
oins:addi	$t0, $t0, 1
not matched
nolabel_ins:addi	$t0, $t0, 1
===entered add_content===
now label: None
add!
PRINT_STRING_END_LOOP:
======NOW instruction======
PRINT_STRING_END_LOOP:
===========================
no temp
instruction init
entered add_instruction
oins:PRINT_STRING_END_LOOP:
matched

nolabel_ins:
===entered add_content===
now label: ['PRINT_STRING_END_LOOP']
#pop $ra, $v0, $a0, $t0
======NOW instruction======
#pop $ra, $v0, $a0, $t0
===========================
lw	$ra, 0($sp)
======NOW instruction======
lw	$ra, 0($sp)
===========================
have temp
entered add_instruction
oins:lw	$ra, 0($sp)
not matched
nolabel_ins:lw	$ra, 0($sp)
===entered add_content===
now label: ['PRINT_STRING_END_LOOP']
add!
lw	$v0, 4($sp)
======NOW instruction======
lw	$v0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$v0, 4($sp)
not matched
nolabel_ins:lw	$v0, 4($sp)
===entered add_content===
now label: None
add!
lw	$a0, 8($sp)
======NOW instruction======
lw	$a0, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a0, 8($sp)
not matched
nolabel_ins:lw	$a0, 8($sp)
===entered add_content===
now label: None
add!
lw	$t0, 12($sp)
======NOW instruction======
lw	$t0, 12($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$t0, 12($sp)
not matched
nolabel_ins:lw	$t0, 12($sp)
===entered add_content===
now label: None
add!
lw	$a1, 16($sp)
======NOW instruction======
lw	$a1, 16($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a1, 16($sp)
not matched
nolabel_ins:lw	$a1, 16($sp)
===entered add_content===
now label: None
add!
lw	$a2, 20($sp)
======NOW instruction======
lw	$a2, 20($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a2, 20($sp)
not matched
nolabel_ins:lw	$a2, 20($sp)
===entered add_content===
now label: None
add!
lw	$t1, 24($sp)
======NOW instruction======
lw	$t1, 24($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$t1, 24($sp)
not matched
nolabel_ins:lw	$t1, 24($sp)
===entered add_content===
now label: None
add!
addi	$sp, $sp, 28
======NOW instruction======
addi	$sp, $sp, 28
===========================
no temp
instruction init
entered add_instruction
oins:addi	$sp, $sp, 28
not matched
nolabel_ins:addi	$sp, $sp, 28
===entered add_content===
now label: None
add!
#return
======NOW instruction======
#return
===========================
jr	$ra
======NOW instruction======
jr	$ra
===========================
no temp
instruction init
entered add_instruction
oins:jr	$ra
not matched
nolabel_ins:jr	$ra
===entered add_content===
now label: None
add!
SHOW_CHAR:
======NOW instruction======
SHOW_CHAR:
===========================
no temp
instruction init
entered add_instruction
oins:SHOW_CHAR:
matched

nolabel_ins:
===entered add_content===
now label: ['SHOW_CHAR']
#a0 ascii, a1 X, a2 Y
======NOW instruction======
#a0 ascii, a1 X, a2 Y
===========================
#push $t0, $a0
======NOW instruction======
#push $t0, $a0
===========================
addi	$sp, $sp, -12
======NOW instruction======
addi	$sp, $sp, -12
===========================
have temp
entered add_instruction
oins:addi	$sp, $sp, -12
not matched
nolabel_ins:addi	$sp, $sp, -12
===entered add_content===
now label: ['SHOW_CHAR']
add!
sw	$t0, 0($sp)
======NOW instruction======
sw	$t0, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t0, 0($sp)
not matched
nolabel_ins:sw	$t0, 0($sp)
===entered add_content===
now label: None
add!
sw	$a0, 4($sp)
======NOW instruction======
sw	$a0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a0, 4($sp)
not matched
nolabel_ins:sw	$a0, 4($sp)
===entered add_content===
now label: None
add!
sw 	$t1, 8($sp)
======NOW instruction======
sw 	$t1, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw 	$t1, 8($sp)
not matched
nolabel_ins:sw 	$t1, 8($sp)
===entered add_content===
now label: None
add!
sll	$a0, $a0, 3
======NOW instruction======
sll	$a0, $a0, 3
===========================
no temp
instruction init
entered add_instruction
oins:sll	$a0, $a0, 3
not matched
nolabel_ins:sll	$a0, $a0, 3
===entered add_content===
now label: None
add!
#offset
======NOW instruction======
#offset
===========================
add	$t0, $zero, $a2
======NOW instruction======
add	$t0, $zero, $a2
===========================
no temp
instruction init
entered add_instruction
oins:add	$t0, $zero, $a2
not matched
nolabel_ins:add	$t0, $zero, $a2
===entered add_content===
now label: None
add!
sll	$t0, $t0, 7
======NOW instruction======
sll	$t0, $t0, 7
===========================
no temp
instruction init
entered add_instruction
oins:sll	$t0, $t0, 7
not matched
nolabel_ins:sll	$t0, $t0, 7
===entered add_content===
now label: None
add!
add	$t0, $t0, $a1
======NOW instruction======
add	$t0, $t0, $a1
===========================
no temp
instruction init
entered add_instruction
oins:add	$t0, $t0, $a1
not matched
nolabel_ins:add	$t0, $t0, $a1
===entered add_content===
now label: None
add!
sll	$t0, $t0, 2
======NOW instruction======
sll	$t0, $t0, 2
===========================
no temp
instruction init
entered add_instruction
oins:sll	$t0, $t0, 2
not matched
nolabel_ins:sll	$t0, $t0, 2
===entered add_content===
now label: None
add!
lui $t1, 0x1000
======NOW instruction======
lui $t1, 0x1000
===========================
no temp
instruction init
entered add_instruction
oins:lui $t1, 0x1000
not matched
nolabel_ins:lui $t1, 0x1000
===entered add_content===
now label: None
add!
or  $t0, $t0, $t1
======NOW instruction======
or  $t0, $t0, $t1
===========================
no temp
instruction init
entered add_instruction
oins:or  $t0, $t0, $t1
not matched
nolabel_ins:or  $t0, $t0, $t1
===entered add_content===
now label: None
add!
#save word
======NOW instruction======
#save word
===========================
sw	$a0, 0($t0)
======NOW instruction======
sw	$a0, 0($t0)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a0, 0($t0)
not matched
nolabel_ins:sw	$a0, 0($t0)
===entered add_content===
now label: None
add!
#pop $t0, $a0
======NOW instruction======
#pop $t0, $a0
===========================
lw	$t0, 0($sp)
======NOW instruction======
lw	$t0, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$t0, 0($sp)
not matched
nolabel_ins:lw	$t0, 0($sp)
===entered add_content===
now label: None
add!
lw	$a0, 4($sp)
======NOW instruction======
lw	$a0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a0, 4($sp)
not matched
nolabel_ins:lw	$a0, 4($sp)
===entered add_content===
now label: None
add!
lw 	$t1, 8($sp)
======NOW instruction======
lw 	$t1, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw 	$t1, 8($sp)
not matched
nolabel_ins:lw 	$t1, 8($sp)
===entered add_content===
now label: None
add!
addi	$sp, $sp, 12
======NOW instruction======
addi	$sp, $sp, 12
===========================
no temp
instruction init
entered add_instruction
oins:addi	$sp, $sp, 12
not matched
nolabel_ins:addi	$sp, $sp, 12
===entered add_content===
now label: None
add!
#return
======NOW instruction======
#return
===========================
jr	$ra
======NOW instruction======
jr	$ra
===========================
no temp
instruction init
entered add_instruction
oins:jr	$ra
not matched
nolabel_ins:jr	$ra
===entered add_content===
now label: None
add!
INT08_PRINT_CHAR:
======NOW instruction======
INT08_PRINT_CHAR:
===========================
no temp
instruction init
entered add_instruction
oins:INT08_PRINT_CHAR:
matched

nolabel_ins:
===entered add_content===
now label: ['INT08_PRINT_CHAR']
#push $ra, $v0, $a0, $a1, $a2, $t0, $t1
======NOW instruction======
#push $ra, $v0, $a0, $a1, $a2, $t0, $t1
===========================
addi	$sp, $sp, -28
======NOW instruction======
addi	$sp, $sp, -28
===========================
have temp
entered add_instruction
oins:addi	$sp, $sp, -28
not matched
nolabel_ins:addi	$sp, $sp, -28
===entered add_content===
now label: ['INT08_PRINT_CHAR']
add!
sw	$ra, 0($sp)
======NOW instruction======
sw	$ra, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$ra, 0($sp)
not matched
nolabel_ins:sw	$ra, 0($sp)
===entered add_content===
now label: None
add!
sw	$v0, 4($sp)
======NOW instruction======
sw	$v0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$v0, 4($sp)
not matched
nolabel_ins:sw	$v0, 4($sp)
===entered add_content===
now label: None
add!
sw	$a0, 8($sp)
======NOW instruction======
sw	$a0, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a0, 8($sp)
not matched
nolabel_ins:sw	$a0, 8($sp)
===entered add_content===
now label: None
add!
sw	$a1, 12($sp)
======NOW instruction======
sw	$a1, 12($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a1, 12($sp)
not matched
nolabel_ins:sw	$a1, 12($sp)
===entered add_content===
now label: None
add!
sw	$a2, 16($sp)
======NOW instruction======
sw	$a2, 16($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a2, 16($sp)
not matched
nolabel_ins:sw	$a2, 16($sp)
===entered add_content===
now label: None
add!
sw	$t0, 20($sp)
======NOW instruction======
sw	$t0, 20($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t0, 20($sp)
not matched
nolabel_ins:sw	$t0, 20($sp)
===entered add_content===
now label: None
add!
sw	$t1, 24($sp)
======NOW instruction======
sw	$t1, 24($sp)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$t1, 24($sp)
not matched
nolabel_ins:sw	$t1, 24($sp)
===entered add_content===
now label: None
add!
#a0 ascii, a1 X, a2 Y
======NOW instruction======
#a0 ascii, a1 X, a2 Y
===========================
#Cursor X, Y
======NOW instruction======
#Cursor X, Y
===========================
lui	$t0, 0xffff
======NOW instruction======
lui	$t0, 0xffff
===========================
no temp
instruction init
entered add_instruction
oins:lui	$t0, 0xffff
not matched
nolabel_ins:lui	$t0, 0xffff
===entered add_content===
now label: None
add!
#ori	$t0, $t0, 0x0000
======NOW instruction======
#ori	$t0, $t0, 0x0000
===========================
lw	$a1, 0($t0) #X
======NOW instruction======
lw	$a1, 0($t0) #X
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a1, 0($t0) #X
not matched
nolabel_ins:lw	$a1, 0($t0) #X
===entered add_content===
now label: None
final content:lw	$a1, 0($t0) 
add!
lw	$a2, 4($t0) #Y
======NOW instruction======
lw	$a2, 4($t0) #Y
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a2, 4($t0) #Y
not matched
nolabel_ins:lw	$a2, 4($t0) #Y
===entered add_content===
now label: None
final content:lw	$a2, 4($t0) 
add!
#if a0 = enter
======NOW instruction======
#if a0 = enter
===========================
addi	$t1, $zero, 13
======NOW instruction======
addi	$t1, $zero, 13
===========================
no temp
instruction init
entered add_instruction
oins:addi	$t1, $zero, 13
not matched
nolabel_ins:addi	$t1, $zero, 13
===entered add_content===
now label: None
add!
bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
======NOW instruction======
bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
===========================
no temp
instruction init
entered add_instruction
oins:bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
not matched
nolabel_ins:bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
===entered add_content===
now label: None
add!
add	$a1, $zero, $zero
======NOW instruction======
add	$a1, $zero, $zero
===========================
no temp
instruction init
entered add_instruction
oins:add	$a1, $zero, $zero
not matched
nolabel_ins:add	$a1, $zero, $zero
===entered add_content===
now label: None
add!
addi	$a2, $a2, 1
======NOW instruction======
addi	$a2, $a2, 1
===========================
no temp
instruction init
entered add_instruction
oins:addi	$a2, $a2, 1
not matched
nolabel_ins:addi	$a2, $a2, 1
===entered add_content===
now label: None
add!
#jump to end
======NOW instruction======
#jump to end
===========================
j	INT08_PRINT_CHAR_END
======NOW instruction======
j	INT08_PRINT_CHAR_END
===========================
no temp
instruction init
entered add_instruction
oins:j	INT08_PRINT_CHAR_END
not matched
nolabel_ins:j	INT08_PRINT_CHAR_END
===entered add_content===
now label: None
add!
INT08_PRINT_CHAR_EXEC:
======NOW instruction======
INT08_PRINT_CHAR_EXEC:
===========================
no temp
instruction init
entered add_instruction
oins:INT08_PRINT_CHAR_EXEC:
matched

nolabel_ins:
===entered add_content===
now label: ['INT08_PRINT_CHAR_EXEC']
jal	SHOW_CHAR
======NOW instruction======
jal	SHOW_CHAR
===========================
have temp
entered add_instruction
oins:jal	SHOW_CHAR
not matched
nolabel_ins:jal	SHOW_CHAR
===entered add_content===
now label: ['INT08_PRINT_CHAR_EXEC']
add!
#X+1
======NOW instruction======
#X+1
===========================
addi	$a1, $a1, 1
======NOW instruction======
addi	$a1, $a1, 1
===========================
no temp
instruction init
entered add_instruction
oins:addi	$a1, $a1, 1
not matched
nolabel_ins:addi	$a1, $a1, 1
===entered add_content===
now label: None
add!
#if X=WEIGHT
======NOW instruction======
#if X=WEIGHT
===========================
la	$t1, WEIGHT
======NOW instruction======
la	$t1, WEIGHT
===========================
no temp
instruction init
entered add_instruction
oins:la	$t1, WEIGHT
not matched
nolabel_ins:la	$t1, WEIGHT
===entered add_content===
now label: None
add!
lw	$t1, 0($t1)
======NOW instruction======
lw	$t1, 0($t1)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$t1, 0($t1)
not matched
nolabel_ins:lw	$t1, 0($t1)
===entered add_content===
now label: None
add!
bne	$a1, $t1, INT08_PRINT_CHAR_END
======NOW instruction======
bne	$a1, $t1, INT08_PRINT_CHAR_END
===========================
no temp
instruction init
entered add_instruction
oins:bne	$a1, $t1, INT08_PRINT_CHAR_END
not matched
nolabel_ins:bne	$a1, $t1, INT08_PRINT_CHAR_END
===entered add_content===
now label: None
add!
add	$a1, $zero, $zero
======NOW instruction======
add	$a1, $zero, $zero
===========================
no temp
instruction init
entered add_instruction
oins:add	$a1, $zero, $zero
not matched
nolabel_ins:add	$a1, $zero, $zero
===entered add_content===
now label: None
add!
addi	$a2, $a2, 1
======NOW instruction======
addi	$a2, $a2, 1
===========================
no temp
instruction init
entered add_instruction
oins:addi	$a2, $a2, 1
not matched
nolabel_ins:addi	$a2, $a2, 1
===entered add_content===
now label: None
add!
#if Full Page, scroll page
======NOW instruction======
#if Full Page, scroll page
===========================
#...
======NOW instruction======
#...
===========================
INT08_PRINT_CHAR_END:
======NOW instruction======
INT08_PRINT_CHAR_END:
===========================
no temp
instruction init
entered add_instruction
oins:INT08_PRINT_CHAR_END:
matched

nolabel_ins:
===entered add_content===
now label: ['INT08_PRINT_CHAR_END']
#save back X, Y
======NOW instruction======
#save back X, Y
===========================
sw	$a1, 0($t0)
======NOW instruction======
sw	$a1, 0($t0)
===========================
have temp
entered add_instruction
oins:sw	$a1, 0($t0)
not matched
nolabel_ins:sw	$a1, 0($t0)
===entered add_content===
now label: ['INT08_PRINT_CHAR_END']
add!
sw	$a2, 4($t0)
======NOW instruction======
sw	$a2, 4($t0)
===========================
no temp
instruction init
entered add_instruction
oins:sw	$a2, 4($t0)
not matched
nolabel_ins:sw	$a2, 4($t0)
===entered add_content===
now label: None
add!
#pop $ra, $v0, $a0, $a1, $a2, $t0
======NOW instruction======
#pop $ra, $v0, $a0, $a1, $a2, $t0
===========================
lw	$ra, 0($sp)
======NOW instruction======
lw	$ra, 0($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$ra, 0($sp)
not matched
nolabel_ins:lw	$ra, 0($sp)
===entered add_content===
now label: None
add!
lw	$v0, 4($sp)
======NOW instruction======
lw	$v0, 4($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$v0, 4($sp)
not matched
nolabel_ins:lw	$v0, 4($sp)
===entered add_content===
now label: None
add!
lw	$a0, 8($sp)
======NOW instruction======
lw	$a0, 8($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a0, 8($sp)
not matched
nolabel_ins:lw	$a0, 8($sp)
===entered add_content===
now label: None
add!
lw	$a1, 12($sp)
======NOW instruction======
lw	$a1, 12($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a1, 12($sp)
not matched
nolabel_ins:lw	$a1, 12($sp)
===entered add_content===
now label: None
add!
lw	$a2, 16($sp)
======NOW instruction======
lw	$a2, 16($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$a2, 16($sp)
not matched
nolabel_ins:lw	$a2, 16($sp)
===entered add_content===
now label: None
add!
lw	$t0, 20($sp)
======NOW instruction======
lw	$t0, 20($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$t0, 20($sp)
not matched
nolabel_ins:lw	$t0, 20($sp)
===entered add_content===
now label: None
add!
lw	$t1, 24($sp)
======NOW instruction======
lw	$t1, 24($sp)
===========================
no temp
instruction init
entered add_instruction
oins:lw	$t1, 24($sp)
not matched
nolabel_ins:lw	$t1, 24($sp)
===entered add_content===
now label: None
add!
addi	$sp, $sp, 28
======NOW instruction======
addi	$sp, $sp, 28
===========================
no temp
instruction init
entered add_instruction
oins:addi	$sp, $sp, 28
not matched
nolabel_ins:addi	$sp, $sp, 28
===entered add_content===
now label: None
add!
#return
======NOW instruction======
#return
===========================
jr	$ra
======NOW instruction======
jr	$ra
===========================
no temp
instruction init
entered add_instruction
oins:jr	$ra
not matched
nolabel_ins:jr	$ra
===entered add_content===
now label: None
add!
#.data
======NOW instruction======
#.data
===========================
#	CRTadr	.word
======NOW instruction======
#	CRTadr	.word
===========================
#	WEIGHT	.word
======NOW instruction======
#	WEIGHT	.word
===========================
#	HEIGHT	.word
======NOW instruction======
#	HEIGHT	.word
===========================
#	CursorX	.word
======NOW instruction======
#	CursorX	.word
===========================
#	CursorY	.word
======NOW instruction======
#	CursorY	.word
===========================
.data 0x00000900
======NOW instruction======
.data 0x00000900
===========================
append
WEIGHT:	.word	40
======NOW instruction======
WEIGHT:	.word	40
===========================
instruction init
entered add_instruction
oins:WEIGHT:	.word	40
matched
	.word	40
nolabel_ins:	.word	40
===entered add_content===
now label: ['WEIGHT']
label: ['WEIGHT']
HEIGHT:	.word	25
======NOW instruction======
HEIGHT:	.word	25
===========================
instruction init
entered add_instruction
oins:HEIGHT:	.word	25
matched
	.word	25
nolabel_ins:	.word	25
===entered add_content===
now label: ['HEIGHT']
label: ['HEIGHT']
hi:	.asciiz	"hello world!"
======NOW instruction======
hi:	.asciiz	"hello world!"
===========================
instruction init
entered add_instruction
oins:hi:	.asciiz	"hello world!"
matched
	.asciiz	"hello world!"
nolabel_ins:	.asciiz	"hello world!"
===entered add_content===
now label: ['hi']
label: ['hi']

======NOW instruction======

===========================
.text 0x00001000
======NOW instruction======
.text 0x00001000
===========================
append
#Kernel initialization begin
======NOW instruction======
#Kernel initialization begin
===========================
KERNEL_INIT:
======NOW instruction======
KERNEL_INIT:
===========================
no temp
instruction init
entered add_instruction
oins:KERNEL_INIT:
matched

nolabel_ins:
===entered add_content===
now label: ['KERNEL_INIT']
la	$a0, hi
======NOW instruction======
la	$a0, hi
===========================
have temp
entered add_instruction
oins:la	$a0, hi
not matched
nolabel_ins:la	$a0, hi
===entered add_content===
now label: ['KERNEL_INIT']
add!
li  $v0, 4
======NOW instruction======
li  $v0, 4
===========================
no temp
instruction init
entered add_instruction
oins:li  $v0, 4
not matched
nolabel_ins:li  $v0, 4
===entered add_content===
now label: None
add!
syscall
======NOW instruction======
syscall
===========================
no temp
instruction init
entered add_instruction
oins:syscall
not matched
nolabel_ins:syscall
===entered add_content===
now label: None
add!
DEAD_LOOP:
======NOW instruction======
DEAD_LOOP:
===========================
no temp
instruction init
entered add_instruction
oins:DEAD_LOOP:
matched

nolabel_ins:
===entered add_content===
now label: ['DEAD_LOOP']
j   DEAD_LOOP
======NOW instruction======
j   DEAD_LOOP
===========================
have temp
entered add_instruction
oins:j   DEAD_LOOP
not matched
nolabel_ins:j   DEAD_LOOP
===entered add_content===
now label: ['DEAD_LOOP']
add!
====first step finished====
====var list=====
type location
type text
=====now instruction===== li  $sp, 0xfffc |label: None
65532
00000000000000001111111111111100
===new===
label: None content: lui $sp,0b0000000000000000 note, None
label: None content: ori $sp,$sp,0b1111111111111100 note, None
=========
type text
=====now instruction===== la	$t0, int00 |label: None
===new===
label: None content: lahi $t0,int00[high] note, None
label: None content: lalo $t0,$t0,int00[low] note, None
=========
type text
=====now instruction===== la	$t1, INT00_SERVICE |label: None
===new===
label: None content: lahi $t1,INT00_SERVICE[high] note, None
label: None content: lalo $t1,$t1,INT00_SERVICE[low] note, None
=========
type text
=====now instruction===== sw	$t1, 0($t0) |label: None
===new===
label: None content: sw	$t1, 0($t0) note, None
=========
type text
=====now instruction===== la	$t0, int08 |label: None
===new===
label: None content: lahi $t0,int08[high] note, None
label: None content: lalo $t0,$t0,int08[low] note, None
=========
type text
=====now instruction===== la	$t1, INT08_SERVICE |label: None
===new===
label: None content: lahi $t1,INT08_SERVICE[high] note, None
label: None content: lalo $t1,$t1,INT08_SERVICE[low] note, None
=========
type text
=====now instruction===== sw	$t1, 0($t0) |label: None
===new===
label: None content: sw	$t1, 0($t0) note, None
=========
type text
=====now instruction===== j	KERNEL_INIT |label: None
===new===
label: None content: j	KERNEL_INIT note, None
=========
type location
type text
=====now instruction===== addi	$sp, $sp, -4 |label: ['INT_HANDLER']
===new===
label: ['INT_HANDLER'] content: addi	$sp, $sp, -4 note, None
=========
type text
=====now instruction===== sw		$ra, 0($sp) |label: None
===new===
label: None content: sw		$ra, 0($sp) note, None
=========
type text
=====now instruction===== mfc0	$k0, $13 |label: None
===new===
label: None content: mfc0	$k0, $13 note, $12: Status
=========
type text
=====now instruction===== andi	$k0, $k0, 0x007C |label: None
===new===
label: None content: andi	$k0, $k0, 0x007C note, 2~6 bits
=========
type text
=====now instruction===== addi	$k0, $k0, 0x0100 |label: None
===new===
label: None content: addi	$k0, $k0, 0x0100 note, jump to interrupt
=========
type text
=====now instruction===== lw		$k0, 0($k0) |label: None
===new===
label: None content: lw		$k0, 0($k0) note, get the address
=========
type text
=====now instruction===== jalr	$k0, $ra |label: None
===new===
label: None content: jalr	$k0, $ra note, None
=========
type text
=====now instruction===== lw 		$ra, 0($sp) |label: None
===new===
label: None content: lw 		$ra, 0($sp) note, None
=========
type text
=====now instruction===== addi 	$sp, $sp, 4 |label: None
===new===
label: None content: addi 	$sp, $sp, 4 note, None
=========
type text
=====now instruction===== eret |label: None
===new===
label: None content: eret note, None
=========
type location
type data
=====now instruction===== .word	0 |label: ['int00']
===new===
label: ['int00'] content: .word	0 note, all external interrupt
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type data
=====now instruction===== .word	0 |label: ['int08']
===new===
label: ['int08'] content: .word	0 note, syscall
=========
type data
=====now instruction===== .word 	0 |label: None
===new===
label: None content: .word 	0 note, None
=========
type location
type text
=====now instruction===== addi	$sp, $sp, -16 |label: ['INT_SERVICES', 'INT00_SERVICE', 'INT08_SERVICE']
===new===
label: ['INT_SERVICES', 'INT00_SERVICE', 'INT08_SERVICE'] content: addi	$sp, $sp, -16 note, None
=========
type text
=====now instruction===== sw	$ra, 0($sp) |label: None
===new===
label: None content: sw	$ra, 0($sp) note, None
=========
type text
=====now instruction===== sw	$v0, 4($sp) |label: None
===new===
label: None content: sw	$v0, 4($sp) note, None
=========
type text
=====now instruction===== sw	$a0, 8($sp) |label: None
===new===
label: None content: sw	$a0, 8($sp) note, None
=========
type text
=====now instruction===== sw	$t0, 12($sp) |label: None
===new===
label: None content: sw	$t0, 12($sp) note, None
=========
type text
=====now instruction===== addi	$t0, $zero, 4 |label: None
===new===
label: None content: addi	$t0, $zero, 4 note, None
=========
type text
=====now instruction===== beq	$v0, $t0, INT08_PRINT_STRING |label: None
===new===
label: None content: beq	$v0, $t0, INT08_PRINT_STRING note, None
=========
type text
=====now instruction===== addi	$t0, $zero, 11 |label: None
===new===
label: None content: addi	$t0, $zero, 11 note, None
=========
type text
=====now instruction===== beq	$v0, $t0, INT08_PRINT_CHAR |label: None
===new===
label: None content: beq	$v0, $t0, INT08_PRINT_CHAR note, None
=========
type text
=====now instruction===== lw	$ra, 0($sp) |label: None
===new===
label: None content: lw	$ra, 0($sp) note, None
=========
type text
=====now instruction===== lw	$v0, 4($sp) |label: None
===new===
label: None content: lw	$v0, 4($sp) note, None
=========
type text
=====now instruction===== lw	$a0, 8($sp) |label: None
===new===
label: None content: lw	$a0, 8($sp) note, None
=========
type text
=====now instruction===== lw	$t0, 12($sp) |label: None
===new===
label: None content: lw	$t0, 12($sp) note, None
=========
type text
=====now instruction===== addi	$sp, $sp, 16 |label: None
===new===
label: None content: addi	$sp, $sp, 16 note, None
=========
type text
=====now instruction===== jr	$ra |label: None
===new===
label: None content: jr	$ra note, None
=========
type text
=====now instruction===== addi	$sp, $sp, -28 |label: ['INT08_PRINT_STRING']
===new===
label: ['INT08_PRINT_STRING'] content: addi	$sp, $sp, -28 note, None
=========
type text
=====now instruction===== sw	$ra, 0($sp) |label: None
===new===
label: None content: sw	$ra, 0($sp) note, None
=========
type text
=====now instruction===== sw	$v0, 4($sp) |label: None
===new===
label: None content: sw	$v0, 4($sp) note, None
=========
type text
=====now instruction===== sw	$a0, 8($sp) |label: None
===new===
label: None content: sw	$a0, 8($sp) note, None
=========
type text
=====now instruction===== sw	$t0, 12($sp) |label: None
===new===
label: None content: sw	$t0, 12($sp) note, None
=========
type text
=====now instruction===== sw	$a1, 16($sp) |label: None
===new===
label: None content: sw	$a1, 16($sp) note, None
=========
type text
=====now instruction===== sw	$a2, 20($sp) |label: None
===new===
label: None content: sw	$a2, 20($sp) note, None
=========
type text
=====now instruction===== sw	$t1, 24($sp) |label: None
===new===
label: None content: sw	$t1, 24($sp) note, None
=========
type text
=====now instruction===== add	$t0, $a0, $zero |label: None
===new===
label: None content: add	$t0, $a0, $zero note, None
=========
type text
=====now instruction===== lw	$a0, 0($t0) |label: ['PRINT_STRING_LOOP']
===new===
label: ['PRINT_STRING_LOOP'] content: lw	$a0, 0($t0) note, a0 ascii, t0 address
=========
type text
=====now instruction===== srl	$a0, $a0, 24 |label: None
===new===
label: None content: srl	$a0, $a0, 24 note, None
=========
type text
=====now instruction===== beq	$a0, $zero, PRINT_STRING_END_LOOP |label: None
===new===
label: None content: beq	$a0, $zero, PRINT_STRING_END_LOOP note, None
=========
type text
=====now instruction===== jal	INT08_PRINT_CHAR |label: None
===new===
label: None content: jal	INT08_PRINT_CHAR note, None
=========
type text
=====now instruction===== addi	$t0, $t0, 1 |label: None
===new===
label: None content: addi	$t0, $t0, 1 note, None
=========
type text
=====now instruction===== lw	$ra, 0($sp) |label: ['PRINT_STRING_END_LOOP']
===new===
label: ['PRINT_STRING_END_LOOP'] content: lw	$ra, 0($sp) note, None
=========
type text
=====now instruction===== lw	$v0, 4($sp) |label: None
===new===
label: None content: lw	$v0, 4($sp) note, None
=========
type text
=====now instruction===== lw	$a0, 8($sp) |label: None
===new===
label: None content: lw	$a0, 8($sp) note, None
=========
type text
=====now instruction===== lw	$t0, 12($sp) |label: None
===new===
label: None content: lw	$t0, 12($sp) note, None
=========
type text
=====now instruction===== lw	$a1, 16($sp) |label: None
===new===
label: None content: lw	$a1, 16($sp) note, None
=========
type text
=====now instruction===== lw	$a2, 20($sp) |label: None
===new===
label: None content: lw	$a2, 20($sp) note, None
=========
type text
=====now instruction===== lw	$t1, 24($sp) |label: None
===new===
label: None content: lw	$t1, 24($sp) note, None
=========
type text
=====now instruction===== addi	$sp, $sp, 28 |label: None
===new===
label: None content: addi	$sp, $sp, 28 note, None
=========
type text
=====now instruction===== jr	$ra |label: None
===new===
label: None content: jr	$ra note, None
=========
type text
=====now instruction===== addi	$sp, $sp, -12 |label: ['SHOW_CHAR']
===new===
label: ['SHOW_CHAR'] content: addi	$sp, $sp, -12 note, None
=========
type text
=====now instruction===== sw	$t0, 0($sp) |label: None
===new===
label: None content: sw	$t0, 0($sp) note, None
=========
type text
=====now instruction===== sw	$a0, 4($sp) |label: None
===new===
label: None content: sw	$a0, 4($sp) note, None
=========
type text
=====now instruction===== sw 	$t1, 8($sp) |label: None
===new===
label: None content: sw 	$t1, 8($sp) note, None
=========
type text
=====now instruction===== sll	$a0, $a0, 3 |label: None
===new===
label: None content: sll	$a0, $a0, 3 note, None
=========
type text
=====now instruction===== add	$t0, $zero, $a2 |label: None
===new===
label: None content: add	$t0, $zero, $a2 note, None
=========
type text
=====now instruction===== sll	$t0, $t0, 7 |label: None
===new===
label: None content: sll	$t0, $t0, 7 note, None
=========
type text
=====now instruction===== add	$t0, $t0, $a1 |label: None
===new===
label: None content: add	$t0, $t0, $a1 note, None
=========
type text
=====now instruction===== sll	$t0, $t0, 2 |label: None
===new===
label: None content: sll	$t0, $t0, 2 note, None
=========
type text
=====now instruction===== lui $t1, 0x1000 |label: None
===new===
label: None content: lui $t1, 0x1000 note, None
=========
type text
=====now instruction===== or  $t0, $t0, $t1 |label: None
===new===
label: None content: or  $t0, $t0, $t1 note, None
=========
type text
=====now instruction===== sw	$a0, 0($t0) |label: None
===new===
label: None content: sw	$a0, 0($t0) note, None
=========
type text
=====now instruction===== lw	$t0, 0($sp) |label: None
===new===
label: None content: lw	$t0, 0($sp) note, None
=========
type text
=====now instruction===== lw	$a0, 4($sp) |label: None
===new===
label: None content: lw	$a0, 4($sp) note, None
=========
type text
=====now instruction===== lw 	$t1, 8($sp) |label: None
===new===
label: None content: lw 	$t1, 8($sp) note, None
=========
type text
=====now instruction===== addi	$sp, $sp, 12 |label: None
===new===
label: None content: addi	$sp, $sp, 12 note, None
=========
type text
=====now instruction===== jr	$ra |label: None
===new===
label: None content: jr	$ra note, None
=========
type text
=====now instruction===== addi	$sp, $sp, -28 |label: ['INT08_PRINT_CHAR']
===new===
label: ['INT08_PRINT_CHAR'] content: addi	$sp, $sp, -28 note, None
=========
type text
=====now instruction===== sw	$ra, 0($sp) |label: None
===new===
label: None content: sw	$ra, 0($sp) note, None
=========
type text
=====now instruction===== sw	$v0, 4($sp) |label: None
===new===
label: None content: sw	$v0, 4($sp) note, None
=========
type text
=====now instruction===== sw	$a0, 8($sp) |label: None
===new===
label: None content: sw	$a0, 8($sp) note, None
=========
type text
=====now instruction===== sw	$a1, 12($sp) |label: None
===new===
label: None content: sw	$a1, 12($sp) note, None
=========
type text
=====now instruction===== sw	$a2, 16($sp) |label: None
===new===
label: None content: sw	$a2, 16($sp) note, None
=========
type text
=====now instruction===== sw	$t0, 20($sp) |label: None
===new===
label: None content: sw	$t0, 20($sp) note, None
=========
type text
=====now instruction===== sw	$t1, 24($sp) |label: None
===new===
label: None content: sw	$t1, 24($sp) note, None
=========
type text
=====now instruction===== lui	$t0, 0xffff |label: None
===new===
label: None content: lui	$t0, 0xffff note, None
=========
type text
=====now instruction===== lw	$a1, 0($t0) |label: None
===new===
label: None content: lw	$a1, 0($t0) note, X
=========
type text
=====now instruction===== lw	$a2, 4($t0) |label: None
===new===
label: None content: lw	$a2, 4($t0) note, Y
=========
type text
=====now instruction===== addi	$t1, $zero, 13 |label: None
===new===
label: None content: addi	$t1, $zero, 13 note, None
=========
type text
=====now instruction===== bne	$a0, $t1, INT08_PRINT_CHAR_EXEC |label: None
===new===
label: None content: bne	$a0, $t1, INT08_PRINT_CHAR_EXEC note, None
=========
type text
=====now instruction===== add	$a1, $zero, $zero |label: None
===new===
label: None content: add	$a1, $zero, $zero note, None
=========
type text
=====now instruction===== addi	$a2, $a2, 1 |label: None
===new===
label: None content: addi	$a2, $a2, 1 note, None
=========
type text
=====now instruction===== j	INT08_PRINT_CHAR_END |label: None
===new===
label: None content: j	INT08_PRINT_CHAR_END note, None
=========
type text
=====now instruction===== jal	SHOW_CHAR |label: ['INT08_PRINT_CHAR_EXEC']
===new===
label: ['INT08_PRINT_CHAR_EXEC'] content: jal	SHOW_CHAR note, None
=========
type text
=====now instruction===== addi	$a1, $a1, 1 |label: None
===new===
label: None content: addi	$a1, $a1, 1 note, None
=========
type text
=====now instruction===== la	$t1, WEIGHT |label: None
===new===
label: None content: lahi $t1,WEIGHT[high] note, None
label: None content: lalo $t1,$t1,WEIGHT[low] note, None
=========
type text
=====now instruction===== lw	$t1, 0($t1) |label: None
===new===
label: None content: lw	$t1, 0($t1) note, None
=========
type text
=====now instruction===== bne	$a1, $t1, INT08_PRINT_CHAR_END |label: None
===new===
label: None content: bne	$a1, $t1, INT08_PRINT_CHAR_END note, None
=========
type text
=====now instruction===== add	$a1, $zero, $zero |label: None
===new===
label: None content: add	$a1, $zero, $zero note, None
=========
type text
=====now instruction===== addi	$a2, $a2, 1 |label: None
===new===
label: None content: addi	$a2, $a2, 1 note, None
=========
type text
=====now instruction===== sw	$a1, 0($t0) |label: ['INT08_PRINT_CHAR_END']
===new===
label: ['INT08_PRINT_CHAR_END'] content: sw	$a1, 0($t0) note, None
=========
type text
=====now instruction===== sw	$a2, 4($t0) |label: None
===new===
label: None content: sw	$a2, 4($t0) note, None
=========
type text
=====now instruction===== lw	$ra, 0($sp) |label: None
===new===
label: None content: lw	$ra, 0($sp) note, None
=========
type text
=====now instruction===== lw	$v0, 4($sp) |label: None
===new===
label: None content: lw	$v0, 4($sp) note, None
=========
type text
=====now instruction===== lw	$a0, 8($sp) |label: None
===new===
label: None content: lw	$a0, 8($sp) note, None
=========
type text
=====now instruction===== lw	$a1, 12($sp) |label: None
===new===
label: None content: lw	$a1, 12($sp) note, None
=========
type text
=====now instruction===== lw	$a2, 16($sp) |label: None
===new===
label: None content: lw	$a2, 16($sp) note, None
=========
type text
=====now instruction===== lw	$t0, 20($sp) |label: None
===new===
label: None content: lw	$t0, 20($sp) note, None
=========
type text
=====now instruction===== lw	$t1, 24($sp) |label: None
===new===
label: None content: lw	$t1, 24($sp) note, None
=========
type text
=====now instruction===== addi	$sp, $sp, 28 |label: None
===new===
label: None content: addi	$sp, $sp, 28 note, None
=========
type text
=====now instruction===== jr	$ra |label: None
===new===
label: None content: jr	$ra note, None
=========
type location
type data
=====now instruction===== .word	40 |label: ['WEIGHT']
===new===
label: ['WEIGHT'] content: .word	40 note, None
=========
type data
=====now instruction===== .word	25 |label: ['HEIGHT']
===new===
label: ['HEIGHT'] content: .word	25 note, None
=========
type data
=====now instruction===== .asciiz	"hello world!" |label: ['hi']
===new===
label: ['hi'] content: .asciiz	"hello world!" note, None
=========
type location
type text
=====now instruction===== la	$a0, hi |label: ['KERNEL_INIT']
===new===
label: ['KERNEL_INIT'] content: lahi $a0,hi[high] note, None
label: None content: lalo $a0,$a0,hi[low] note, None
=========
type text
=====now instruction===== li  $v0, 4 |label: None
4
00000000000000000000000000000100
===new===
label: None content: lui $v0,0b0000000000000000 note, None
label: None content: ori $v0,$v0,0b0000000000000100 note, None
=========
type text
=====now instruction===== syscall |label: None
===new===
label: None content: syscall note, None
=========
type text
=====now instruction===== j   DEAD_LOOP |label: ['DEAD_LOOP']
===new===
label: ['DEAD_LOOP'] content: j   DEAD_LOOP note, None
=========
===real instruction start===
=====now instruction===== lui $sp,0b0000000000000000 |label: None
now content:lui $sp,0b0000000000000000
======data======
=====now instruction===== ori $sp,$sp,0b1111111111111100 |label: None
now content:ori $sp,$sp,0b1111111111111100
======data======
=====now instruction===== lahi $t0,int00[high] |label: None
now content:lahi $t0,int00[high]
======data======
=====now instruction===== lalo $t0,$t0,int00[low] |label: None
now content:lalo $t0,$t0,int00[low]
======data======
=====now instruction===== lahi $t1,INT00_SERVICE[high] |label: None
now content:lahi $t1,INT00_SERVICE[high]
======data======
=====now instruction===== lalo $t1,$t1,INT00_SERVICE[low] |label: None
now content:lalo $t1,$t1,INT00_SERVICE[low]
======data======
=====now instruction===== sw	$t1, 0($t0) |label: None
now content:sw	$t1, 0($t0)
======data======
=====now instruction===== lahi $t0,int08[high] |label: None
now content:lahi $t0,int08[high]
======data======
=====now instruction===== lalo $t0,$t0,int08[low] |label: None
now content:lalo $t0,$t0,int08[low]
======data======
=====now instruction===== lahi $t1,INT08_SERVICE[high] |label: None
now content:lahi $t1,INT08_SERVICE[high]
======data======
=====now instruction===== lalo $t1,$t1,INT08_SERVICE[low] |label: None
now content:lalo $t1,$t1,INT08_SERVICE[low]
======data======
=====now instruction===== sw	$t1, 0($t0) |label: None
now content:sw	$t1, 0($t0)
======data======
=====now instruction===== j	KERNEL_INIT |label: None
now content:j	KERNEL_INIT
======data======
=====now instruction===== addi	$sp, $sp, -4 |label: ['INT_HANDLER']
now content:addi	$sp, $sp, -4
======data======
handling labellist ['INT_HANDLER']
=====now instruction===== sw		$ra, 0($sp) |label: None
now content:sw		$ra, 0($sp)
======data======
=====now instruction===== mfc0	$k0, $13 |label: None
now content:mfc0	$k0, $13
======data======
=====now instruction===== andi	$k0, $k0, 0x007C |label: None
now content:andi	$k0, $k0, 0x007C
======data======
=====now instruction===== addi	$k0, $k0, 0x0100 |label: None
now content:addi	$k0, $k0, 0x0100
======data======
=====now instruction===== lw		$k0, 0($k0) |label: None
now content:lw		$k0, 0($k0)
======data======
=====now instruction===== jalr	$k0, $ra |label: None
now content:jalr	$k0, $ra
======data======
=====now instruction===== lw 		$ra, 0($sp) |label: None
now content:lw 		$ra, 0($sp)
======data======
=====now instruction===== addi 	$sp, $sp, 4 |label: None
now content:addi 	$sp, $sp, 4
======data======
=====now instruction===== eret |label: None
now content:eret
======data======
=====now instruction===== .word	0 |label: ['int00']
now content:.word	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word	0 |label: ['int08']
now content:.word	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== .word 	0 |label: None
now content:.word 	0
======data======
data=0
temps=[0]
['00000000', '00000000', '00000000', '00000000']
=====now instruction===== addi	$sp, $sp, -16 |label: ['INT_SERVICES', 'INT00_SERVICE', 'INT08_SERVICE']
now content:addi	$sp, $sp, -16
======data======
handling labellist ['INT_SERVICES', 'INT00_SERVICE', 'INT08_SERVICE']
=====now instruction===== sw	$ra, 0($sp) |label: None
now content:sw	$ra, 0($sp)
======data======
=====now instruction===== sw	$v0, 4($sp) |label: None
now content:sw	$v0, 4($sp)
======data======
=====now instruction===== sw	$a0, 8($sp) |label: None
now content:sw	$a0, 8($sp)
======data======
=====now instruction===== sw	$t0, 12($sp) |label: None
now content:sw	$t0, 12($sp)
======data======
=====now instruction===== addi	$t0, $zero, 4 |label: None
now content:addi	$t0, $zero, 4
======data======
=====now instruction===== beq	$v0, $t0, INT08_PRINT_STRING |label: None
now content:beq	$v0, $t0, INT08_PRINT_STRING
======data======
=====now instruction===== addi	$t0, $zero, 11 |label: None
now content:addi	$t0, $zero, 11
======data======
=====now instruction===== beq	$v0, $t0, INT08_PRINT_CHAR |label: None
now content:beq	$v0, $t0, INT08_PRINT_CHAR
======data======
=====now instruction===== lw	$ra, 0($sp) |label: None
now content:lw	$ra, 0($sp)
======data======
=====now instruction===== lw	$v0, 4($sp) |label: None
now content:lw	$v0, 4($sp)
======data======
=====now instruction===== lw	$a0, 8($sp) |label: None
now content:lw	$a0, 8($sp)
======data======
=====now instruction===== lw	$t0, 12($sp) |label: None
now content:lw	$t0, 12($sp)
======data======
=====now instruction===== addi	$sp, $sp, 16 |label: None
now content:addi	$sp, $sp, 16
======data======
=====now instruction===== jr	$ra |label: None
now content:jr	$ra
======data======
=====now instruction===== addi	$sp, $sp, -28 |label: ['INT08_PRINT_STRING']
now content:addi	$sp, $sp, -28
======data======
handling labellist ['INT08_PRINT_STRING']
=====now instruction===== sw	$ra, 0($sp) |label: None
now content:sw	$ra, 0($sp)
======data======
=====now instruction===== sw	$v0, 4($sp) |label: None
now content:sw	$v0, 4($sp)
======data======
=====now instruction===== sw	$a0, 8($sp) |label: None
now content:sw	$a0, 8($sp)
======data======
=====now instruction===== sw	$t0, 12($sp) |label: None
now content:sw	$t0, 12($sp)
======data======
=====now instruction===== sw	$a1, 16($sp) |label: None
now content:sw	$a1, 16($sp)
======data======
=====now instruction===== sw	$a2, 20($sp) |label: None
now content:sw	$a2, 20($sp)
======data======
=====now instruction===== sw	$t1, 24($sp) |label: None
now content:sw	$t1, 24($sp)
======data======
=====now instruction===== add	$t0, $a0, $zero |label: None
now content:add	$t0, $a0, $zero
======data======
=====now instruction===== lw	$a0, 0($t0) |label: ['PRINT_STRING_LOOP']
now content:lw	$a0, 0($t0)
======data======
handling labellist ['PRINT_STRING_LOOP']
=====now instruction===== srl	$a0, $a0, 24 |label: None
now content:srl	$a0, $a0, 24
======data======
=====now instruction===== beq	$a0, $zero, PRINT_STRING_END_LOOP |label: None
now content:beq	$a0, $zero, PRINT_STRING_END_LOOP
======data======
=====now instruction===== jal	INT08_PRINT_CHAR |label: None
now content:jal	INT08_PRINT_CHAR
======data======
=====now instruction===== addi	$t0, $t0, 1 |label: None
now content:addi	$t0, $t0, 1
======data======
=====now instruction===== lw	$ra, 0($sp) |label: ['PRINT_STRING_END_LOOP']
now content:lw	$ra, 0($sp)
======data======
handling labellist ['PRINT_STRING_END_LOOP']
=====now instruction===== lw	$v0, 4($sp) |label: None
now content:lw	$v0, 4($sp)
======data======
=====now instruction===== lw	$a0, 8($sp) |label: None
now content:lw	$a0, 8($sp)
======data======
=====now instruction===== lw	$t0, 12($sp) |label: None
now content:lw	$t0, 12($sp)
======data======
=====now instruction===== lw	$a1, 16($sp) |label: None
now content:lw	$a1, 16($sp)
======data======
=====now instruction===== lw	$a2, 20($sp) |label: None
now content:lw	$a2, 20($sp)
======data======
=====now instruction===== lw	$t1, 24($sp) |label: None
now content:lw	$t1, 24($sp)
======data======
=====now instruction===== addi	$sp, $sp, 28 |label: None
now content:addi	$sp, $sp, 28
======data======
=====now instruction===== jr	$ra |label: None
now content:jr	$ra
======data======
=====now instruction===== addi	$sp, $sp, -12 |label: ['SHOW_CHAR']
now content:addi	$sp, $sp, -12
======data======
handling labellist ['SHOW_CHAR']
=====now instruction===== sw	$t0, 0($sp) |label: None
now content:sw	$t0, 0($sp)
======data======
=====now instruction===== sw	$a0, 4($sp) |label: None
now content:sw	$a0, 4($sp)
======data======
=====now instruction===== sw 	$t1, 8($sp) |label: None
now content:sw 	$t1, 8($sp)
======data======
=====now instruction===== sll	$a0, $a0, 3 |label: None
now content:sll	$a0, $a0, 3
======data======
=====now instruction===== add	$t0, $zero, $a2 |label: None
now content:add	$t0, $zero, $a2
======data======
=====now instruction===== sll	$t0, $t0, 7 |label: None
now content:sll	$t0, $t0, 7
======data======
=====now instruction===== add	$t0, $t0, $a1 |label: None
now content:add	$t0, $t0, $a1
======data======
=====now instruction===== sll	$t0, $t0, 2 |label: None
now content:sll	$t0, $t0, 2
======data======
=====now instruction===== lui $t1, 0x1000 |label: None
now content:lui $t1, 0x1000
======data======
=====now instruction===== or  $t0, $t0, $t1 |label: None
now content:or  $t0, $t0, $t1
======data======
=====now instruction===== sw	$a0, 0($t0) |label: None
now content:sw	$a0, 0($t0)
======data======
=====now instruction===== lw	$t0, 0($sp) |label: None
now content:lw	$t0, 0($sp)
======data======
=====now instruction===== lw	$a0, 4($sp) |label: None
now content:lw	$a0, 4($sp)
======data======
=====now instruction===== lw 	$t1, 8($sp) |label: None
now content:lw 	$t1, 8($sp)
======data======
=====now instruction===== addi	$sp, $sp, 12 |label: None
now content:addi	$sp, $sp, 12
======data======
=====now instruction===== jr	$ra |label: None
now content:jr	$ra
======data======
=====now instruction===== addi	$sp, $sp, -28 |label: ['INT08_PRINT_CHAR']
now content:addi	$sp, $sp, -28
======data======
handling labellist ['INT08_PRINT_CHAR']
=====now instruction===== sw	$ra, 0($sp) |label: None
now content:sw	$ra, 0($sp)
======data======
=====now instruction===== sw	$v0, 4($sp) |label: None
now content:sw	$v0, 4($sp)
======data======
=====now instruction===== sw	$a0, 8($sp) |label: None
now content:sw	$a0, 8($sp)
======data======
=====now instruction===== sw	$a1, 12($sp) |label: None
now content:sw	$a1, 12($sp)
======data======
=====now instruction===== sw	$a2, 16($sp) |label: None
now content:sw	$a2, 16($sp)
======data======
=====now instruction===== sw	$t0, 20($sp) |label: None
now content:sw	$t0, 20($sp)
======data======
=====now instruction===== sw	$t1, 24($sp) |label: None
now content:sw	$t1, 24($sp)
======data======
=====now instruction===== lui	$t0, 0xffff |label: None
now content:lui	$t0, 0xffff
======data======
=====now instruction===== lw	$a1, 0($t0) |label: None
now content:lw	$a1, 0($t0)
======data======
=====now instruction===== lw	$a2, 4($t0) |label: None
now content:lw	$a2, 4($t0)
======data======
=====now instruction===== addi	$t1, $zero, 13 |label: None
now content:addi	$t1, $zero, 13
======data======
=====now instruction===== bne	$a0, $t1, INT08_PRINT_CHAR_EXEC |label: None
now content:bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
======data======
=====now instruction===== add	$a1, $zero, $zero |label: None
now content:add	$a1, $zero, $zero
======data======
=====now instruction===== addi	$a2, $a2, 1 |label: None
now content:addi	$a2, $a2, 1
======data======
=====now instruction===== j	INT08_PRINT_CHAR_END |label: None
now content:j	INT08_PRINT_CHAR_END
======data======
=====now instruction===== jal	SHOW_CHAR |label: ['INT08_PRINT_CHAR_EXEC']
now content:jal	SHOW_CHAR
======data======
handling labellist ['INT08_PRINT_CHAR_EXEC']
=====now instruction===== addi	$a1, $a1, 1 |label: None
now content:addi	$a1, $a1, 1
======data======
=====now instruction===== lahi $t1,WEIGHT[high] |label: None
now content:lahi $t1,WEIGHT[high]
======data======
=====now instruction===== lalo $t1,$t1,WEIGHT[low] |label: None
now content:lalo $t1,$t1,WEIGHT[low]
======data======
=====now instruction===== lw	$t1, 0($t1) |label: None
now content:lw	$t1, 0($t1)
======data======
=====now instruction===== bne	$a1, $t1, INT08_PRINT_CHAR_END |label: None
now content:bne	$a1, $t1, INT08_PRINT_CHAR_END
======data======
=====now instruction===== add	$a1, $zero, $zero |label: None
now content:add	$a1, $zero, $zero
======data======
=====now instruction===== addi	$a2, $a2, 1 |label: None
now content:addi	$a2, $a2, 1
======data======
=====now instruction===== sw	$a1, 0($t0) |label: ['INT08_PRINT_CHAR_END']
now content:sw	$a1, 0($t0)
======data======
handling labellist ['INT08_PRINT_CHAR_END']
=====now instruction===== sw	$a2, 4($t0) |label: None
now content:sw	$a2, 4($t0)
======data======
=====now instruction===== lw	$ra, 0($sp) |label: None
now content:lw	$ra, 0($sp)
======data======
=====now instruction===== lw	$v0, 4($sp) |label: None
now content:lw	$v0, 4($sp)
======data======
=====now instruction===== lw	$a0, 8($sp) |label: None
now content:lw	$a0, 8($sp)
======data======
=====now instruction===== lw	$a1, 12($sp) |label: None
now content:lw	$a1, 12($sp)
======data======
=====now instruction===== lw	$a2, 16($sp) |label: None
now content:lw	$a2, 16($sp)
======data======
=====now instruction===== lw	$t0, 20($sp) |label: None
now content:lw	$t0, 20($sp)
======data======
=====now instruction===== lw	$t1, 24($sp) |label: None
now content:lw	$t1, 24($sp)
======data======
=====now instruction===== addi	$sp, $sp, 28 |label: None
now content:addi	$sp, $sp, 28
======data======
=====now instruction===== jr	$ra |label: None
now content:jr	$ra
======data======
=====now instruction===== .word	40 |label: ['WEIGHT']
now content:.word	40
======data======
data=40
temps=[40]
['00000000', '00000000', '00000000', '00101000']
=====now instruction===== .word	25 |label: ['HEIGHT']
now content:.word	25
======data======
data=25
temps=[25]
['00000000', '00000000', '00000000', '00011001']
=====now instruction===== .asciiz	"hello world!" |label: ['hi']
now content:.asciiz	"hello world!"
======data======
asciiz temp "helloworld!" helloworld!
['01101100', '01100100', '00100001', '00000000']
=====now instruction===== lahi $a0,hi[high] |label: ['KERNEL_INIT']
now content:lahi $a0,hi[high]
======data======
handling labellist ['KERNEL_INIT']
=====now instruction===== lalo $a0,$a0,hi[low] |label: None
now content:lalo $a0,$a0,hi[low]
======data======
=====now instruction===== lui $v0,0b0000000000000000 |label: None
now content:lui $v0,0b0000000000000000
======data======
=====now instruction===== ori $v0,$v0,0b0000000000000100 |label: None
now content:ori $v0,$v0,0b0000000000000100
======data======
=====now instruction===== syscall |label: None
now content:syscall
======data======
=====now instruction===== j   DEAD_LOOP |label: ['DEAD_LOOP']
now content:j   DEAD_LOOP
======data======
handling labellist ['DEAD_LOOP']
======label list======
INT08_PRINT_STRING[low]
INT08_SERVICE[low]
DEAD_LOOP[low]
SHOW_CHAR[low]
INT_SERVICES
INT_SERVICES[low]
DEAD_LOOP
PRINT_STRING_LOOP[high]
PRINT_STRING_END_LOOP[low]
PRINT_STRING_LOOP[low]
int08[low]
INT08_PRINT_CHAR_END[low]
KERNEL_INIT
INT_HANDLER[high]
INT08_PRINT_CHAR_END[high]
hi[low]
int08[high]
INT08_PRINT_CHAR_END
hi[high]
INT08_PRINT_CHAR[low]
int00[high]
PRINT_STRING_END_LOOP[high]
PRINT_STRING_END_LOOP
INT08_PRINT_STRING[high]
INT00_SERVICE[low]
INT00_SERVICE[high]
INT_HANDLER[low]
INT08_PRINT_CHAR_EXEC[low]
INT_SERVICES[high]
INT08_PRINT_STRING
KERNEL_INIT[high]
int00[low]
DEAD_LOOP[high]
PRINT_STRING_LOOP
WEIGHT[high]
INT08_PRINT_CHAR
INT08_SERVICE
INT08_PRINT_CHAR_EXEC
SHOW_CHAR[high]
INT_HANDLER
INT00_SERVICE
INT08_PRINT_CHAR[high]
INT08_SERVICE[high]
KERNEL_INIT[low]
HEIGHT[high]
WEIGHT[low]
SHOW_CHAR
HEIGHT[low]
INT08_PRINT_CHAR_EXEC[high]
======begin encode======
======now ins======lui $sp,0b0000000000000000
1
now trans:$sp,0b0000000000000000
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======ori $sp,$sp,0b1111111111111100
2
now trans:$sp,$sp,0b1111111111111100
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======lahi $t0,int00[high]
3
now trans:$t0,int00[high]
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
label: int00[high]
======now ins======lalo $t0,$t0,int00[low]
4
now trans:$t0,$t0,int00[low]
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
label: int00[low]
======now ins======lahi $t1,INT00_SERVICE[high]
5
now trans:$t1,INT00_SERVICE[high]
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: INT00_SERVICE[high]
======now ins======lalo $t1,$t1,INT00_SERVICE[low]
6
now trans:$t1,$t1,INT00_SERVICE[low]
begin coding each
now reg:rs
{}
now reg:$t1
sig=$t1
now reg code:01001
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: INT00_SERVICE[low]
======now ins======sw	$t1, 0($t0)
7
now trans:$t1,0($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======lahi $t0,int08[high]
8
now trans:$t0,int08[high]
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
label: int08[high]
======now ins======lalo $t0,$t0,int08[low]
9
now trans:$t0,$t0,int08[low]
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
label: int08[low]
======now ins======lahi $t1,INT08_SERVICE[high]
10
now trans:$t1,INT08_SERVICE[high]
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: INT08_SERVICE[high]
======now ins======lalo $t1,$t1,INT08_SERVICE[low]
11
now trans:$t1,$t1,INT08_SERVICE[low]
begin coding each
now reg:rs
{}
now reg:$t1
sig=$t1
now reg code:01001
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: INT08_SERVICE[low]
======now ins======sw	$t1, 0($t0)
12
now trans:$t1,0($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======j	KERNEL_INIT
13
now trans:KERNEL_INIT
begin coding each
00000000000000010000000000
00001000000000000000010000000000
======now ins======addi	$sp, $sp, -4
15
now trans:$sp,$sp,-4
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======sw		$ra, 0($sp)
16
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======mfc0	$k0, $13
17
now trans:$k0,$13
begin coding each
now reg:rs
{}
now reg:rt
{}
sig=$k0
now reg:rd
{}
sig=$13
now reg:shamt
{}
======now ins======andi	$k0, $k0, 0x007C
18
now trans:$k0,$k0,0x007C
begin coding each
now reg:rs
{}
now reg:$k0
sig=$k0
now reg code:11010
now reg:rt
{}
now reg:$k0
sig=$k0
now reg code:11010
======now ins======addi	$k0, $k0, 0x0100
19
now trans:$k0,$k0,0x0100
begin coding each
now reg:rs
{}
now reg:$k0
sig=$k0
now reg code:11010
now reg:rt
{}
now reg:$k0
sig=$k0
now reg code:11010
======now ins======lw		$k0, 0($k0)
20
now trans:$k0,0($k0)
begin coding each
now reg:rs
{}
now reg:$k0
sig=$k0
now reg code:11010
now reg:rt
{}
now reg:$k0
sig=$k0
now reg code:11010
======now ins======jalr	$k0, $ra
21
now trans:$k0,$ra
begin coding each
now reg:rs
{}
sig=$k0
now reg:rt
{}
now reg:rd
{}
sig=$ra
now reg:shamt
{}
======now ins======lw 		$ra, 0($sp)
22
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======addi 	$sp, $sp, 4
23
now trans:$sp,$sp,4
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======eret
24
now trans:
begin coding each
======now ins======addi	$sp, $sp, -16
37
now trans:$sp,$sp,-16
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======sw	$ra, 0($sp)
38
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======sw	$v0, 4($sp)
39
now trans:$v0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======sw	$a0, 8($sp)
40
now trans:$a0,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======sw	$t0, 12($sp)
41
now trans:$t0,12($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======addi	$t0, $zero, 4
42
now trans:$t0,$zero,4
begin coding each
now reg:rs
{}
now reg:$zero
sig=$zero
now reg code:00000
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======beq	$v0, $t0, INT08_PRINT_STRING
43
now trans:$v0,$t0,INT08_PRINT_STRING
begin coding each
now reg:rs
{}
now reg:$v0
sig=$v0
now reg code:00010
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
label: INT08_PRINT_STRING
143 134
======now ins======addi	$t0, $zero, 11
44
now trans:$t0,$zero,11
begin coding each
now reg:rs
{}
now reg:$zero
sig=$zero
now reg code:00000
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======beq	$v0, $t0, INT08_PRINT_CHAR
45
now trans:$v0,$t0,INT08_PRINT_CHAR
begin coding each
now reg:rs
{}
now reg:$v0
sig=$v0
now reg code:00010
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
label: INT08_PRINT_CHAR
183 136
======now ins======lw	$ra, 0($sp)
46
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======lw	$v0, 4($sp)
47
now trans:$v0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======lw	$a0, 8($sp)
48
now trans:$a0,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======lw	$t0, 12($sp)
49
now trans:$t0,12($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======addi	$sp, $sp, 16
50
now trans:$sp,$sp,16
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======jr	$ra
51
now trans:$ra
begin coding each
now reg:rs
{}
sig=$ra
now reg:rt
{}
now reg:rd
{}
now reg:shamt
{}
======now ins======addi	$sp, $sp, -28
52
now trans:$sp,$sp,-28
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======sw	$ra, 0($sp)
53
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======sw	$v0, 4($sp)
54
now trans:$v0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======sw	$a0, 8($sp)
55
now trans:$a0,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======sw	$t0, 12($sp)
56
now trans:$t0,12($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======sw	$a1, 16($sp)
57
now trans:$a1,16($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a1
sig=$a1
now reg code:00101
======now ins======sw	$a2, 20($sp)
58
now trans:$a2,20($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======sw	$t1, 24($sp)
59
now trans:$t1,24($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======add	$t0, $a0, $zero
60
now trans:$t0,$a0,$zero
begin coding each
now reg:rs
{}
sig=$a0
now reg:rt
{}
sig=$zero
now reg:rd
{}
sig=$t0
now reg:shamt
{}
======now ins======lw	$a0, 0($t0)
61
now trans:$a0,0($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======srl	$a0, $a0, 24
62
now trans:$a0,$a0,24
begin coding each
now reg:rs
{}
now reg:rt
{}
sig=$a0
now reg:rd
{}
sig=$a0
now reg:shamt
{}
======now ins======beq	$a0, $zero, PRINT_STRING_END_LOOP
63
now trans:$a0,$zero,PRINT_STRING_END_LOOP
begin coding each
now reg:rs
{}
now reg:$a0
sig=$a0
now reg code:00100
now reg:rt
{}
now reg:$zero
sig=$zero
now reg code:00000
label: PRINT_STRING_END_LOOP
157 154
======now ins======jal	INT08_PRINT_CHAR
64
now trans:INT08_PRINT_CHAR
begin coding each
00000000000000000010110111
00001100000000000000000010110111
======now ins======addi	$t0, $t0, 1
65
now trans:$t0,$t0,1
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======lw	$ra, 0($sp)
66
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======lw	$v0, 4($sp)
67
now trans:$v0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======lw	$a0, 8($sp)
68
now trans:$a0,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======lw	$t0, 12($sp)
69
now trans:$t0,12($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======lw	$a1, 16($sp)
70
now trans:$a1,16($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a1
sig=$a1
now reg code:00101
======now ins======lw	$a2, 20($sp)
71
now trans:$a2,20($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======lw	$t1, 24($sp)
72
now trans:$t1,24($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======addi	$sp, $sp, 28
73
now trans:$sp,$sp,28
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======jr	$ra
74
now trans:$ra
begin coding each
now reg:rs
{}
sig=$ra
now reg:rt
{}
now reg:rd
{}
now reg:shamt
{}
======now ins======addi	$sp, $sp, -12
75
now trans:$sp,$sp,-12
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======sw	$t0, 0($sp)
76
now trans:$t0,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======sw	$a0, 4($sp)
77
now trans:$a0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======sw 	$t1, 8($sp)
78
now trans:$t1,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======sll	$a0, $a0, 3
79
now trans:$a0,$a0,3
begin coding each
now reg:rs
{}
now reg:rt
{}
sig=$a0
now reg:rd
{}
sig=$a0
now reg:shamt
{}
======now ins======add	$t0, $zero, $a2
80
now trans:$t0,$zero,$a2
begin coding each
now reg:rs
{}
sig=$zero
now reg:rt
{}
sig=$a2
now reg:rd
{}
sig=$t0
now reg:shamt
{}
======now ins======sll	$t0, $t0, 7
81
now trans:$t0,$t0,7
begin coding each
now reg:rs
{}
now reg:rt
{}
sig=$t0
now reg:rd
{}
sig=$t0
now reg:shamt
{}
======now ins======add	$t0, $t0, $a1
82
now trans:$t0,$t0,$a1
begin coding each
now reg:rs
{}
sig=$t0
now reg:rt
{}
sig=$a1
now reg:rd
{}
sig=$t0
now reg:shamt
{}
======now ins======sll	$t0, $t0, 2
83
now trans:$t0,$t0,2
begin coding each
now reg:rs
{}
now reg:rt
{}
sig=$t0
now reg:rd
{}
sig=$t0
now reg:shamt
{}
======now ins======lui $t1, 0x1000
84
now trans:$t1,0x1000
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======or  $t0, $t0, $t1
85
now trans:$t0,$t0,$t1
begin coding each
now reg:rs
{}
sig=$t0
now reg:rt
{}
sig=$t1
now reg:rd
{}
sig=$t0
now reg:shamt
{}
======now ins======sw	$a0, 0($t0)
86
now trans:$a0,0($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======lw	$t0, 0($sp)
87
now trans:$t0,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======lw	$a0, 4($sp)
88
now trans:$a0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======lw 	$t1, 8($sp)
89
now trans:$t1,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======addi	$sp, $sp, 12
90
now trans:$sp,$sp,12
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======jr	$ra
91
now trans:$ra
begin coding each
now reg:rs
{}
sig=$ra
now reg:rt
{}
now reg:rd
{}
now reg:shamt
{}
======now ins======addi	$sp, $sp, -28
92
now trans:$sp,$sp,-28
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======sw	$ra, 0($sp)
93
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======sw	$v0, 4($sp)
94
now trans:$v0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======sw	$a0, 8($sp)
95
now trans:$a0,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======sw	$a1, 12($sp)
96
now trans:$a1,12($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a1
sig=$a1
now reg code:00101
======now ins======sw	$a2, 16($sp)
97
now trans:$a2,16($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======sw	$t0, 20($sp)
98
now trans:$t0,20($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======sw	$t1, 24($sp)
99
now trans:$t1,24($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======lui	$t0, 0xffff
100
now trans:$t0,0xffff
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======lw	$a1, 0($t0)
101
now trans:$a1,0($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$a1
sig=$a1
now reg code:00101
======now ins======lw	$a2, 4($t0)
102
now trans:$a2,4($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======addi	$t1, $zero, 13
103
now trans:$t1,$zero,13
begin coding each
now reg:rs
{}
now reg:$zero
sig=$zero
now reg code:00000
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
104
now trans:$a0,$t1,INT08_PRINT_CHAR_EXEC
begin coding each
now reg:rs
{}
now reg:$a0
sig=$a0
now reg code:00100
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: INT08_PRINT_CHAR_EXEC
199 195
======now ins======add	$a1, $zero, $zero
105
now trans:$a1,$zero,$zero
begin coding each
now reg:rs
{}
sig=$zero
now reg:rt
{}
sig=$zero
now reg:rd
{}
sig=$a1
now reg:shamt
{}
======now ins======addi	$a2, $a2, 1
106
now trans:$a2,$a2,1
begin coding each
now reg:rs
{}
now reg:$a2
sig=$a2
now reg code:00110
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======j	INT08_PRINT_CHAR_END
107
now trans:INT08_PRINT_CHAR_END
begin coding each
00000000000000000011001111
00001000000000000000000011001111
======now ins======jal	SHOW_CHAR
108
now trans:SHOW_CHAR
begin coding each
00000000000000000010100110
00001100000000000000000010100110
======now ins======addi	$a1, $a1, 1
109
now trans:$a1,$a1,1
begin coding each
now reg:rs
{}
now reg:$a1
sig=$a1
now reg code:00101
now reg:rt
{}
now reg:$a1
sig=$a1
now reg code:00101
======now ins======lahi $t1,WEIGHT[high]
110
now trans:$t1,WEIGHT[high]
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: WEIGHT[high]
======now ins======lalo $t1,$t1,WEIGHT[low]
111
now trans:$t1,$t1,WEIGHT[low]
begin coding each
now reg:rs
{}
now reg:$t1
sig=$t1
now reg code:01001
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: WEIGHT[low]
======now ins======lw	$t1, 0($t1)
112
now trans:$t1,0($t1)
begin coding each
now reg:rs
{}
now reg:$t1
sig=$t1
now reg code:01001
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======bne	$a1, $t1, INT08_PRINT_CHAR_END
113
now trans:$a1,$t1,INT08_PRINT_CHAR_END
begin coding each
now reg:rs
{}
now reg:$a1
sig=$a1
now reg code:00101
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
label: INT08_PRINT_CHAR_END
207 204
======now ins======add	$a1, $zero, $zero
114
now trans:$a1,$zero,$zero
begin coding each
now reg:rs
{}
sig=$zero
now reg:rt
{}
sig=$zero
now reg:rd
{}
sig=$a1
now reg:shamt
{}
======now ins======addi	$a2, $a2, 1
115
now trans:$a2,$a2,1
begin coding each
now reg:rs
{}
now reg:$a2
sig=$a2
now reg code:00110
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======sw	$a1, 0($t0)
116
now trans:$a1,0($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$a1
sig=$a1
now reg code:00101
======now ins======sw	$a2, 4($t0)
117
now trans:$a2,4($t0)
begin coding each
now reg:rs
{}
now reg:$t0
sig=$t0
now reg code:01000
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======lw	$ra, 0($sp)
118
now trans:$ra,0($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$ra
sig=$ra
now reg code:11111
======now ins======lw	$v0, 4($sp)
119
now trans:$v0,4($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======lw	$a0, 8($sp)
120
now trans:$a0,8($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
======now ins======lw	$a1, 12($sp)
121
now trans:$a1,12($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a1
sig=$a1
now reg code:00101
======now ins======lw	$a2, 16($sp)
122
now trans:$a2,16($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$a2
sig=$a2
now reg code:00110
======now ins======lw	$t0, 20($sp)
123
now trans:$t0,20($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t0
sig=$t0
now reg code:01000
======now ins======lw	$t1, 24($sp)
124
now trans:$t1,24($sp)
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$t1
sig=$t1
now reg code:01001
======now ins======addi	$sp, $sp, 28
125
now trans:$sp,$sp,28
begin coding each
now reg:rs
{}
now reg:$sp
sig=$sp
now reg code:11101
now reg:rt
{}
now reg:$sp
sig=$sp
now reg code:11101
======now ins======jr	$ra
126
now trans:$ra
begin coding each
now reg:rs
{}
sig=$ra
now reg:rt
{}
now reg:rd
{}
now reg:shamt
{}
======now ins======lahi $a0,hi[high]
134
now trans:$a0,hi[high]
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
label: hi[high]
======now ins======lalo $a0,$a0,hi[low]
135
now trans:$a0,$a0,hi[low]
begin coding each
now reg:rs
{}
now reg:$a0
sig=$a0
now reg code:00100
now reg:rt
{}
now reg:$a0
sig=$a0
now reg code:00100
label: hi[low]
======now ins======lui $v0,0b0000000000000000
136
now trans:$v0,0b0000000000000000
begin coding each
now reg:rs
{}
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======ori $v0,$v0,0b0000000000000100
137
now trans:$v0,$v0,0b0000000000000100
begin coding each
now reg:rs
{}
now reg:$v0
sig=$v0
now reg code:00010
now reg:rt
{}
now reg:$v0
sig=$v0
now reg code:00010
======now ins======syscall
138
now trans:
begin coding each
======now ins======j   DEAD_LOOP
139
now trans:DEAD_LOOP
begin coding each
00000000000000010000000101
00001000000000000000010000000101
loc!
0x00000000
lui $sp,0b0000000000000000
0
0x3c1d0000
ori $sp,$sp,0b1111111111111100
1
0x37bdfffc
lahi $t0,int00[high]
2
0x3c080000
lalo $t0,$t0,int00[low]
3
0x35080100
lahi $t1,INT00_SERVICE[high]
4
0x3c090000
lalo $t1,$t1,INT00_SERVICE[low]
5
0x35290200
sw	$t1, 0($t0)
6
0xad090000
lahi $t0,int08[high]
7
0x3c080000
lalo $t0,$t0,int08[low]
8
0x35080120
lahi $t1,INT08_SERVICE[high]
9
0x3c090000
lalo $t1,$t1,INT08_SERVICE[low]
10
0x35290200
sw	$t1, 0($t0)
11
0xad090000
j	KERNEL_INIT
12
0x8000400
loc!
0x00000080
addi	$sp, $sp, -4
32
0x23bdfffc
sw		$ra, 0($sp)
33
0xafbf0000
mfc0	$k0, $13
34
0x401a6800
andi	$k0, $k0, 0x007C
35
0x335a007c
addi	$k0, $k0, 0x0100
36
0x235a0100
lw		$k0, 0($k0)
37
0x8f5a0000
jalr	$k0, $ra
38
0x340f809
lw 		$ra, 0($sp)
39
0x8fbf0000
addi 	$sp, $sp, 4
40
0x23bd0004
eret
41
0x42000018
loc!
0x00000100
None
64
0x0
None
65
0x0
None
66
0x0
None
67
0x0
None
68
0x0
None
69
0x0
None
70
0x0
None
71
0x0
None
72
0x0
None
73
0x0
loc!
0x00000200
addi	$sp, $sp, -16
128
0x23bdfff0
sw	$ra, 0($sp)
129
0xafbf0000
sw	$v0, 4($sp)
130
0xafa20004
sw	$a0, 8($sp)
131
0xafa40008
sw	$t0, 12($sp)
132
0xafa8000c
addi	$t0, $zero, 4
133
0x20080004
beq	$v0, $t0, INT08_PRINT_STRING
134
0x10480008
addi	$t0, $zero, 11
135
0x2008000b
beq	$v0, $t0, INT08_PRINT_CHAR
136
0x1048002e
lw	$ra, 0($sp)
137
0x8fbf0000
lw	$v0, 4($sp)
138
0x8fa20004
lw	$a0, 8($sp)
139
0x8fa40008
lw	$t0, 12($sp)
140
0x8fa8000c
addi	$sp, $sp, 16
141
0x23bd0010
jr	$ra
142
0x3e00008
addi	$sp, $sp, -28
143
0x23bdffe4
sw	$ra, 0($sp)
144
0xafbf0000
sw	$v0, 4($sp)
145
0xafa20004
sw	$a0, 8($sp)
146
0xafa40008
sw	$t0, 12($sp)
147
0xafa8000c
sw	$a1, 16($sp)
148
0xafa50010
sw	$a2, 20($sp)
149
0xafa60014
sw	$t1, 24($sp)
150
0xafa90018
add	$t0, $a0, $zero
151
0x804020
lw	$a0, 0($t0)
152
0x8d040000
srl	$a0, $a0, 24
153
0x42602
beq	$a0, $zero, PRINT_STRING_END_LOOP
154
0x10800002
jal	INT08_PRINT_CHAR
155
0xc0000b7
addi	$t0, $t0, 1
156
0x21080001
lw	$ra, 0($sp)
157
0x8fbf0000
lw	$v0, 4($sp)
158
0x8fa20004
lw	$a0, 8($sp)
159
0x8fa40008
lw	$t0, 12($sp)
160
0x8fa8000c
lw	$a1, 16($sp)
161
0x8fa50010
lw	$a2, 20($sp)
162
0x8fa60014
lw	$t1, 24($sp)
163
0x8fa90018
addi	$sp, $sp, 28
164
0x23bd001c
jr	$ra
165
0x3e00008
addi	$sp, $sp, -12
166
0x23bdfff4
sw	$t0, 0($sp)
167
0xafa80000
sw	$a0, 4($sp)
168
0xafa40004
sw 	$t1, 8($sp)
169
0xafa90008
sll	$a0, $a0, 3
170
0x420c0
add	$t0, $zero, $a2
171
0x64020
sll	$t0, $t0, 7
172
0x841c0
add	$t0, $t0, $a1
173
0x1054020
sll	$t0, $t0, 2
174
0x84080
lui $t1, 0x1000
175
0x3c091000
or  $t0, $t0, $t1
176
0x1094025
sw	$a0, 0($t0)
177
0xad040000
lw	$t0, 0($sp)
178
0x8fa80000
lw	$a0, 4($sp)
179
0x8fa40004
lw 	$t1, 8($sp)
180
0x8fa90008
addi	$sp, $sp, 12
181
0x23bd000c
jr	$ra
182
0x3e00008
addi	$sp, $sp, -28
183
0x23bdffe4
sw	$ra, 0($sp)
184
0xafbf0000
sw	$v0, 4($sp)
185
0xafa20004
sw	$a0, 8($sp)
186
0xafa40008
sw	$a1, 12($sp)
187
0xafa5000c
sw	$a2, 16($sp)
188
0xafa60010
sw	$t0, 20($sp)
189
0xafa80014
sw	$t1, 24($sp)
190
0xafa90018
lui	$t0, 0xffff
191
0x3c08ffff
lw	$a1, 0($t0)
192
0x8d050000
lw	$a2, 4($t0)
193
0x8d060004
addi	$t1, $zero, 13
194
0x2009000d
bne	$a0, $t1, INT08_PRINT_CHAR_EXEC
195
0x14890003
add	$a1, $zero, $zero
196
0x2820
addi	$a2, $a2, 1
197
0x20c60001
j	INT08_PRINT_CHAR_END
198
0x80000cf
jal	SHOW_CHAR
199
0xc0000a6
addi	$a1, $a1, 1
200
0x20a50001
lahi $t1,WEIGHT[high]
201
0x3c090000
lalo $t1,$t1,WEIGHT[low]
202
0x35290900
lw	$t1, 0($t1)
203
0x8d290000
bne	$a1, $t1, INT08_PRINT_CHAR_END
204
0x14a90002
add	$a1, $zero, $zero
205
0x2820
addi	$a2, $a2, 1
206
0x20c60001
sw	$a1, 0($t0)
207
0xad050000
sw	$a2, 4($t0)
208
0xad060004
lw	$ra, 0($sp)
209
0x8fbf0000
lw	$v0, 4($sp)
210
0x8fa20004
lw	$a0, 8($sp)
211
0x8fa40008
lw	$a1, 12($sp)
212
0x8fa5000c
lw	$a2, 16($sp)
213
0x8fa60010
lw	$t0, 20($sp)
214
0x8fa80014
lw	$t1, 24($sp)
215
0x8fa90018
addi	$sp, $sp, 28
216
0x23bd001c
jr	$ra
217
0x3e00008
loc!
0x00000900
None
576
0x28
None
577
0x19
None
578
0x68656c6c
None
579
0x6f776f72
None
580
0x6c642100
loc!
0x00001000
lahi $a0,hi[high]
1024
0x3c040000
lalo $a0,$a0,hi[low]
1025
0x34840908
lui $v0,0b0000000000000000
1026
0x3c020000
ori $v0,$v0,0b0000000000000100
1027
0x34420004
syscall
1028
0xc
j   DEAD_LOOP
1029
0x8000405
maxloc 1024
