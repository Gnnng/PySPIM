.text
#################### shell area
gill:
		addi 	$sp, $zero, 0x5ffc
		jal 	clear 						# clear screen and init text cursor
		jal 	de_blink 					# enable cursor blink
		jal 	vga_text
		sw 		$zero, 0x4004($zero)		# clear vga image mode coordinate
		sw 		$zero, 0x4018($zero)		# clear shift flag
		sw 		$zero, 0x401c($zero)		# clear ctrl flag
		
		la 		$a0, boot01
		addi 	$a1, $zero, 7
		jal 	puts
		jal 	carriage_return
		
		la 		$a0, boot02
		jal 	gill_boot
		#jal 	getchar
		jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		la 		$a0, boot03
		jal 	gill_boot
		#jal 	getchar
		jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		la 		$a0, boot04
		jal 	gill_boot
		#jal 	getchar
		jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		la 		$a0, boot05
		jal 	gill_boot
		#jal 	getchar
		jal 	gill_test_led
		jal 	gill_test_led
		jal 	gill_test_led
		jal 	gill_test_led
		jal 	gill_test_led
		#jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		la 		$a0, boot06
		jal 	gill_boot
		#jal 	getchar
		jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		la 		$a0, boot07
		jal 	gill_boot
		jal 	gill_test_7seg
		#jal 	getchar
		jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		la 		$a0, boot08
		jal 	gill_boot
		#jal 	getchar
		jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		la 		$a0, boot09
		jal 	gill_boot
		#jal 	getchar
		jal 	timer_1s
		jal 	gill_boot_ok
		#jal 	carriage_return

		lui 	$a0, 0x0000
		ori 	$a0, $a0, 0x0000
		jal 	print7seg
		addi 	$a0, $zero, 0x0000
		jal 	print2led

		jal 	en_blink
gill_variable:
		addi 	$sp, $sp, -256
		add 	$gp, $zero, $sp 			# gp + 0 ~ gp + 63: input_string
gill_logo:
		jal 	carriage_return
		la 		$a0, logo01
		addi 	$a1, $zero, 7
		jal 	puts
		jal 	carriage_return
gill_login:
		jal 	carriage_return
		la 		$a0, login_name
		addi 	$a1, $zero, 7
		jal 	puts
		add 	$s1, $zero, $gp
		j 		gill_gets_none
gill_check_password:
		la 		$a0, password
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_loop_success
		la 	 	$a0, login_failure
		addi 	$a1, $zero, 4
		jal 	puts
		j 		gill_login
gill_loop_success:
		jal 	carriage_return
		la 	 	$a0, login_success
		addi 	$a1, $zero, 2
		jal 	puts
gill_loop_pre:
		jal 	carriage_return
gill_loop:
		la 		$a0, gill_hint
		addi 	$a1, $zero, 1			
		jal 	puts
		add 	$s1, $zero, $gp 			# init input_string[i]
		j 		gill_gets 					# not a call 
gill_checking:
		# test input
		add 	$a0, $zero, $s1
		jal 	print7seg
		# check empty string
		add 	$a0, $zero, $gp
		jal 	load_byte
		beq 	$v0, $zero, gill_loop_pre
		# check "help"
		la 		$a0, help_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_help
		# check "clear"
		la 		$a0, clear_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_clear
		# check "enblink"
		la 		$a0, enblink_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_enblink
		# check "deblink"
		la 		$a0, deblink_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_deblink
		# check "vgatext"
		la 		$a0, vgatext_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_vgatext
		# check "vgaimage"
		la 		$a0, vgaimage_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_vgaimage
		# check "ascii"
		la 		$a0, ascii_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_ascii
		
		# check "screentester"
		la 		$a0, screentester_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_screentester
		
		# check "box"
		la 		$a0, box_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_box

		# check "exit"
		la 		$a0, exit_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_exit

		# check "reboot"
		la 		$a0, reboot_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_reboot

		# check "skyfighter"
		la 		$a0, skyfighter_name
		add 	$a1, $zero, $gp
		jal 	strcmp 
		beq 	$v0, $zero, gill_call_skyfighter

		# default script
		j 		gill_call_default
gill_checking_end:
		j 		gill_loop_pre
gill_end:
		j		gill
# end of gill main code 

##################### some code pieces of gill
gill_call_reboot:
		jal 	clear
		j 	 	gill
gill_call_exit:
		j 		gill_logo
gill_call_help:
		jal 	help 
		j 		gill_checking_end
gill_call_default:
		jal 	default
		j 		gill_checking_end
gill_call_clear:
		jal 	clear
		#j 		gill_checking_end
		j 		gill_loop
gill_call_enblink:
		jal 	en_blink
		j 		gill_checking_end
gill_call_deblink:
		jal 	de_blink
		j 		gill_checking_end
gill_call_vgatext:
		jal 	vga_text
		j 		gill_checking_end
gill_call_vgaimage:
		jal 	vga_image
		j 		gill_checking_end
gill_call_ascii:
		jal 	ascii
		j 		gill_checking_end
gill_call_screentester:
		jal 	screentester
		j 		gill_checking_end
gill_call_box:
		jal 	box
		j 		gill_loop
gill_call_skyfighter:
		jal 	skyfighter
		j 		gill_checking_end

gill_gets:	
		jal 	getchar
		add 	$s0, $zero, $v0				# s0 - get a char
		addi 	$t0, $zero, 10
		beq 	$s0, $t0, gill_gets_end 	# get '\n' take back
		# save the char to input_string
		andi 	$a1, $s0, 0x00ff
		add 	$a0, $zero, $s1
		jal 	save_byte 					# save input_string[i]
		addi 	$t0, $zero, 8 				# check backspace
		beq 	$s0, $t0, gill_gets_backspace
		addi 	$s1, $s1, 1
		j 		gill_gets_display
gill_gets_backspace:
		addi 	$s1, $s1, -1
gill_gets_display:
		addi 	$t0, $zero, 0x5ffc
		beq 	$t0, $s1, gill_gets_backspace # trick
		add 	$a0, $zero, $s0
		addi 	$a1, $zero, 0x7
		jal 	putchar
		j 		gill_gets
gill_gets_end:
		add 	$a0, $zero, $s1
		add 	$a1, $zero, $zero
		jal 	save_byte 					# save end-of-str '\0'
		j 		gill_checking

gill_gets_none:	
		jal 	getchar
		add 	$s0, $zero, $v0				# s0 - get a char
		addi 	$t0, $zero, 10
		beq 	$s0, $t0, gill_gets_none_end 	# get '\n' take back
		# save the char to input_string
		andi 	$a1, $s0, 0x00ff
		add 	$a0, $zero, $s1
		jal 	save_byte 					# save input_string[i]
		addi 	$t0, $zero, 8 				# check backspace
		beq 	$s0, $t0, gill_gets_none_backspace
		addi 	$s1, $s1, 1
		j 		gill_gets_none_display
gill_gets_none_backspace:
		addi 	$s1, $s1, -1
gill_gets_none_display:
		addi 	$t0, $zero, 0x5ffc
		beq 	$t0, $s1, gill_gets_none_backspace # trick
		add 	$a0, $zero, $s0
		addi 	$a1, $zero, 0x7
		#jal 	putchar
		j 		gill_gets_none
gill_gets_none_end:
		add 	$a0, $zero, $s1
		add 	$a1, $zero, $zero
		jal 	save_byte 					# save end-of-str '\0'
		j 		gill_check_password
# subroutine of gill
gill_boot: 									# a0 - message
		addi 	$sp, $sp, -8
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		add 	$s0, $zero, $a0
		la 		$a0, boot_message
		addi 	$a1, $zero, 7
		jal 	puts
		add 	$a0, $zero, $s0
		addi 	$a1, $zero, 7
		jal 	puts
		#jal 	carriage_return
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		addi 	$sp, $sp, 8
		jr 		$ra

gill_boot_ok:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		jal 	get_text_cursor
		addi 	$a0, $zero, 1
		add 	$a1, $zero, $a1
		jal		put_text_cursor
		la 		$a0, boot_ok
		addi 	$a1, $zero, 2
		jal 	puts
		jal 	carriage_return
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra

gill_test_led:
		addi 	$sp, $sp, -8
		sw  	$s0, 4($sp)
		sw 		$ra, 0($sp)
		addi 	$s0, $zero, 0x80
gill_test_led_loop1:
		jal 	timer_1ms
		add 	$a0, $zero, $s0
		jal 	print2led
		srl 	$s0, $s0, 1
		bne 	$s0, $zero, gill_test_led_loop1
		addi 	$s0, $zero, 1
gill_test_led_loop2:
		jal 	timer_1ms
		add 	$a0, $zero, $s0
		jal 	print2led
		sll 	$s0, $s0, 1
		addi 	$t1, $zero, 0x80
		bne 	$s0, $t1, gill_test_led_loop2
		jal 	timer_1ms
		add 	$a0, $zero, $zero 
		jal 	print2led
		jal 	timer_1ms
		addi 	$a0, $zero, 0xff
		jal 	print2led
		add 	$a0, $zero, $zero
		jal 	print2led
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		addi 	$sp, $sp, 8
		jr 		$ra

