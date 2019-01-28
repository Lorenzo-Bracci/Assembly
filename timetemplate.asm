  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii 
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,1000
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

        
delay: PUSH ($s0)
       PUSH ($s1)
       PUSH ($ra)	
	
loop1:
	slti $t8,$a0,0
	bne $t8,$0,done1
	nop
	addi $s1,$a0,0
	addi $a0,$s1,-1
loop:	
	slti $t7,$s0,1000
	beq $t7,$0,done
	nop
	addi $t9,$s0,0
	addi $s0,$t9,1
	j loop
	nop
done:	j loop1
        nop
done1: POP ($ra)
       POP ($s1)
       POP ($s0)
       jr $ra
       nop
time2string:
        PUSH ($ra)
        PUSH ($s0)
        PUSH ($s1) 
        PUSH ($s2)
        PUSH ($s3)
        PUSH ($s4)
        PUSH ($s5)
        PUSH ($s6)
        PUSH ($s7)
        andi $s0,$a1,0xffff
        andi $s1,$s0,0xf000
        srl $s2,$s1,12
        addi $t3,$s2,0
        jal hexasc
        nop
        sb $a3,0($a0)
        andi $s3,$s0,0xf00
        srl $s4,$s3,8
        addi $t3,$s4,0
        jal hexasc
        nop
        sb $a3,1($a0)
        addi $t5,$0,0x3a
        sb $t5,2($a0)
        andi $s5,$s0,0xf0
        srl  $s6,$s5,4
        addi $t3,$s6,0
        jal hexasc
        nop
        sb $a3,3($a0)
        andi $s7,$s0,0xf
        addi $t3,$s7,0
        jal hexasc
        nop
        sb $a3,4($a0)
        andi $t6,$0,0x00
        sb $t6,5($a0)
        POP ($s7)
        POP ($s6)
        POP ($s5)
        POP ($s4)
        POP ($s3)
        POP ($s2)
        POP ($s1)
        POP ($s0)
        POP ($ra)
        jr $ra
        nop
hexasc:
        
        andi  $t4,$t3, 15
        addi $a3,$t4,0x30
        jr	$ra
        nop