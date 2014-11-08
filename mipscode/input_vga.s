.text
	j 		main
int_handler:
	mfc0 	$k0, $13
	lui 	$k1, 0xffff
	ori 	$k1, $k1, 0x0100
	lw 		$v0, 0($k1)
	sll 	$v0, $v0, 3
	sw 		$v0, 0($s0)
	addi 	$s0, $s0, 4
	eret
main:
	add 	$t0, $zero, $zero
	lui 	$s0, 0x1000
loop:
	addi 	$t0, $t0, 1
	j 		loop