gill_test_7seg:
		addi 	$sp, $sp, -8
		sw 		$ra, 0($sp)
		sw 		$s0, 4($s0)
		add 	$a0, $zero, $zero
		addi 	$t9, $zero, 0x040
gill_test_7seg_loop1:
		addi 	$t9, $t9, -1
		bne 	$t9, $zero, gill_test_7seg_loop1
		add 	$a0, $zero, $s0
		jal 	print7seg
		addi 	$s0, $s0, 1
		addi 	$t0, $zero, 0x7fff
		addi 	$t9, $zero, 0x040
		bne 	$s0, $t0, gill_test_7seg_loop1
		addi 	$a0, $zero, 0
		jal 	print7seg
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		addi 	$sp, $sp, 8
		jr 		$ra

#################### command area
# command: help - list all support commands and script
help:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		jal 	carriage_return

		la 		$a0, help_hint0
		addi 	$a1, $zero, 7
		jal 	puts
		jal 	carriage_return

		jal 	carriage_return
		# command list
		la 		$a0, help_hint1
		addi 	$a1, $zero, 3
		jal 	puts
		jal 	carriage_return
		jal 	carriage_return

		la 		$a0, exit_name
		jal 	help_info

		la  	$a0, reboot_name
		jal 	help_info 

		la 		$a0, clear_name
		jal 	help_info

		la 		$a0, enblink_name
		jal 	help_info

		la 		$a0, deblink_name
		jal 	help_info		

		la 		$a0, vgatext_name
		jal 	help_info

		la 		$a0, vgaimage_name
		jal 	help_info

		jal 	carriage_return
		# program list
		la 		$a0, help_hint2
		addi 	$a1, $zero, 6
		jal 	puts 
		jal 	carriage_return
		jal 	carriage_return

		la 		$a0, ascii_name
		jal 	help_info

		la 		$a0, box_name
		jal 	help_info

		la 		$a0, screentester_name
		jal 	help_info

		la 		$a0, skyfighter_name
		jal 	help_info

		jal 	carriage_return
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra
# subroutine of command help
help_info: 								# a0 - command/program name address
		addi 	$sp, $sp, -12
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		add 	$s0, $zero, $a0 		# s0 = a0
		addi 	$s1, $zero, 4
help_info_loop:
		jal 	space
		addi 	$s1, $s1, -1
		bne 	$s1, $zero, help_info_loop
		add 	$a0, $zero, $s0
		addi 	$a1, $zero, 7
		jal 	puts
		jal 	carriage_return
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		addi 	$sp, $sp, 12
		jr 		$ra

# command: clear - clear the screen
clear:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		jal 	clear_screen
		add 	$a0, $zero, $zero
		add 	$a1, $zero, $zero
		jal 	put_text_cursor
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra
# command: default - lastclear
default:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		jal 	carriage_return
		la 		$a0, default_hint
		addi 	$a1, $zero, 7
		jal 	puts
		jal 	carriage_return
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra

#################### program area

# program: skyfighter - a game
skyfighter:
		addi 	$sp, $sp, -40
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)				# control
		sw 		$s1, 8($sp)				# pos
		sw 		$s2, 12($sp) 			# plane status
		sw 		$s3, 16($sp) 			# fire number
		sw 		$gp, 20($sp)			# fire array
		sw 		$s4, 24($sp) 			# fire cd
		sw 		$s5, 28($sp) 			# loop in array
		sw 		$s6, 32($sp) 			# temp save
		sw 		$s7, 36($sp)			# stone moving timer
		addi 	$sp, $sp, -120
		add 	$gp, $sp, $zero
		jal 	de_blink
		jal 	clear_keyboard
		addi 	$s1, $zero, 0
		addi 	$s4, $zero, 0
		addi 	$s3, $zero, 0
		la 		$s2, plane
		addi	$s7, $zero, 0
		addi 	$at, $zero, 0 			# the score
skyfighter_init_galaxy:
		addi 	$s5, $zero, 0
skyfighter_init_galaxy_loop:
		jal 	sk_gen_galaxy
		sll 	$t1, $s5, 1
		sll 	$t1, $t1, 1
		addi 	$t1, $t1, 40
		add 	$t1, $gp, $t1
		sw 		$v0, 0($t1)
		addi 	$s5, $s5, 1
		addi 	$t1, $zero, 20		# generate stone in the same way
		bne 	$s5, $t1, skyfighter_init_galaxy_loop
skyfighter_loop:
		jal 	clear_screen
# draw galaxy 		gp + 40 ~ gp +76
		addi 	$s5, $zero, 0
sk_draw_galaxy_loop:
		sll 	$t1, $s5, 1
		sll 	$t1, $t1, 1
		addi 	$t1, $t1, 40
		add 	$t1, $gp, $t1
		lw 		$t2, 0($t1) 		# get pos
		lui 	$t3, 1
		and 	$t3, $t3, $t2 		# get enable bit
		bne  	$t3, $zero, sk_draw_galaxy_not
		andi 	$a1, $t2, 0x00ff 	# y
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		andi 	$a0, $t2, 0x00ff
		jal 	put_text_cursor
		addi 	$a0, $zero, 46
		addi 	$a1, $zero, 7
		jal 	putchar
sk_draw_galaxy_not:
		addi 	$s5, $s5, 1
		addi 	$t1, $zero, 10
		bne 	$s5, $t1, sk_draw_galaxy_loop
# draw stone 		gp + 80 ~ gp + 116
sk_draw_stone:
		addi 	$s5, $zero, 0
sk_draw_stone_loop:
		sll 	$t0, $s5, 1
		sll 	$t0, $t0, 1
		addi 	$t0, $t0, 80
		add 	$t0, $gp, $t0
		lw 		$t1, 0($t0)
		lui 	$t2, 1
		and 	$t3, $t2, $t1
		bne 	$t3, $zero, sk_draw_stone_not
		andi 	$a1, $t1, 0x00ff
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		andi 	$a0, $t1, 0x00ff
		jal 	put_text_cursor
		addi 	$a0, $zero, 64
		addi	$a1, $zero, 7
		jal 	putchar
sk_draw_stone_not:
		addi 	$s5, $s5, 1
		addi 	$t1, $zero, 10
		bne 	$s5, $t1, sk_draw_stone_loop
# draw plane 		gp ~ gp + 36
		add 	$a0, $zero, $zero
		add 	$a1, $zero, $s1
		jal 	put_text_cursor
		add 	$a0, $zero, $s2
		addi 	$a1, $zero, 6
		jal 	puts 					# draw plane
# draw fire
		beq 	$s3, $zero, sk_draw_fire_end
		addi 	$s5, $zero, 0
sk_draw_fire_loop:
		sll 	$t0, $s5, 1
		sll 	$t0, $t0, 1
		add 	$t0, $gp, $t0
		lw 		$t1, 0($t0)
		andi 	$a1, $t1, 0x00ff 		# t2 - y
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		sra 	$t1, $t1, 1
		andi 	$a0, $t1, 0x00ff 		# t1 - x
		jal 	put_text_cursor
		la 		$a0, fire
		addi 	$a1, $zero, 4
		jal 	puts
		addi 	$s5, $s5, 1
		bne 	$s5, $s3, sk_draw_fire_loop
sk_draw_fire_end:
# wait
		jal 	timer_1ms
		#jal 	timer_1ms
		#jal 	timer_1ms
		#jal 	timer_1ms
		#jal 	timer_1ms
# auto control

# control stone
		addi	$s7, $s7, 1 			# increase stone timer
		andi 	$t0, $s7, 0x0007
		bne 	$t0, $zero, sk_control_stone_end
		addi 	$s5, $zero, 0
sk_control_stone_loop:
		sll 	$t0, $s5, 1
		sll 	$t0, $t0, 1
		addi	$t0, $t0, 80
		add 	$s6, $gp, $t0
		lw 		$t1, 0($s6)
		addi 	$t1, $t1, -256
		lui 	$t4, 1
		and 	$t4, $t4, $t1
		bne 	$t4, $zero, sk_control_stone_insert
		j 		sk_control_stone_insert_end
sk_control_stone_insert:
		jal 	sk_gen_galaxy
		add 	$t1, $zero, $v0
sk_control_stone_insert_end:
		sw 		$t1, 0($s6)
# check impact
		andi 	$t2, $t1, 0xff00
		addi 	$t3, $zero, 0x0700
		beq 	$t2, $t3, sk_stone_impact_x
		j 		sk_control_stone_loop_continue		
sk_stone_impact_x:
		andi 	$t2, $t1, 0x00ff
		addi 	$t3, $s1, 3
		beq 	$t2, $t3, sk_stone_impact_y
		addi 	$t3, $s1, 4
		beq 	$t2, $t3, sk_stone_impact_y
		addi 	$t3, $s1, 5
		beq 	$t2, $t3, sk_stone_impact_y
		addi 	$t3, $s1, 6
		beq 	$t2, $t3, sk_stone_impact_y
		addi 	$t3, $s1, 7
		beq 	$t2, $t3, sk_stone_impact_y
		j 		sk_control_stone_loop_continue
sk_stone_impact_y:
		j 		skyfighter_dead
# continue loop
sk_control_stone_loop_continue:
		addi 	$s5, $s5, 1
		addi 	$t2, $zero, 10
		bne 	$s5, $t2, sk_control_stone_loop

