.text
.global _start

_start:
	ldr r1, =input_string
	ldr r4, =#0xBEEF
	ldr r5, =#0xDEAD
	bl get_number
	
	b _start
get_number:

	push {r4,r5,r6}
	mov r4,#8// used later as literal in multiplication 
	mov r0,#0
	
	// r3 = counter(string index), r1 pointer to string to convert r2 string r1 points to , 4 bytes of string r0 result
		// first it suppose to shift to right string, get first 4 bits less significant bits and push them on the stack to them put all dgits togheter to binary form ) 
	mov r3,#0 // set counter to 0 
	ldr r2, [r1] // load string to register r2 pointed to by reghister r1
get_number_start:
	
	cmp r2, #0 // if string isn't equal to zero continue if string r2 is zero that's end of string
	bne no_null_termination
	bx lr
	
no_null_termination:
	and r5, r2, #0xFF // get first 4 bits of  r2 into trgister r5
	
	cmp r2, #0 // if string isn't equal to zero continue if string r2 is zero that's end of string
	bne there_is_still_string_to_go
		add r1,#4
		ldr r2, [r1]
		b get_number_start
there_is_still_string_to_go:	
	sub r5, r5,#48 //  subtract 48 if it is zero or more  character is in number region of askii table 
	cmp r5 , #0 // if character is in numbe region go to numeric label if not continue 
	BGE numeric
		mov r3,#0 // puts zero in r3 register than is used as counter
			// r0 is held result of conversion from decimal tobinary 
		push {r0,r1,r2,r3} // pushing all volotile register to stack
		mov r1, #10
		mov r2,r3
		bl pow
		mov r6,r1 // result is in r1 so for now it is swaped to r6 bevore poping all the pushed registers from stack (that includes r1) so result stored in r1 isn't lost
		pop {r0,r1,r2,r3}
		pop {r5} // get next (in order from elast to most significant digits) from stack
		mul r5,r5,r6 // multiply r5 by r6 with holds 10 to power of index of digit held in r5
		add r0,r5
	
	
numeric:
	mov r2, r2, LSR #8 // shift right by 8 so i can get next byte with mask and with and operaion 
	add r3, #1
	push {r5}
	B get_number_start
	
	// end of get_number_start
	pop {r5}
	pop {r4,r5,r6}
	BX lr

// calculates power r1 = base, r2= exponent, result is stored in r1
pow:
	mov r3,r1
	sub r2, r2, #1
pow_start:
	mul r1, r1,r3
	sub r2, r2, #1
	CMP r2,#0
	BEQ end_of_power
	B pow_start
end_of_power:
	BX LR
.data
input_string:
	.asciz "255*2  "          @ our string, NULL terminated
counter:
	.int 69
