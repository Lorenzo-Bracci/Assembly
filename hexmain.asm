  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,15		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	
move2:
	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

 hexasc: # You can write your own code for hexasc here
        andi  $t0,$a0, 15
        slti  $t1,$a0,10
        bne   $t1,$0,num
        addi $v0,$t0,55
        j move2
        num:
        addi $v0,$t0,48
        j move2
        
        

  #

