data segment
	fileName db "file.txt", 0
	errorMsg db "Couldn't open file$"
	handle dw ?
	buffer db 100 dup(?)
data ends

code segment

	assume ds:data, cs:code
	start:

		mov	ax, data
		mov	ds, ax

		; open file and prepare it for reading
		mov	ah, 3dh ; DOS function to read file
		mov	al, 0 ; reading mode: read-only
		lea	dx, fileName ; load file name address
		int	21h
		jc	error_open ; if the carry flag is set then something went wrong

		mov	handle, ax ; store the file handle

		; Read the file content
		mov	ah, 3fh ; DOS function to read file
		mov	bx, handle ; load the handle
		mov	cx, 99 ; the amount of bytes to read
		lea	dx, buffer ; load the data stored in the buffer
		int	21h

		mov	si, ax
		mov	buffer[si], '$' ; move the null terminator after done reading


		; Display the loaded data
		mov	ah, 9h ; DOS function for displaying string
		lea	dx, buffer
		int	21h
	
		; move the data to memory location 0200 for next operation	
		mov	si, offset buffer
		mov	di, 0200h
		mov	cx, ax
		rep	movsb
		jmp	exit

	error_open:
			mov	ah, 9h
			lea	dx, errorMsg
			int	21h

	exit:
		mov	ah, 4ch
		int	21h

	code ends
end start