sk_control_stone_end:
# control galaxy    decrease first, then update
		addi 	$s5, $zero, 0
sk_control_galaxy_loop:
		sll 	$t0, $s5, 1
		sll 	$t0, $t0, 1
		addi 	$t0, $t0, 40
		add 	$s6, $gp, $t0 			# save in temp save reg
		lw 		$t1, 0($s6)
		addi 	$t1, $t1, -256
		lui 	$t4, 1
		and 	$t4, $t4, $t1
		bne 	$t4, $zero, sk_control_galaxy_insert
		j 		sk_control_galaxy_insert_end
sk_control_galaxy_insert:
		jal 	sk_gen_galaxy
		add 	$t1, $zero, $v0
sk_control_galaxy_insert_end:
		sw 		$t1, 0($s6) 			# 
		addi 	$s5, $s5, 1
		addi 	$t2, $zero, 10
		bne 	$s5, $t2, sk_control_galaxy_loop
# control fires
		beq 	$s3, $zero, sk_auto_decrement
		addi 	$s5, $zero, 0
# check head fire
		lw 		$t0, 0($gp)
		addi 	$t1, $zero, 0x4600
		slt 	$t2, $t0, $t1
		bne 	$t2, $zero, sk_fire_update_loop
# delete head
		addi 	$t0, $zero, 1
sk_fire_delete_loop:
		sll 	$t1, $t0, 1
		sll 	$t1, $t1, 1
		add 	$t1, $gp, $t1
		lw 		$t2, 0($t1)
		addi 	$t1, $t1, -4
		sw 		$t2, 0($t1)
		beq 	$t0, $s3, sk_fire_delete_end
		addi 	$t0, $t0, 1
		j 		sk_fire_delete_loop
sk_fire_delete_end:
		addi 	$s3, $s3, -1
		beq 	$s3, $zero, sk_auto_decrement
sk_fire_update_loop:
		sll 	$t0, $s5, 1
		sll 	$t0, $t0, 1
		add 	$t0, $gp, $t0
		lw 		$t1, 0($t0)
		addi 	$t1, $t1, 0x0100		# x += 1
		sw 		$t1, 0($t0)
# check if engage
		add 	$a0, $zero, $t1
		jal 	sk_fire_engage 			# return destroy count
		add 	$at, $at, $v0
		addi 	$s5, $s5, 1
		bne 	$s5, $s3, sk_fire_update_loop
# auto decrement
sk_auto_decrement:
		beq 	$s4, $zero, sk_input_control
		addi 	$s4, $s4, -1
sk_input_control:
		lui 	$t0, 0xffff
		ori 	$t0, $t0, 0xff00
		lw 		$t2, 0($t0)
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		sra 	$t2, $t2, 1
		andi 	$t2, $t2, 0x0003
		add 	$a0, $zero, $t2
		add 	$s0, $zero, $a0
		jal 	print2led
		
		beq 	$s0, $zero, sk_mid # middle

		addi 	$t0, $zero, 1
		beq 	$s0, $t0, sk_left # up

		addi 	$t0, $zero, 2
		beq 	$s0, $t0, sk_right # down

		addi 	$t0, $zero, 3
		beq 	$s0, $t0, sk_fire
		j 		skyfighter_check_limit

sk_mid:
		la 		$s2, plane
		j 		skyfighter_check_limit

sk_left:
		la 		$s2, plane_left
		addi 	$s1, $s1, -1
		j 		skyfighter_check_limit

sk_right:
		la 		$s2, plane_right
		addi 	$s1, $s1, 1
		j 		skyfighter_check_limit

sk_fire:
		bne 	$s4, $zero, skyfighter_check_limit
sk_fire_insert:
		addi 	$t0, $zero, 5 			# max array size
		beq 	$s3, $t0, skyfighter_check_limit
		addi 	$t0, $zero, 7
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		add 	$t0, $s1, $t0
		addi 	$t0, $t0, 5
		sll 	$t1, $s3, 1
		sll 	$t1, $t1, 1
		add 	$t2, $gp, $t1
		sw 		$t0, 0($t2) 			# insert new fire
		addi 	$s4, $zero, 0x0008
		addi 	$s3, $s3, 1
		j 		skyfighter_check_limit

# sk limit
skyfighter_check_limit:
		slt 	$t0, $s1, $zero
		beq 	$t0, $zero, skyfighter_more
		add 	$s1, $zero, $zero		
skyfighter_more:
		addi 	$t0, $zero, 48
		slt 	$t1, $t0, $s1
		beq 	$t1, $zero, skyfighter_less
		addi 	$s1, $zero, 48
skyfighter_less:
		jal 	if_keyboard
		add 	$a0, $zero, $s4
		sll 	$a0, $a0, 1
		sll 	$a0, $a0, 1
		sll 	$a0, $a0, 1
		sll 	$a0, $a0, 1
		sll 	$a0, $a0, 1
		sll 	$a0, $a0, 1
		sll 	$a0, $a0, 1
		sll 	$a0, $a0, 1
		add 	$a0, $a0, $s3
		jal 	print7seg
		beq 	$v0, $zero, skyfighter_loop
# draw explosion
skyfighter_dead:
		add 	$a0, $zero, $at
		jal 	print7seg
		add 	$a0, $zero, $zero
		add 	$a1, $zero, $s1
		jal 	put_text_cursor
		la 		$a0, plane_exp01
		addi 	$a1, $zero, 6
		jal 	puts 					# draw plane
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		add 	$a0, $zero, $zero
		add 	$a1, $zero, $s1
		jal 	put_text_cursor
		la 		$a0, plane_exp02
		addi 	$a1, $zero, 6
		jal 	puts 					# draw plane
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		add 	$a0, $zero, $zero
		add 	$a1, $zero, $s1
		jal 	put_text_cursor
		la 		$a0, plane_exp03
		addi 	$a1, $zero, 6
		jal 	puts 					# draw plane
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		add 	$a0, $zero, $zero
		addi 	$a1, $zero, 26
		jal 	put_text_cursor
		la 		$a0, fail_name
		addi 	$a1, $zero, 4
		jal 	puts
		jal 	timer_1s
		jal 	timer_1s
		jal 	timer_1s
		jal 	timer_1s
		jal 	clear
		jal 	en_blink
		addi 	$sp, $sp, 120
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		lw 		$s3, 16($sp)
		lw 		$gp, 20($sp)
		lw 		$s4, 24($sp)
		lw 		$s5, 28($sp)
		lw 		$s6, 32($sp)
		lw 		$s7, 36($sp)
		addi 	$sp, $sp, 40
		jr 		$ra
# subroutine of skyfighter
sk_fire_engage:						# a0 - fire pos
		addi 	$sp, $sp, -16
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s3, 12($sp)
		addi 	$s0, $zero, 0 		# loop i
		addi 	$s1, $zero, 0 		# destroy count
sk_fire_engage_loop:
		sll 	$t0, $s0, 1
		sll 	$t0, $t0, 1
		addi 	$t0, $t0, 80
		add 	$s3, $gp, $t0
		lw		$t1, 0($s3) 		# s3 temp save
		beq 	$a0, $t1, sk_fire_engage_hit
		addi 	$a0, $a0, -256
		beq 	$a0, $t1, sk_fire_engage_hit
		j 		sk_fire_engage_hit_end
sk_fire_engage_hit:
		addi 	$s1, $s1, 1
		jal 	sk_gen_galaxy
		add 	$t1, $zero, $v0
sk_fire_engage_hit_end:
		sw 		$t1, 0($s3)
		addi 	$s0, $s0, 1
		addi 	$t1, $zero, 10
		bne 	$s0, $t1, sk_fire_engage_loop
		add 	$v0, $zero, $s1
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s3, 12($sp)
		addi 	$sp, $sp, 16
		jr 		$ra


# subroutine of skyfighter
sk_gen_galaxy:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		jal 	read_counter
		andi 	$t0, $v0, 0x0003
		beq 	$t0, $zero, sk_gen_galaxy_bad
		sra 	$v0, $v0, 1
		sra 	$v0, $v0, 1
		#sra 	$v0, $v0, 1
		andi 	$t0, $v0, 0x003f
		addi 	$t1, $zero, 60
		slt 	$t2, $t0, $t1
		bne 	$t2, $zero, sk_gen_galaxy_start
		addi 	$t0, $zero, 59
sk_gen_galaxy_start:
		addi 	$v0, $t0, 0x5000
		j 		sk_gen_galaxy_end
sk_gen_galaxy_bad:
		lui 	$v0, 1
sk_gen_galaxy_end:
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra



# program: ascii - print ascii table
ascii:
		addi 	$sp, $sp, -16
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s2, 12($sp)
		jal 	carriage_return
		addi 	$s0, $zero, 0 			# i
ascii_loop:
		addi 	$t2, $zero, 127
		beq 	$s0, $t2, ascii_end
		add 	$a0, $zero, $s0
		addi 	$a1, $zero, 7
		addi 	$t0, $zero, 8
		beq 	$s0, $t0, ascii_space
		addi 	$t0, $zero, 10
		beq 	$s0, $t0, ascii_space
		jal 	putchar
		andi 	$t3, $s0, 0x000f
		addi 	$t4, $zero, 0x000f
		bne 	$t3, $t4, ascii_continue
		jal 	carriage_return
