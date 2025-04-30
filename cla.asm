data segment

	cl_buffer db 128
		db 0
		db 128 dup(?)
data ends

code segment
	assume ds:data, cs:code

	start:
		mov	ax, data
		mov	ds, ax


		mov	ah, 62h
		int	21h
		mov	bx, ax

		mov	si, 81h
		mov	di, 0200h
		mov	cx, 128
		rep	movsb

		int	03h
	code ends
end start
