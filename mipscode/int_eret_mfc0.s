.text
	j 		main
int_handler:
	mfc0 	$k0, $13
	lui 	$k1, 0xffff
	ori 	$k1, $k1, 0x0100
	lw 		$1, 0($k1)
	eret	
main:
	add 	$t0, $zero, $zero
loop:
	addi 	$t0, $t0, 1
	j 		loop