ascii_continue:
		addi 	$s0, $s0, 1
		j 		ascii_loop
ascii_space:
		jal 	space
		addi 	$s0, $s0, 1
		j 		ascii_loop
ascii_end:
		jal 	carriage_return
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		addi 	$sp, $sp, 16
		jr 		$ra

# program: screentester
screentester:
		addi 	$sp, $sp, -16
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s2, 12($sp)	
		jal 	de_blink
		jal		clear_screen
		jal 	vga_image
		addi 	$s0, $zero, 0
		jal 	clear_keyboard
screentester_loop:
		jal 	if_keyboard
		bne 	$v0, $zero, screentester_loop_end
		andi 	$s0, $s0, 0xff
		add 	$a0, $zero, $s0
		jal 	draw_screen
		addi 	$s0, $s0, 1
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		jal 	timer_1ms
		j 		screentester_loop
screentester_loop_end:
		jal 	clear_keyboard
		jal 	en_blink
		jal 	vga_text
		jal 	clear
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		addi 	$sp, $sp, 16
		jr 		$ra

# program: box
box:
		addi 	$sp, $sp, -20
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s2, 12($sp)	
		sw 		$s3, 16($sp)
		jal 	de_blink
		jal 	vga_image
		jal 	clear
		addi 	$s0, $zero, 39				# center x
		addi 	$s1, $zero, 29				# center y
		addi 	$s2, $zero, 0 				# size
		addi 	$s3, $zero, 139
box_loop:		
		sub 	$a0, $s0, $s2
		sub 	$a1, $s1, $s2
		add 	$a2, $zero, $s2
		add 	$a3, $zero, $s3
		jal 	box_draw
		jal 	getchar
		addi 	$t0, $zero, 114
		beq 	$v0, $t0, box_r
		addi 	$t0, $zero, 103
		beq 	$v0, $t0, box_g
		addi 	$t0, $zero, 98
		beq 	$v0, $t0, box_b
		addi 	$t0, $zero, 106
		beq 	$v0, $t0, box_j
		addi 	$t0, $zero, 107
		beq 	$v0, $t0, box_k
		addi 	$t0, $zero, 0x80
		beq 	$v0, $t0, box_up
		addi 	$t0, $zero, 0x81
		beq 	$v0, $t0, box_down
		addi 	$t0, $zero, 0x82
		beq 	$v0, $t0, box_left
		addi 	$t0, $zero, 0x83
		beq 	$v0, $t0, box_right
		addi 	$t0, $zero, 27
		beq 	$v0, $t0, box_end
		j 		box_loop
box_up:
		lw 		$t0, 0x4018($zero)
		bne 	$t0, $zero, box_up_end
		addi 	$s1, $s1, -1
		j 		box_loop
box_up_end:
		addi 	$s2, $s2, -1
		j 		box_loop
box_down:
		lw 		$t0, 0x4018($zero)
		bne 	$t0, $zero, box_down_end
		addi 	$s1, $s1, 1
		j 		box_loop
box_down_end:
		addi 	$s2, $s2, 1
		j 		box_loop
box_left:
		addi 	$s0, $s0, -1
		j 		box_loop
box_right:
		addi 	$s0, $s0, 1
		j 		box_loop
box_r:
		andi 	$t1, $s3, 0xe0
		addi 	$t1, $t1, 0x20
		andi 	$t1, $t1, 0xe0
		andi 	$t2, $s3, 0xe0
		sub 	$s3, $s3, $t2
		add 	$s3, $s3, $t1
		j 		box_loop
box_g:
		andi 	$t1, $s3, 0x1c
		addi 	$t1, $t1, 0x04
		andi 	$t1, $t1, 0x1c
		andi 	$t2, $s3, 0x1c
		sub 	$s3, $s3, $t2
		add 	$s3, $s3, $t1
		j 		box_loop

box_b:
		andi 	$t1, $s3, 0x03
		addi 	$t1, $t1, 0x01
		andi 	$t1, $t1, 0x03
		andi 	$t2, $s3, 0x03
		sub 	$s3, $s3, $t2
		add 	$s3, $s3, $t1
		j 		box_loop
box_j:
		addi 	$s2, $s2, -1
		slt 	$t0, $s2, $zero
		beq 	$t0, $zero, box_j_eq0
		add 	$s2, $zero, $zero
box_j_eq0:
		j 		box_loop
box_k:
		addi 	$s2, $s2, 1
		j 		box_loop
box_end:
		jal 	en_blink
		jal 	vga_text
		jal 	clear
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		lw 		$s3, 16($sp)
		addi 	$sp, $sp, 20
		jr 		$ra

# subroutine of program box
box_draw:									# a0 - left, a1 - up, a2 - size, a3 - color
		addi 	$sp, $sp, -28
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s2, 12($sp)	
		sw 		$s3, 16($sp)
		sw 		$s4, 20($sp)
		sw 		$s5, 24($sp)
		add 	$s0, $zero, $a0
		add 	$s1, $zero, $a1
		add 	$s2, $zero, $a2
		add 	$s3, $zero, $a3
		#add 	$a2, $zero, $s3
		#jal 	draw_pixel
box_draw_check_x:
		slt 	$t0, $s0, $zero
		beq 	$t0, $zero, box_draw_check_y
		add 	$s0, $zero, $zero
box_draw_check_y:
		slt 	$t0, $s1, $zero
		beq 	$t0, $zero, box_draw_start
		add 	$s1, $zero, $zero
box_draw_start:
		add 	$s4, $zero, $s0
box_draw_loopi:	
		add 	$s5, $zero, $s1
		add 	$t0, $s0, $s2
		add 	$t0, $t0, $s2
		addi 	$t0, $t0, 1
		beq 	$s4, $t0, box_draw_end
box_draw_loopj:
		add 	$t0, $s1, $s2
		add 	$t0, $t0, $s2
		addi 	$t0, $t0, 1
		beq 	$s5, $t0, box_draw_loopj_end
		add 	$a0, $zero, $s4
		add 	$a1, $zero, $s5
		add 	$a2, $zero, $s3
		jal 	draw_pixel
		addi 	$s5, $s5, 1
		j 		box_draw_loopj
box_draw_loopj_end:
		addi 	$s4, $s4, 1
		j 		box_draw_loopi
box_draw_end:
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		lw 		$s3, 16($sp)
		lw 		$s4, 20($sp)
		lw 		$s5, 24($sp)
		addi 	$sp, $sp, 28
		jr 		$ra

#################### global function area
clear_keyboard:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		lui 	$t0, 0xffff
		ori 	$t0, $t0, 0xd000
		lui 	$t1, 10
		#addi 	$t1, $zero, 0x4000
clear_keyboard_loop:
		addi 	$t1, $t1, -1
		lw 		$t2, 0($t0)
		bne 	$t1, $zero, clear_keyboard_loop
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra

if_keyboard:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		lui 	$t0, 0xffff
		ori	 	$t0, $t0, 0xd000
		lw 		$t1, 0($t0)
		slt 	$v0, $t1, $zero
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra

# global function: draw_screen
draw_screen:								# a0 - color
		addi 	$sp, $sp, -28
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s2, 12($sp)
		sw 		$s3, 16($sp)
		sw 		$s4, 20($sp)
		sw 		$s5, 24($sp)
		add 	$s0, $zero, $a0
		lui		$t0, 0xc 
		lui 	$t1, 1
		sra 	$t1, $t1, 1
draw_screen_loop:
		addi 	$t1, $t1, -4
		add 	$t2, $t1, $t0
		sw 		$s0, 0($t2)
		bne 	$t1, $zero, draw_screen_loop
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		lw 		$s3, 16($sp)
		lw 		$s4, 20($sp)
		lw 		$s5, 24($sp)
		addi 	$sp, $sp, 28
		jr 		$ra
# global function: draw_pixel
draw_pixel: 								# a0 - x, a1 - y, a2 - color
		addi 	$sp, $sp, -8
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		lui 	$t0, 0x000c
		add 	$t1, $zero, $a1
		sll 	$t1, $t1, 1
		sll 	$t1, $t1, 1
		sll 	$t1, $t1, 1
		sll 	$t1, $t1, 1
		sll 	$t1, $t1, 1
		sll 	$t1, $t1, 1
		sll 	$t1, $t1, 1
		add 	$t1, $t1, $a0
		sll 	$t1, $t1, 1
		sll 	$t1, $t1, 1
		add 	$t0, $t0, $t1
		sw 		$a2, 0($t0)
		add 	$a0, $zero, $t0
		jal 	print7seg
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		addi 	$sp, $sp, 8
		jr 		$ra
# global function: space
space:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		addi 	$a0, $zero, 32
		addi 	$a1, $zero, 0
		jal 	putchar 					# putchar '\n'
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra
# global function: carriage_return
carriage_return:
		addi 	$sp, $sp, -4
		sw 		$ra, 0($sp)
		addi 	$a0, $zero, 10
		addi 	$a1, $zero, 0
		jal 	putchar 					# putchar '\n'
		lw 		$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 		$ra
