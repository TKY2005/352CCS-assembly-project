data segment
	; defining a 32 character buffer for our user input
	txtBuffer db 32 ; first byte is the max size of the buffer
		db 0 ; second byte is the number of characters entered (will be updated after executing input interrupt)
		db 32 dup(?) ; the rest of the buffer will be our actual user input

	invalid_prompt_msg db "Wrong cipher algorithm entered : $"
	cipher_prompt db "Enter a text to cipher (32 character max) : $"
	alogrithm_prompt db "Enter the cipher alogritm used (c for ceaser cipher, f for bit flipping algorithm : $"
	key_prompt db "Enter the cipher key : $"
	newline db 10, 13, "$"
	msg db "Ciphered text : $"

print_msg macro txt ; a macro to print text to make our lives a little bit easier
	mov	ah, 9h
	lea	dx, txt
	int	21h
endm

code segment

	assume ds:data, cs:code

	start:
		mov	ax, data
		mov	ds, ax

		print_msg	alogrithm_prompt
		mov	ah, 01h ; read the argument for the algoritm selection (one character only)
		int	21h

		mov	di, 0200h ; move the character input to memory location 200 for temporary storage
		mov	[di], al
		int	03h ; in case we need to debug.

		print_msg	newline
		print_msg	cipher_prompt

		mov	ah, 0ah ; DOS interruput code for buffered input
		lea	dx, txtBuffer ; load our buffer to dx where our input will be stored
		int	21h

		print_msg	newline

		mov	al, [txtBuffer + 1] ; load the second byte (the length of the input) to al
		xor	ah, ah ; clear the high byte of ax to prevent any incorrect readings
		mov	cx, ax ; load the input length into counter register to prepare for iterating
		lea	si, [txtBuffer + 2] ; load the beggining of our input string to si
		

		; decide which algoritm we're gonna use.
		; (byte ptr) because we have to define the size when operating directly from memory
		cmp	byte ptr [di], 'c'
		je	ceaser_cipher

		cmp	byte ptr [di], 'f'
		je	bit_flipping

		jne	invalid_prompt

		ceaser_cipher:

			; TODO : Enter the code for prompting the user and setting the key value ;

			mov	dl, [si] ; load current character to dl
			add	dl, 5 ; do the ceaser cipher (add a value (key) to our ascii character to produce a new character)
			mov	ah, 02h ; DOS interrupt code for displaying character
			int	21h
			inc	si
			loop	ceaser_cipher
			jmp	exit

		bit_flipping:
			mov	dl, [si]
			not	dl
			mov	ah, 02h
			int	21h
			inc	si
			loop	bit_flipping
			jmp	exit

		invalid_prompt:
			print_msg	invalid_prompt_msg
			mov	dl, [di]
			mov	ah, 02h
			int	21h
			jmp	exit

		exit:
			mov	ah, 4ch ; DOS interrupt code for terminating the program
			int	21h

	code ends

end start
