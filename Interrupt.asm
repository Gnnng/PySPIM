#############################
#Date: 2014/10/29           #
#Auth: Bai Long             #
#Func: OS on System         #
#############################
	# jump to MAIN function
.text(0x0000_0000)
#中断地址初始化
	#int00
	la	$t0, int00
	la	$t1, INT00_SERVICE
	sw	$t1, 0($t0)
	#int08
	la	$t0, int08
	la	$t1, INT08_SERVICE
	sw	$t1, 0($t0)
#跳转内核初始化
	j	KERNEL_INIT
#中断入口
INT_ALL:
	#使用$k0, $k1
	#$12: Status, $13: Cause, $14: EPC
	#$ra入栈
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	#状态寄存器Status的2~6位表示中断号
	mfc0	$k0, $12 #$12: Status
	andi	$k0, $k0, 0x007C #2~6位
	addi	$k0, $k0, 0x0100 #跳转中断
	lw	$k0, 0($k0)	 #取到地址
	jalr	$k0
	eret
.data(0x0000_0100)
#中断向量表
#初始化为0，每次开始运行程序时，将地址加载入相应存储单元
	int00:	.word	0 #all external interrupt
	int08:	.word	0 #syscall
.text(0x0000_0200)
#中断服务
INT_SERVICES:
INT00_SERVICE:
	#external interrupt
	...
INT08_SERVICE:
	#syscall
	#push $ra, $v0, $a0, $t0
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$v0, 4($sp)
	sw	$a0, 8($sp)
	sw	$t0, 12($sp)
	#print_int
	addi	$t0, $zero, 4
	beq	$v0, $t0, INT08_PRINT_STRING
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
	#push $ra, $v0, $a0, $t0
	
	#return
	jr	$ra
INT08_PRINT_CHAR:
	#push $ra, $v0, $a0, $t0
	
	#return
	jr	$ra
.data
	CRTadr	.word
	WEIGHT	.word
	HEIGHT	.word
	CursorX	.word
	CursorY	.word
.text(0x0000_1000)
#操作系统开始运行
KERNEL_INIT:
	