# global function: load_byte
load_byte: 								# a0 - address of byte
		andi 	$t2, $a0, 0x0003 		# offset
		srl 	$t0, $a0, 1
		srl 	$t0, $t0, 1
		sub 	$a0, $a0, $t2
		lw 		$t1, 0($a0)
		sub 	$t2, $zero, $t2
		addi 	$t2, $t2, 3			# time to shift 
		addi 	$t3, $zero, 0
load_byte_loop:
		beq 	$t2, $zero, load_byte_end
		srl 	$t1, $t1, 1
		srl 	$t1, $t1, 1
		srl 	$t1, $t1, 1
		srl 	$t1, $t1, 1
		srl 	$t1, $t1, 1
		srl 	$t1, $t1, 1
		srl 	$t1, $t1, 1
		srl 	$t1, $t1, 1
		addi 	$t2, $t2, -1
		j 		load_byte_loop
load_byte_end:
		andi 	$v0, $t1, 0x00ff
		jr 		$ra
		
# global function: save_byte
save_byte: 								# a0 - addres of byte, a1 - data
		andi 	$a1, $a1, 0x00ff
		andi 	$t2, $a0, 0x0003
		srl 	$t0, $a0, 1
		srl 	$t0, $t0, 1
		sub 	$a0, $a0, $t2
		lw 		$t1, 0($a0)
		sub 	$t2, $zero, $t2
		addi 	$t2, $t2, 3
		addi 	$t3, $zero, 0x00ff 		# t3 - mask
save_byte_loop:
		beq 	$t2, $zero, save_byte_end
		sll 	$a1, $a1, 1
		sll 	$a1, $a1, 1
		sll 	$a1, $a1, 1
		sll 	$a1, $a1, 1
		sll 	$a1, $a1, 1
		sll 	$a1, $a1, 1
		sll 	$a1, $a1, 1
		sll 	$a1, $a1, 1
		sll 	$t3, $t3, 1
		sll 	$t3, $t3, 1
		sll 	$t3, $t3, 1
		sll 	$t3, $t3, 1
		sll 	$t3, $t3, 1
		sll 	$t3, $t3, 1
		sll 	$t3, $t3, 1
		sll 	$t3, $t3, 1
		addi 	$t2, $t2, -1
		j 		save_byte_loop
save_byte_end:
		addi 	$t4, $zero, -1
		sub 	$t4, $t4, $t3
		and  	$t1, $t1, $t4 
		or 		$t1, $t1, $a1
		sw 	 	$t1, 0($a0)
		jr 		$ra
# global function: strcmp
strcmp: 								# a0 - str1, a1 - str2
		addi 	$sp, $sp, -20
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s2, 12($sp)
		sw 		$s3, 16($sp)	
		add 	$s0, $zero, $a0	
		add 	$s1, $zero, $a1
strcmp_loop:
		add 	$a0, $zero, $s0
		jal 	load_byte
		add 	$s2, $zero, $v0 		# *str1
		add 	$a0, $zero, $s1
		jal 	load_byte
		add 	$s3, $zero, $v0 		# *str2
		sub 	$t0, $s2, $s3
		addi 	$s0, $s0, 1
		addi 	$s1, $s1, 1
strcmp_check:
		bne 	$s2, $zero, strcmp_not_zero
		bne 	$s3, $zero, strcmp_not_zero
		# double zero end
		j 		strcmp_end 
strcmp_not_zero:
		beq 	$t0, $zero, strcmp_loop
strcmp_end:
		add 	$v0, $zero, $t0
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		lw 		$s3, 16($sp)	
		addi 	$sp, $sp, 20
		jr 		$ra

# global function: screen_scroll
screen_scroll:
# 	for(i = 0; i != 59; i++) {
#		for(j = 0; j != 80; j++)
# 			vram[i][j] = vram[i+1][j];
#	}
#   for(k = 0; k != 80; k++)
# 		vram[59][k] = 0;
		addi 	$sp, $sp, -20
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)
		sw 		$s1, 8($sp)
		sw 		$s2, 12($sp)
		sw 		$s3, 16($sp)
		lui 	$t0, 0x000c 			# vram base address
		add 	$t1, $zero, $zero 		# vram offset address
		add 	$s0, $zero, $zero		# i
		addi 	$s1, $zero, 59			# i limit 
screen_scroll_loopi:
		add 	$s2, $zero, $zero		# j
		addi 	$s3, $zero, 80 			# j limit
		andi 	$t1, $t1, 0xfe00 		# clear i 
screen_scroll_loopj:
		add 	$t2, $t0, $t1 			# base + offset [i][j]
		addi 	$t3, $t2, 0x0200 	 	# base + offset [i+1][j]
		lw 		$t4, 0($t3)
		sw 		$t4, 0($t2) 			# vram[i][j] = vram[i+1][j]
		addi 	$s2, $s2, 1
		addi 	$t1, $t1, 4
		beq 	$s2, $s3, screen_scroll_loopj_end
		j 		screen_scroll_loopj
screen_scroll_loopj_end:
		addi 	$s0, $s0, 1
		addi 	$t1, $t1, 0x0200
		beq 	$s0, $s1, screen_scroll_loopi_end
		j 		screen_scroll_loopi
screen_scroll_loopi_end:
		add 	$s2, $zero, $zero
		andi 	$t1, $t1, 0xfe00
		#addi 	$t1, $t1, 0x0200
screen_scroll_wipe_last:
		add 	$t2, $t0, $t1
		sw 		$zero, 0($t2)
		addi 	$s2, $s2, 1
		addi 	$t1, $t1, 4
		beq 	$s2, $s3, screen_scroll_end
		j 		screen_scroll_wipe_last
screen_scroll_end:
		jal 	get_text_cursor
		add 	$a0, $zero, $v0
		addi 	$a1, $v1, -1 			# not check a1 < 0
		jal 	put_text_cursor
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		lw 		$s3, 16($sp)		
		addi 	$sp, $sp, 20
		jr 		$ra

# global function vga_text
vga_text:
		lw 		$t0, 0x4000($zero)
		lui 	$t1, 0xfffe
		addi 	$t1, $t1, -1
		and 	$t0, $t0, $t1
		sw 		$t0, 0x4000($zero)
		lui 	$t1, 0xffff
		ori 	$t1, $t1, 0xff00
		sw 		$t0, 0($t1)
		jr 		$ra


# global function vga_image
vga_image:
		lw 		$t0, 0x4000($zero)
		lui 	$t1, 2
		or  	$t0, $t0, $t1
		sw 		$t0, 0x4000($zero)
		lui 	$t1, 0xffff
		ori 	$t1, $t1, 0xff00
		sw 		$t0, 0($t1)
		jr 		$ra

# global function en_blink
en_blink:
		lw 		$t0, 0x4000($zero)
		lui 	$t1, 0xffff
		addi 	$t1, $t1, -1
		and 	$t0, $t0, $t1
		sw 		$t0, 0x4000($zero)
		lui 	$t1, 0xffff
		ori 	$t1, $t1, 0xff00
		sw 		$t0, 0($t1)
		jr 		$ra
# global function de_blink
de_blink:
		lw 		$t0, 0x4000($zero)
		lui 	$t1, 1
		or  	$t0, $t0, $t1
		sw 		$t0, 0x4000($zero)
		lui 	$t1, 0xffff
		ori 	$t1, $t1, 0xff00
		sw 		$t0, 0($t1)
		jr 		$ra
		
# global function: get_text_cursor
get_text_cursor:
		lw 		$t0, 0x4000($zero)		# get cursor 
		andi	$v0, $t0, 0x00ff		# s0: get x of cursor
		sra 	$t0, $t0, 1
		sra 	$t0, $t0, 1
		sra 	$t0, $t0, 1
		sra 	$t0, $t0, 1
		sra 	$t0, $t0, 1
		sra 	$t0, $t0, 1
		sra 	$t0, $t0, 1
		sra 	$t0, $t0, 1
		andi 	$v1, $t0, 0x00ff		# s1: get y from cursor
		jr 		$ra

# global function: put_text_cursor
put_text_cursor:
		slt 	$t0, $a0, $zero 		# x < 0
		beq 	$t0, $zero, put_text_cursor_ready
		add 	$a0, $zero, $zero
		slt 	$t0, $a1, $zero
		beq 	$t0, $zero, put_text_cursor_ready
		add 	$a1, $zero, $zero
put_text_cursor_ready:
		add 	$t0, $zero, $a1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		add 	$t0, $t0, $a0			# new cursor pos
		lw 		$t1, 0x4000($zero)
		lui 	$t2, 0xffff
		and     $t1, $t2, $t1
		add 	$t1, $t0, $t1
		sw 		$t1, 0x4000($zero) 		# save the cursor
		lui 	$t0, 0xffff
		ori 	$t0, $t0, 0xff00
		sw 		$t1, 0($t0) 			# map to GPIO
		#lui 	$t1, 0xffff
		#ori 	$t1, $t1, 0xff00
		#lw 		$t2, 0($t1) 			# get cursor from GPIO
		#lui 	$t3, 0xffff
		#and 	$t3, $t2, $t3
		#add 	$t2, $t0, $t3
		#sw 		$t2, 0($t1) 			# save the cursor to GPIO
		jr 		$ra

