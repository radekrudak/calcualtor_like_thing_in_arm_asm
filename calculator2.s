.text
.global _start

_start:

	
	ldr r2, =input_string
	
	bl get_number
	mov r4,r0 // moves first number to r4
	ldrb r6, [r2] // stores operation character in r6
	mov r7,r2

	
next_operation:

	add r2,r7,#1 // adds to string pointer one so it no loinger points to operation but to next number, result stored in r2 to process by next subroutine (later r7 will be updated) 
	bl get_number
		//r4 is first number (result from previous operation) r0 is second number and r2 is pointer to next operation, r6 is next operation
	mov r7,r2 // moves pointer that now points to next operation (or null character) to r7
	mov r1,r4
	mov r2,r0
	mov r3,r6
	bl calculate_numbers
	// r0 is result of operation
	mov r4,r0
	ldrb r6, [r7] // loads next operation to do
	cmp r6,#0
	bne next_operation
	// end of program
	
	b _start
	
	
// r0 - result, r1 - first number, r2 - second number, r3 - operation 	
calculate_numbers:
	CALCULATE_NUMBERS_check_if_addytion:
		cmp r3, #43
		bne CALCULATE_NUMBERS_check_if_subtraction	
		add r0,r1,r2
		bx lr
	CALCULATE_NUMBERS_check_if_subtraction:
		cmp r3, #45
		bne CALCULATE_NUMBERS_check_if_multiplication	
		sub r0,r1,r2
		bx lr
	CALCULATE_NUMBERS_check_if_multiplication:
		cmp r3, #42
		bne CALCULATE_NUMBERS_end	
		mul r0,r1,r2
		bx lr
CALCULATE_NUMBERS_end:	
	bx lr
	

// converts first number from string (first from left) to it's binary form, stores it in register r0 returs poiter to char after converted number
//r0, result(number)

//r2,pointer to a string (in sub routine moved to r8), after return r2 stores pointer to character in string avter just extracted number
//r4, sued for stroing character it's is working on
// r5 counter1
// r6 counter2 
// r7 stored result bevore it is moved to r0
get_number:
	push {r4,r5,r6,r7,r8 }
	mov r0, #0
	mov r5, #0
	mov r6, #0
	mov r7, #0
	mov r8, r2
	ldrb r1, [r8] // load character to work on pointed by r2
	
	GET_NUMBER_fetch_next_character:
		ldrb r4, [r8] // load character to work on pointed by r2
		
		cmp r4, #0
			ble GET_NUMBER_convert_numbers_from_stack_to_bin_and_put_result_to_r0 // if higher than 0 continue if not start converting numbers fro mstack
		sub r4, r4, #48
		cmp r4, #0
			blt GET_NUMBER_convert_numbers_from_stack_to_bin_and_put_result_to_r0 // if r4 is smaller than 0 it character isn't a  num char if r4 is equal 0 or more character represents number (subtracting 48 already converted this single char to it's number in binary)
	
		GET_NUMBER_this_is_a_num_char:
			push {r4}
			add r5,r5,#1
			add r8, r8, #1
				b GET_NUMBER_fetch_next_character
		GET_NUMBER_convert_numbers_from_stack_to_bin_and_put_result_to_r0:
			pop {r4}
			
			mov r1, #10
			mov r2,r6
			push {lr}
			bl pow
			pop {lr}
			
			mul r4, r4,r1
			add r7,r4,r7
			sub r5,r5,#1
			add r6,r6,#1
			cmp r5, #0
				bgt GET_NUMBER_convert_numbers_from_stack_to_bin_and_put_result_to_r0
			
			mov r0,r7
			mov r2,r8
			
	pop {r4,r5,r6,r7,r8}
	bx lr

// calculates power r1 = base, r2= exponent, result is stored in r1
pow:
	cmp r2, #0
		beq end_of_power_exponent_zero
	cmp r2, #1
		beq end_of_power_exponent_one
	mov r3,r1
	sub r2, #1
	
	pow_start:
		mul r1, r1,r3
		sub r2, r2, #1
		CMP r2,#0
		BEQ end_of_power
		B pow_start
	end_of_power:
		bx lr
	end_of_power_exponent_zero:
		mov r1,#1
		bx lr
	end_of_power_exponent_one:
		bx lr

.data
input_string:
	.asciz "64*2+10*2+10"          @ our string, NULL terminated
output_string:
	.asciz "                                                                                                                                             "
acu_x:
	.long 00000000
acu_y:
	.long 000000000 
