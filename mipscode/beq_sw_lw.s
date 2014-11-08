start:	add 	$t1, $zero, $zero
go:		lw 		$t2, 0($zero)
		lw 		$t4, 4($zero)
		sw 		$t2, 4($zero)
		sw 		$t4, 4($zero)
loop:	beq 	$t1, $t2, out
		add 	$t1, $t1, $t2
		j 		loop
out:	slt 	$t3, $zero, $t1
		j 		start