# global function: read_counter			
read_counter:
		lui 	$t0, 0xffff
		ori 	$t0, $t0, 0xfe00
		lw 		$v0, 0($t0)
		jr 		$ra

# global function: print7seg
print7seg: 								# a0 - content to be print
		lui 	$t0, 0xffff
		ori 	$t0, $t0, 0xfe00
		sw 		$a0, 0($t0)
		jr 		$ra

# global function: print2led
print2led:								# a0 - content to be print
		lw 		$t1, 0x4000($zero)
		lui 	$t2, 0x00ff
		ori 	$t2, $t2, 0xffff
		and 	$t1, $t1, $t2
		addi 	$t3, $zero, 24
print2led_loop:
		addi 	$t3, $t3, -1
		sll 	$a0, $a0, 1
		bne 	$t3, $zero, print2led_loop
		add 	$t1, $a0, $t1
		lui 	$t0, 0xffff
		ori 	$t0, $t0, 0xff00
		sw 		$t1, 0($t0)
		sw 		$t1, 0x4000($zero)
		jr 		$ra

# global function: clear screen
#clear_screen:
#		lui		$t0, 0xc 
#		lui 	$t1, 1
#		sra 	$t1, $t1, 1
#clear_screen_loop:
#		addi 	$t1, $t1, -4
#		add 	$t2, $t1, $t0
#		sw 		$zero, 0($t2)
#		bne 	$t1, $zero, clear_screen_loop
#		jr		$ra
#

clear_screen:
		lui 	$t0, 0xc
		add 	$t1, $zero, $t0
		ori 	$t0, $t0, 0x8000
clear_screen_loop:
		addi 	$t0, $t0, -4
		sw 		$zero, 0($t0)
		bne 	$t0, $t1, clear_screen_loop
		jr 		$ra

# global function: getchar
getchar:
		addi 	$sp, $sp, -20
		sw 		$s0, 0($sp)
		sw 		$s1, 4($sp)
		sw 		$ra, 8($sp)
		sw 		$s3, 12($sp)
		sw 		$s2, 16($sp)
		lui 	$s3, 0xffff
		ori 	$s3, $s3, 0xd000
		lw 		$s0, 0x4018($zero)	# 0x0000 4018 shift flag
getchar_start:	
		jal     read_scan_code
		add 	$s1, $zero, $v0 	# get key code
		addi 	$t0, $zero, 0xf0
		bne 	$t0, $s1, make_code	# not break code
break_code:
		jal 	read_scan_code		# read again
		add 	$a0, $zero, $v0		# argument for shift check
		jal 	if_shift
		bne 	$v0, $zero, shift_dis
		j 		getchar_start

shift_dis:
		add 	$s0, $zero, $zero
		j 		getchar_start
shift_en:
		addi    $s0, $zero, 32
		j       getchar_start
make_code:
		add 	$a0, $zero, $s1
		jal 	if_shift
		bne 	$v0, $zero, shift_en
		add 	$a0, $zero, $s1
		jal 	get_ascii
		beq 	$v0, $zero, getchar_start
		addi 	$t0, $zero, 48 		# [48, 58) number area
		addi    $t1, $zero, 58
		addi 	$t2, $zero, 97 		# [97, 123) letter area
		addi 	$t3, $zero, 123
		slt 	$t0, $v0, $t0 		# < 48
		addi 	$t0, $t0, -1
		slt 	$t0, $t0, $zero
		# nor 	$t0, $t0, $zero		# >= 48
		slt 	$t1, $v0, $t1		# < 58
		and 	$t0, $t0, $t1 		# 48 <= $v0 < 58
		bne 	$t0, $zero, char_number
		slt 	$t2, $v0, $t2		# < 97
		addi 	$t2, $t2, -1
		slt 	$t2, $t2, $zero
		# nor 	$t2, $t2, $zero 	# >= 97
		slt 	$t3, $t0, $t3		# < 123
		and 	$t2, $t2, $t3	 	# 97 <= $v0 < 123
		bne 	$t2, $zero, char_abc
char_symbol:
		beq 	$s0, $zero, getchar_exit
		add 	$t0, $zero, $v0
		addi 	$v0, $zero, 0x7e	# ~
		xori 	$t1, $t0, 96		# `
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 95		# _
		xori 	$t1, $t0, 45		# -
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 43		# +
		xori 	$t1, $t0, 61		# =
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 123		# {
		xori 	$t1, $t0, 91		# [
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 125		# }
		xori 	$t1, $t0, 93		# ]
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 124		# |
		xori 	$t1, $t0, 92		# \
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 58		# :
		xori 	$t1, $t0, 59		# ;
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 34		# "
		xori 	$t1, $t0, 39		# '
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 60		# <
		xori 	$t1, $t0, 44		# ,
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 62		# >
		xori 	$t1, $t0, 46		# .
		beq 	$t1, $zero, getchar_exit
		addi 	$v0, $zero, 63		# ?
		xori 	$t1, $t0, 47		# /
		beq 	$t1, $zero, getchar_exit
		add 	$v0, $zero, $t0
		j 		getchar_exit
char_number:
		beq 	$s0, $zero, getchar_exit # not shift
		add 	$t0, $zero, $v0
		addi 	$t1, $zero, 48
		addi 	$v0, $zero, 41 		# )
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 33 		# !
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 64 		# @
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 35		# #
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 36 		# $
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 37 		# %
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 94 		# ^
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 38 		# &
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 42		# *
		beq 	$t0, $t1, getchar_exit
		addi 	$t1, $t1, 1
		addi 	$v0, $zero, 40 		# (
		beq 	$t0, $t1, getchar_exit
		j 		getchar_exit
char_abc:
		sub 	$v0, $v0, $s0
		j 		getchar_exit
getchar_exit:
		sw 		$s0, 0x4018($zero) 	# write back shiftflag
		lw 		$s0, 0($sp)
		lw 		$s1, 4($sp)
		lw 		$ra, 8($sp)
		lw 		$s3, 12($sp)
		lw 		$s2, 16($sp)
		addi 	$sp, $sp, 20
		jr 		$ra
# sub func of getchar
if_shift:
		addi 	$v0, $zero, 0x12
		beq 	$a0, $v0, true_return
		addi 	$v0, $zero, 0x59
		beq 	$a0, $v0, true_return
		addi 	$v0, $zero, 0
		jr 		$ra
true_return:
		addi 	$v0, $zero, 1
		jr 		$ra

# sub func of getchar
read_scan_code:
scan_loop:	
		lw		$t0, 0($s3) 		# not good design
		slt		$t1, $t0, $zero		# check sign bit
		andi 	$v0, $t0, 0xff
		beq     $t1, $zero, scan_loop
		addi    $t0, $zero, 0xe0 	# pass e0
		beq 	$v0, $t0, scan_loop
		jr		$ra

# sub func of getchar
get_ascii:
		addi 	$v0, $zero, 48
		xori 	$t0, $a0, 0x45 		# 0
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x16 		# 1
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x1e 		# 2
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x26 		# 3
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x25 		# 4
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x2e 		# 5
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x36 		# 6
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x3d 		# 7
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x3e 		# 8
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x46 		# 9
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 97
		xori	$t0, $a0, 0x1c		# a
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x32		# b
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x21 		# c
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x23 		# d
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x24 		# e
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x2b		# f
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x34		# g
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x33		# h
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x43		# i
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x3b		# j
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x42		# k
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x4b		# l
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x3a		# m
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x31		# n
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x44		# o
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x4d		# p
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x15		# q
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x2d		# r
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x1b		# s
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x2c		# t
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x3c		# u
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x2a		# v
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x1d		# w
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x22		# x
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x35		# y
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $v0, 1
		xori 	$t0, $a0, 0x1a		# z
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 96
		xori 	$t0, $a0, 0x0e 		# `
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 45
		xori 	$t0, $a0, 0x4e 		# -
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 61
		xori 	$t0, $a0, 0x55 		# =
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 8
		xori 	$t0, $a0, 0x66 		# backspace
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 32
		xori 	$t0, $a0, 0x29 		# space
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 9
		xori 	$t0, $a0, 0x0d 		# tab
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 10
		xori 	$t0, $a0, 0x5a 		# enter
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 27
		xori 	$t0, $a0, 0x76 		# esc
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 91
		xori 	$t0, $a0, 0x54 		# [
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 93
		xori 	$t0, $a0, 0x5b 		# ]
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 59
		xori 	$t0, $a0, 0x4c 		# ;
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 39
		xori 	$t0, $a0, 0x52 		# '
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 44
		xori 	$t0, $a0, 0x41 		# ,
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 46
		xori 	$t0, $a0, 0x49 		# .
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 47
		xori 	$t0, $a0, 0x4a 		# /
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 92			
		xori 	$t0, $a0, 0x5d 		# \
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 0x80			
		xori 	$t0, $a0, 0x75 		# up
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 0x81
		xori 	$t0, $a0, 0x72 		# down
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 0x82
		xori 	$t0, $a0, 0x6b 		# left
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 0x83
		xori 	$t0, $a0, 0x74 		# right
		beq 	$t0, $zero, get_ascii_exit
		addi 	$v0, $zero, 0
get_ascii_exit:
		jr 		$ra


# global function puts
puts:								# a0 - string address, a1 - color
		addi 	$sp, $sp, -20
		sw 		$ra, 0($sp) 		
		sw 		$s0, 4($sp)			# s0 - index of word within string
		sw 		$s1, 8($sp)			# s1 - string color
		sw 		$s2, 12($sp)		# s2 - current word
		sw 		$s3, 16($sp) 		# s3 - index of letter within current word
		add 	$s0, $zero, $a0 	# s0 = a0
		add 	$s1, $zero, $a1 	# s1 = a1
		add 	$s3, $zero, $zero	# loop in word
puts_loop:
		lw 		$s2, 0($s0)			# get current word
		add 	$t0, $zero, $s2 	# t0 = s2
		addi 	$t1, $zero, 3
		sub 	$t1, $t1, $s3		# t1 = 3 - s3
puts_shift_right:
		beq 	$t1, $zero, puts_shift_end
		srl 	$t0, $t0, 1
		srl 	$t0, $t0, 1
		srl 	$t0, $t0, 1
		srl 	$t0, $t0, 1
		srl 	$t0, $t0, 1
		srl 	$t0, $t0, 1
		srl 	$t0, $t0, 1
		srl 	$t0, $t0, 1
		addi 	$t1, $t1, -1
		j 		puts_shift_right
puts_shift_end:
		andi 	$t0, $t0, 0xff
		beq 	$t0, $zero, puts_end
		add 	$a0, $zero, $t0		# ascii 
		add 	$a1, $zero, $s1		# color
		jal 	putchar
		addi 	$s3, $s3, 1 		# increase index
		addi 	$t1, $zero, 4 		# set limit
		beq 	$s3, $t1, puts_next_word
		j 		puts_loop
puts_next_word:
		add 	$s3, $zero, $zero
		addi 	$s0, $s0, 4
		j 		puts_loop
puts_end:
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		lw 		$s3, 16($sp)
		addi 	$sp, $sp, 20
		jr 		$ra

# global function timer_1s
timer_1s:
		lui 	$t9, 50
timer_1s_loop:
		addi 	$t9, $t9, -1
		bne 	$t9, $zero, timer_1s_loop
		jr 		$ra

timer_1ms:
		lui 	$t9, 1
timer_1ms_loop:
		addi 	$t9, $t9, -1
		bne 	$t9, $zero, timer_1ms_loop
		jr 		$ra


# global function putchar
putchar:								# a0 - ascii, a1 - color		
		addi 	$sp, $sp, -16
		sw 		$ra, 0($sp)
		sw 		$s0, 4($sp)				# x
		sw 		$s1, 8($sp)				# y
		sw 		$s2, 12($sp)			# {color[2:0], ascii[7:0]}
		andi 	$a0, $a0, 0xff 			# a0 - ascii 
		andi 	$a1, $a1, 0x7 			# a1 - color
		add 	$s2, $zero, $a1         # s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		sll 	$s2, $s2, 1 			# s2 = {a0, a1}
		add 	$s2, $s2, $a0 			# s2 = {a0, a1}
		jal 	get_text_cursor
		add 	$s0, $zero, $v0			# move $s0, $v0
		add 	$s1, $zero, $v1			# move $s1, $v1
# if ascii = '\n' or '\b'
		andi 	$t1, $s2, 0xff 			# get ascii again from s2
		addi 	$t0, $zero, 8
		beq 	$t1, $t0, putchar_backspace
		addi 	$t0, $zero, 10			# if ascii = '\n' (newline)
		beq 	$t1, $t0, putchar_newline
		j 		putchar_output
putchar_backspace:
		addi 	$s0, $s0, -1 			# s0 = s0 - 1
		slt 	$t0, $s0, $zero			# t0 = (s0 < 0)
		andi 	$s2, $s2, 32 			# put a white space to vram
		beq     $t0, $zero, putchar_backspace_wipe
# if s0 < 0 then go back last line 
		addi 	$s1, $s1, -1
		slt 	$t0, $s1, $zero 		# t0 = (s1 < 0)
		addi 	$s0, $zero, 79
		beq 	$t0, $zero, putchar_backspace_wipe # s0 < 0 but s1 > 0
# if s1 < 0 && s0 < 0 then
		add 	$s1, $zero, $zero
		add 	$s0, $zero, $zero
putchar_backspace_wipe:
		add 	$t0, $zero, $s1 		# s1 - vram offset row=a
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		or 		$t0, $t0, $s0 			# t0 = {s1, s0}
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		lui 	$t1, 0x000c
		add 	$t1, $t1, $t0
		sw 		$s2, 0($t1)				# print to vram
		j 		putchar_save
putchar_newline:
		addi 	$s0, $zero, 79 			# the end of line
		andi 	$s2, $s2, 32 			# put a white space
# prepare to print to vram
putchar_output:
#		addi 	$t0, $zero
		add 	$t0, $zero, $s1 		# s1 - vram offset row=a
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		or 		$t0, $t0, $s0 			# t0 = {s1, s0}
		sll 	$t0, $t0, 1
		sll 	$t0, $t0, 1
		lui 	$t1, 0x000c
		add 	$t1, $t1, $t0
		sw 		$s2, 0($t1)				# print to vram
# x, y = next x, y
putchar_next_cursor:
		addi 	$s0, $s0, 1
		addi 	$t0, $zero, 80
		bne 	$s0, $t0, putchar_save
		add 	$s0, $zero, $zero
		addi 	$s1, $s1, 1
		addi 	$t0, $zero, 60
		bne 	$s1, $t0, putchar_save
		#add 	$s1, $zero, $zero
		#jal 	clear_screen 			# choice 1: clear screen
		add 	$a0, $zero, $s0
		add 	$a1, $zero, $s1
		jal 	put_text_cursor
		jal 	screen_scroll 			# choice 2: scroll sacreen
		j 		putchar_end
putchar_save:	
		add 	$a0, $zero, $s0
		add 	$a1, $zero, $s1
		jal 	put_text_cursor
putchar_end:
		lw 		$ra, 0($sp)
		lw 		$s0, 4($sp)
		lw 		$s1, 8($sp)
		lw 		$s2, 12($sp)
		addi 	$sp, $sp, 16
		jr 		$ra


.data
#################### data area
gill_hint:		.asciiz		"Gnnng@Gill: ~ $ "
reboot_name: 	.asciiz 	"reboot"
login_name: 	.asciiz 	"Login as Gnnng, please input password: "
login_success:	.asciiz 	"Welcome, Gnnng."
login_failure:	.asciiz		"Wrong password."
exit_name:		.asciiz 	"exit"
default_hint:	.asciiz 	"Invalid input, please type 'help' to get more help."
help_name: 		.asciiz 	"help"
help_hint0:		.ascii 		"Gill v2.0"
help_hint1:		.asciiz		"Supported commands:"
help_hint2:	 	.asciiz 	"Supported programs:"
password: 		.asciiz 	"mypass"
clear_name:		.asciiz		"clear"
enblink_name:	.asciiz		"enblink"
deblink_name:	.asciiz		"deblink"
vgatext_name:	.asciiz		"vgatext"
vgaimage_name:	.asciiz		"vgaimage"
ascii_name: 	.asciiz 	"ascii"
screentester_name:
				.asciiz 	"screentester"
box_name:		.asciiz 	"box"
boot01:			.asciiz		"Gill v2.0 loading from 0x00000000"
boot02:			.asciiz		"Booting Gill on physcial CPU"
boot03:			.asciiz		"Booting peripheral device"
boot04:			.asciiz		"Booting led device"
boot05:			.asciiz		"Testing led device"
boot06:			.asciiz		"Booting 7-segment led device"
boot07:			.asciiz		"Testing 7-segment led device"
boot08:			.asciiz		"Booting keyboard device"
boot09:			.asciiz		"Testing keyboard device"
boot_message: 	.asciiz 	"[..] "
boot_ok: 		.asciiz 	"OK"
skyfighter_name:
				.asciiz 	"skyfighter"


logo01: 		.asciiz 	"          _____                    _____                    _____      _____             /\    \                  /\    \                  /\    \    /\    \           /::\    \                /::\    \                /::\____\  /::\____\         /::::\    \               \:::\    \              /:::/    / /:::/    /        /::::::\    \               \:::\    \            /:::/    / /:::/    /        /:::/\:::\    \               \:::\    \          /:::/    / /:::/    /        /:::/  \:::\    \               \:::\    \        /:::/    / /:::/    /        /:::/    \:::\    \              /::::\    \      /:::/    / /:::/    /        /:::/    / \:::\    \    ____    /::::::\    \    /:::/    / /:::/    /        /:::/    /   \:::\ ___\  /\   \  /:::/\:::\    \  /:::/    / /:::/    /        /:::/____/  ___\:::|    |/::\   \/:::/  \:::\____\/:::/____/ /:::/____/         \:::\    \ /\  /:::|____|\:::\  /:::/    \::/    /\:::\    \ \:::\    \          \:::\    /::\ \::/    /  \:::\/:::/    / \/____/  \:::\    \ \:::\    \          \:::\   \:::\ \/____/    \::::::/    /            \:::\    \ \:::\    \          \:::\   \:::\____\       \::::/____/              \:::\    \ \:::\    \          \:::\  /:::/    /        \:::\    \               \:::\    \ \:::\    \          \:::\/:::/    /          \:::\    \               \:::\    \ \:::\    \          \::::::/    /            \:::\    \               \:::\    \ \:::\    \          \::::/    /              \:::\____\               \:::\____\ \:::\____\          \::/____/                \::/    /                \::/    /  \::/    /                                    \/____/                  \/____/    \/____/                                                                                                                                                                                                                                                                                    ___      ___   _______          ________                                       |\  \    /  /| /  ___  \        |\   __  \                                      \ \  \  /  / //__/|_/  /|       \ \  \|\  \                                      \ \  \/  / / |__|//  / /        \ \  \\\  \                                      \ \    / /      /  /_/__   ___  \ \  \\\  \                                      \ \__/ /      |\________\|\__\  \ \_______\                                      \|__|/        \|_______|\|__|   \|_______|  "

#plane:			.asciiz 	" /\      \ \      \ \     /  \   <===>\  <    )> <===>/   \  /    / /    / /     \/     "
#plane_left:		.asciiz 	"_/\     \  \     \  \    /   \  <====>\  <    )>  <==>/    \ /     //     //      `     "
#plane_right:	.asciiz 	"  _       \\       \\      / \    <==>\  <    )><====>/  \   /   /  /   /  /    `\/     "
fire: 			.asciiz 	"---"
plane:
				.word 		0x202f5c20
				.word 		0x20202020
				.word 		0x0a205c20
				.word 		0x5c202020
				.word 		0x200a2020
				.word 		0x5c205c20
				.word 		0x20200a20
				.word 		0x202f2020
				.word 		0x5c20200a
				.word 		0x203c3d3d
				.word 		0x3d3e5c20
				.word 		0x0a203c20
				.word 		0x20202029
				.word 		0x3e0a203c
				.word 		0x3d3d3d3e
				.word 		0x2f200a20
				.word 		0x205c2020
				.word 		0x2f20200a
				.word 		0x20202f20
				.word 		0x2f202020
				.word 		0x0a202f20
				.word 		0x2f202020
				.word 		0x200a205c
				.word 		0x2f202020
				.word 		0x20200a00
plane_right:
				.word 		0x5f2f5c20
				.word 		0x20202020
				.word 		0x0a5c2020
				.word 		0x5c202020
				.word 		0x200a205c
				.word 		0x20205c20
				.word 		0x20200a20
				.word 		0x2f202020
				.word 		0x5c20200a
				.word 		0x3c2d2d2d
				.word 		0x2d3e5c20
				.word 		0x0a203c20
				.word 		0x20202029
				.word 		0x3e0a2020
				.word 		0x3c2d2d3e
				.word 		0x2f200a20
				.word 		0x20205c20
				.word 		0x2f20200a
				.word 		0x2020202f
				.word 		0x2f202020
				.word 		0x0a20202f
				.word 		0x2f202020
				.word 		0x200a2020
				.word 		0x60202020
				.word 		0x20200a00
plane_left:
				.word 		0x20205f20
				.word 		0x20202020
				.word 		0x0a20205c
				.word 		0x5c202020
				.word 		0x200a2020
				.word 		0x205c5c20
				.word 		0x20200a20
				.word 		0x20202f20
				.word 		0x5c20200a
				.word 		0x20203c2d
				.word 		0x2d3e5c20
				.word 		0x0a203c20
				.word 		0x20202029
				.word 		0x3e0a3c2d
				.word 		0x2d2d2d3e
				.word 		0x2f200a20
				.word 		0x5c202020
				.word 		0x2f20200a
				.word 		0x202f2020
				.word 		0x2f202020
				.word 		0x0a2f2020
				.word 		0x2f202020
				.word 		0x200a605c
				.word 		0x2f202020
				.word 		0x20200a00
stone_tiny:
				.word 		0x40404040
				.word 		0x400a4040
				.word 		0x4040400a
				.word 		0x40404040
				.word 		0x400a0000
stone_giant:
				.word 		0x20204040
				.word 		0x4020200a
				.word 		0x40404040
				.word 		0x4040400a
				.word 		0x40404040
				.word 		0x4040400a
				.word 		0x40404040
				.word 		0x4040400a
				.word 		0x20204040
				.word 		0x4020200a
				.word 		0x00000000
plane_exp01:
				.word 		0x202f5c20
				.word 		0x20202020
				.word 		0x20200a20
				.word 		0x5c20205c
				.word 		0x20202020
				.word 		0x200a5c20
				.word 		0x20202020
				.word 		0x5c202020
				.word 		0x0a202020
				.word 		0x20202020
				.word 		0x5c20200a
				.word 		0x3c203d20
				.word 		0x3d20203d
				.word 		0x3e5c0a20
				.word 		0x20202020
				.word 		0x20202029
				.word 		0x3e0a203c
				.word 		0x3d20203d
				.word 		0x203d3e2f
				.word 		0x0a202020
				.word 		0x20202f20
				.word 		0x2020200a
				.word 		0x20202020
				.word 		0x20202f20
				.word 		0x20200a20
				.word 		0x20202020
				.word 		0x2f202020
				.word 		0x200a5c20
				.word 		0x202f2020
				.word 		0x20202020
				.word 		0x0a000000

plane_exp02:
				.word 		0x202f5c20
				.word 		0x2e202020
				.word 		0x20202e0a
				.word 		0x205c2020
				.word 		0x20205c2e
				.word 		0x2020200a
				.word 		0x5c202020
				.word 		0x20202020
				.word 		0x202e200a
				.word 		0x20202020
				.word 		0x40202020
				.word 		0x202e200a
				.word 		0x3c203d20
				.word 		0x3d20203d
				.word 		0x3e5c200a
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20293e0a
				.word 		0x20202020
				.word 		0x20203d20
				.word 		0x4020200a
				.word 		0x20202020
				.word 		0x20232020
				.word 		0x20202f0a
				.word 		0x20202025
				.word 		0x20202020
				.word 		0x20202f0a
				.word 		0x20202020
				.word 		0x202f2e20
				.word 		0x20202e0a
				.word 		0x5c20202e
				.word 		0x202e2020
				.word 		0x2e20200a
				.word 		0x00000000
plane_exp03:
				.word 		0x20202020
				.word 		0x2020202e
				.word 		0x20202020
				.word 		0x0a202020
				.word 		0x20402020
				.word 		0x20202020
				.word 		0x200a2020
				.word 		0x20202020
				.word 		0x2020202e
				.word 		0x20200a20
				.word 		0x20202020
				.word 		0x2020202e
				.word 		0x2020200a
				.word 		0x202e2020
				.word 		0x20202020
				.word 		0x2020202e
				.word 		0x0a202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x2e0a2020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20200a20
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x4020200a
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x0a202520
				.word 		0x20202020
				.word 		0x20202320
				.word 		0x200a2020
				.word 		0x202e202e
				.word 		0x20202e20
				.word 		0x20200a00
fail_name:
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x5f5f2020
				.word 		0x5f5f2020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x2020205f
				.word 		0x5f202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x205f5f0a
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x5c205c2f
				.word 		0x202f2020
				.word 		0x5f5f5f5f
				.word 		0x20202020
				.word 		0x205f5f20
				.word 		0x205f5f20
				.word 		0x20202020
				.word 		0x20202f20
				.word 		0x2f20205f
				.word 		0x5f5f5f20
				.word 		0x20202020
				.word 		0x5f5f5f5f
				.word 		0x5f202020
				.word 		0x5f5f5f20
				.word 		0x20202020
				.word 		0x2f202f0a
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x205c2020
				.word 		0x2f20202f
				.word 		0x205f5f20
				.word 		0x5c202020
				.word 		0x2f202f20
				.word 		0x2f202f20
				.word 		0x20202020
				.word 		0x202f202f
				.word 		0x20202f20
				.word 		0x5f5f205c
				.word 		0x2020202f
				.word 		0x205f5f5f
				.word 		0x2f20202f
				.word 		0x205f205c
				.word 		0x2020202f
				.word 		0x202f200a
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x202f202f
				.word 		0x20202f20
				.word 		0x2f5f2f20
				.word 		0x2f20202f
				.word 		0x202f5f2f
				.word 		0x202f2020
				.word 		0x20202020
				.word 		0x2f202f20
				.word 		0x202f202f
				.word 		0x5f2f202f
				.word 		0x2020285f
				.word 		0x5f202029
				.word 		0x20202f20
				.word 		0x205f5f2f
				.word 		0x20202f5f
				.word 		0x2f20200a
				.word 		0x20202020
				.word 		0x20202020
				.word 		0x2f5f2f20
				.word 		0x20205c5f
				.word 		0x5f5f5f2f
				.word 		0x2020205c
				.word 		0x5f5f2c5f
				.word 		0x2f202020
				.word 		0x2020202f
				.word 		0x5f2f2020
				.word 		0x205c5f5f
				.word 		0x5f5f2f20
				.word 		0x202f5f5f
				.word 		0x5f5f2f20
				.word 		0x20205c5f
				.word 		0x5f5f2f20
				.word 		0x20285f29
				.word 		0x0a000000