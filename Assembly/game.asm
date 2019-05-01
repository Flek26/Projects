%include "/usr/local/share/csc314/asm_io.inc"


; the file that stores the initial state
%define BOARD_FILE 'board.txt'

; how to represent everything
%define WALL_CHAR '#'
%define PLAYER_CHAR 'T'
%define GOLD '$'
%define CROP_LAND '~'
%define EMPTY_CHAR ' '
%define PLANTED_CROP 'v'
%define MARKET_CHAR 'M'
%define GROWN_CROP 'V'

; Configurable variables
%define INITIAL_GOLD 100
%define INITIAL_SEEDS 10
%define INITIAL_WHEAT 0
%define INITIAL_GROWTH 5000000
%define WHEAT_PRICE 15

; the size of the game screen in characters
%define HEIGHT 51
%define WIDTH 142

; the player starting position.
; top left is considered (0,0)
%define STARTX 1
%define STARTY 1

; these keys do things
%define EXITCHAR 'x'
%define UPCHAR 'w'
%define LEFTCHAR 'a'
%define DOWNCHAR 's'
%define RIGHTCHAR 'd'

; magic values for nonblocking getchat
%define F_GETFL 3
%define F_SETFL 4
%define O_NONBLOCK 2048
%define STDIN 0

; how frequently we check for input
; 1,000,000 = 1 second
%define TICK 50000	; 1/20th of a second

segment .data

	; used to fopen() the board file defined above
	board_file			db BOARD_FILE,0

	; used to change the terminal mode
	mode_r				db "r",0
	raw_mode_on_cmd		db "stty raw -echo",0
	raw_mode_off_cmd	db "stty -raw echo",0

	; called by system() to clear/refresh the screen
	clear_screen_cmd	db "clear",0

	; things the program will print
	help_str			db 13,10,"Controls: ", \
							UPCHAR,"=UP / ", \
							LEFTCHAR,"=LEFT / ", \
							DOWNCHAR,"=DOWN / ", \
							RIGHTCHAR,"=RIGHT / ", \
							EXITCHAR,"=EXIT", \
							13,10,10,0
	inv_fmt 			db  "Gold: %d  |  Seeds: %d  |  Wheat: %d",13,10,0
	position_fmt 		db  "Xpos: %d  |  Ypos: %d",13,10,10,0

	row1 				dd 	41
	row2 				dd  43

segment .bss

	; this array stores the current rendered gameboard (HxW)
	board	resb	(HEIGHT * WIDTH)

	; these variables store the current player position
	xpos	resd	1
	ypos	resd	1

	; counter for gold gathered
	goldctr resd 	1
	seedctr resd 	1
	wheatctr resd 	1
	croptimr resd 	72
	count75  resd  72
segment .text

	global	asm_main
	global  raw_mode_on
	global  raw_mode_off
	global  init_board
	global  render

	extern	system
	extern	putchar
	extern	getchar
	extern	printf
	extern	fopen
	extern	fread
	extern	fgetc
	extern	fclose

	; deals with random numbers
	extern time
	extern srand
	extern rand


	; For game ticks
	extern	usleep		; used to slow down the read loop
	extern	fcntl		; used to change the blocking mode

asm_main:
	enter	0,0
	pusha
	;***************CODE STARTS HERE***************************
	; Sets the seed of the random number generator to 
	push 0
	call time
	add esp, 4

	push eax
	call srand
	add esp, 4

	call rand
	cdq
	mov 	ebx, 10
	idiv 	ebx
	; rand value is now in edx
	; rdrand eax
	;


	; edx has mod value


	; put the terminal in raw mode so the game works nicely
	call	raw_mode_on

	; read the game board file into the global variable
	call	init_board

	; set the player at the proper start position
	mov		DWORD [xpos], STARTX
	mov		DWORD [ypos], STARTY

	mov 	DWORD [goldctr], INITIAL_GOLD
	mov 	DWORD [seedctr], INITIAL_SEEDS
	mov 	DWORD [wheatctr], INITIAL_WHEAT
	mov 	DWORD [count75], 0
	top:
		mov 	ebx, DWORD [count75]
		mov 	DWORD [croptimr + ( ebx * 4 ) ], 0
		inc 	DWORD [count75]
		cmp 	DWORD [count75], 72
		jl 		top


	; the game happens in this loop
	; the steps are...
	;   1. render (draw) the current board
	;   2. get a character from the user
	;	3. store current xpos,ypos in esi,edi
	;	4. update xpos,ypos based on character from user
	;	5. check what's in the buffer (board) at new xpos,ypos
	;	6. if it's a wall, reset xpos,ypos to saved esi,edi
	;	7. otherwise, just continue! (xpos,ypos are ok)
	game_loop:

		; draw the game board
		call	render

		; get an action from the user
		push 	TICK
		call 	usleep
		add 	esp, 4

;		dec 	DWORD[goldctr]

	mov 	DWORD [count75], 0
	top_array2:
		mov 	ebx, DWORD [count75]
		cmp 	DWORD [croptimr + ( ebx * 4 ) ], 0
		jle 	is_zero
		sub 	DWORD [croptimr + ( ebx * 4 )], 50000
		cmp	 DWORD[croptimr + ( ebx * 4 ) ], 0
		jg 	is_zero

		cmp 	ebx, 17
		jle 	top_check_for1
		cmp 	ebx, 36
		jl 		top_check_for3
		cmp		ebx, 54
		jl 		top_check_for2
		cmp 	ebx, 72
		jl 		top_check_for4
		top_check_for1:
				mov		eax, WIDTH
				mul		DWORD [row1]
				add		eax, ebx
				add		eax, 17
				lea		eax, [board + eax]
				mov 	BYTE[eax], GROWN_CROP
				jmp 	is_zero
		top_check_for2:
				mov		eax, WIDTH
				mul		DWORD [row2]
				add		eax, ebx
				sub 	eax, 36
				add		eax, 17
				lea		eax, [board + eax]
				mov 	BYTE[eax], GROWN_CROP
				jmp 	is_zero
		top_check_for3:
				mov		eax, WIDTH
				mul		DWORD [row1]
				add		eax, ebx
				sub 	eax, 18
				add		eax, 42
				lea		eax, [board + eax]
				mov 	BYTE[eax], GROWN_CROP
				jmp 	is_zero
		top_check_for4:
				mov		eax, WIDTH
				mul		DWORD [row2]
				add		eax, ebx
				sub 	eax, 54
				add		eax, 42
				lea		eax, [board + eax]
				mov 	BYTE[eax], GROWN_CROP
	is_zero:
		inc 	DWORD [count75]
		cmp 	DWORD [count75], 72
		jl 		top_array2

		call nonblocking_getchar

		cmp 	al, -1
		je 		game_loop

		; store the current position
		; we will test if the new position is legal
		; if not, we will restore these
		mov		esi, [xpos]
		mov		edi, [ypos]

		; choose what to do
		cmp		eax, EXITCHAR
		je		game_loop_end
		cmp		eax, UPCHAR
		je 		move_up
		cmp		eax, LEFTCHAR
		je		move_left
		cmp		eax, DOWNCHAR
		je		move_down
		cmp		eax, RIGHTCHAR
		je		move_right
		jmp		input_end			; or just do nothing

		; move the player according to the input character
		move_up:
			dec		DWORD [ypos]
			jmp		input_end
		move_left:
			dec		DWORD [xpos]
			jmp		input_end
		move_down:
			inc		DWORD [ypos]
			jmp		input_end
		move_right:
			inc		DWORD [xpos]
		input_end:

		; (W * y) + x = pos

		; compare the current position to the wall character
		mov		eax, WIDTH
		mul		DWORD [ypos]
		add		eax, [xpos]
		lea		eax, [board + eax]
		cmp		BYTE [eax], WALL_CHAR
		jne		valid_move
			; opps, that was an invalid move, reset
			mov		DWORD [xpos], esi
			mov		DWORD [ypos], edi
		valid_move:
		cmp 	BYTE[eax], CROP_LAND
			jne 	not_crop
				cmp 	DWORD[seedctr], 0
				je 		not_crop
					sub 	DWORD[seedctr], 1
					mov 	BYTE[eax], PLANTED_CROP
						cmp DWORD[ypos], 41
						jne 	not_41

					mov 	edx, 17
					top_row1_loop:
						cmp DWORD[xpos], edx
						je 	is_edx
						cmp edx, 35
						jg 	not_1
						inc 	edx
						jmp 	top_row1_loop
						is_edx:
						mov 	ebx, edx
						sub 	ebx, 17

					mov	DWORD [croptimr + ( ebx * 4 ) ], INITIAL_GROWTH
					jmp 	is_41

				not_1:
					mov 	edx, 42
					top_row2_loop:
						cmp DWORD[xpos], edx
						je 	is_edx2
						cmp edx, 60
						jg 	not_2
						inc 	edx
						jmp 	top_row2_loop
						is_edx2:
						mov 	ebx, edx
						sub 	ebx, 42

					mov	DWORD [croptimr + ( ( ebx + 18 ) * 4 ) ], INITIAL_GROWTH
					jmp 	is_41
		not_2:
		not_41:
					mov 	edx, 17
					top_row3_loop:
						cmp DWORD[xpos], edx
						je 	is_edx3
						cmp edx, 35
						jg 	not_3
						inc 	edx
						jmp 	top_row3_loop
						is_edx3:
						mov 	ebx, edx
						sub 	ebx, 17

					mov	DWORD [croptimr + ( ( ebx + 36) * 4 ) ], INITIAL_GROWTH
					jmp 	is_41
			not_3:
					mov 	edx, 42
					top_row4_loop:
						cmp DWORD[xpos], edx
						je 	is_edx4
						cmp 	edx, 60
						je 	is_41
						inc 	edx
						jmp 	top_row4_loop
						is_edx4:
						mov 	ebx, edx
						sub 	ebx, 42

					mov	DWORD [croptimr + ( ( ebx + 54) * 4 ) ], INITIAL_GROWTH

		is_41:
		not_crop:
			cmp 	BYTE[eax], GROWN_CROP
			jne 	not_harvest
					mov BYTE[eax], CROP_LAND
					inc DWORD[wheatctr]
		not_harvest:
			cmp 	BYTE[eax], GOLD
			jne 	not_gold
				cmp 	DWORD[wheatctr], 0
				jle 	not_gold
					dec 	DWORD[wheatctr]
					add 	DWORD[goldctr], WHEAT_PRICE
		not_gold:
			cmp 	BYTE[eax], MARKET_CHAR
			jne 	not_market
				cmp 	DWORD[goldctr], 10
				jl		not_market
					sub 	DWORD[goldctr], 10
					inc 	DWORD[seedctr]
		not_market:


	jmp		game_loop
	game_loop_end:

	; restore old terminal functionality
	call raw_mode_off

	;***************CODE ENDS HERE*****************************
	popa
	mov		eax, 0
	leave
	ret

; === FUNCTION ===
raw_mode_on:

	push	ebp
	mov		ebp, esp

	push	raw_mode_on_cmd
	call	system
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
raw_mode_off:

	push	ebp
	mov		ebp, esp

	push	raw_mode_off_cmd
	call	system
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
init_board:

	push	ebp
	mov		ebp, esp

	; FILE* and loop counter
	; ebp-4, ebp-8
	sub		esp, 8

	; open the file
	push	mode_r
	push	board_file
	call	fopen
	add		esp, 8
	mov		DWORD [ebp-4], eax

	; read the file data into the global buffer
	; line-by-line so we can ignore the newline characters
	mov		DWORD [ebp-8], 0
	read_loop:
	cmp		DWORD [ebp-8], HEIGHT
	je		read_loop_end

		; find the offset (WIDTH * counter)
		mov		eax, WIDTH
		mul		DWORD [ebp-8]
		lea		ebx, [board + eax]

		; read the bytes into the buffer
		push	DWORD [ebp-4]
		push	WIDTH
		push	1
		push	ebx
		call	fread
		add		esp, 16

		; slurp up the newline
		push	DWORD [ebp-4]
		call	fgetc
		add		esp, 4

	inc		DWORD [ebp-8]
	jmp		read_loop
	read_loop_end:

	; close the open file handle
	push	DWORD [ebp-4]
	call	fclose
	add		esp, 4

	mov		esp, ebp
	pop		ebp
	ret

; === FUNCTION ===
render:

	push	ebp
	mov		ebp, esp

	; two ints, for two loop counters
	; ebp-4, ebp-8
	sub		esp, 8

	; clear the screen
	push	clear_screen_cmd
	call	system
	add		esp, 4

	; print the help information
	push	help_str
	call	printf
	add		esp, 4


	; outside loop by height
	; i.e. for(c=0; c<height; c++)
	mov		DWORD [ebp-4], 0
	y_loop_start:
	cmp		DWORD [ebp-4], HEIGHT
	je		y_loop_end

		; inside loop by width
		; i.e. for(c=0; c<width; c++)
		mov		DWORD [ebp-8], 0
		x_loop_start:
		cmp		DWORD [ebp-8], WIDTH
		je 		x_loop_end

			; check if (xpos,ypos)=(x,y)
			mov		eax, [xpos]
			cmp		eax, DWORD [ebp-8]
			jne		print_board
			mov		eax, [ypos]
			cmp		eax, DWORD [ebp-4]
			jne		print_board
				; if both were equal, print the player
				push	PLAYER_CHAR
				jmp		print_end
			print_board:
				; otherwise print whatever's in the buffer
				mov		eax, [ebp-4]
				mov		ebx, WIDTH
				mul		ebx
				add		eax, [ebp-8]
				mov		ebx, 0
				mov		bl, BYTE [board + eax]
				push	ebx
			print_end:
			call	putchar
			add		esp, 4

		inc		DWORD [ebp-8]
		jmp		x_loop_start
		x_loop_end:

		; write a carriage return (necessary when in raw mode)
		push	0x0d
		call 	putchar
		add		esp, 4

		; write a newline
		push	0x0a
		call	putchar
		add		esp, 4

	inc		DWORD [ebp-4]
	jmp		y_loop_start
	y_loop_end:

	push 	DWORD[wheatctr]
	push 	DWORD[seedctr]
	push 	DWORD[goldctr]
	push 	inv_fmt
	call 	printf
	add 	esp, 12

;	push	DWORD[ypos]
;	push 	DWORD[xpos]
;	push 	position_fmt
;	call 	printf
;	add 	esp, 8


	mov		esp, ebp
	pop		ebp
	ret
; === FUNCTION ===
nonblocking_getchar:

; returns -1 on no-data
; returns char on succes

	push	ebp
	mov		ebp, esp

	; single int used to hold flags
	; single character (aligned to 4 bytes) return
	sub		esp, 8

	; get current stdin flags
	; flags = fcntl(stdin, F_GETFL, 0)
	push	0
	push	F_GETFL
	push	STDIN
	call	fcntl
	add		esp, 12
	mov		DWORD [ebp-4], eax

	; set non-blocking mode on stdin
	; fcntl(stdin, F_SETFL, flags | O_NONBLOCK)
	or		DWORD [ebp-4], O_NONBLOCK
	push	DWORD [ebp-4]
	push	F_SETFL
	push	STDIN
	call	fcntl
	add		esp, 12

	call	getchar
	mov		DWORD [ebp-8], eax

	; restore blocking mode
	; fcntl(stdin, F_SETFL, flags ^ O_NONBLOCK
	xor		DWORD [ebp-4], O_NONBLOCK
	push	DWORD [ebp-4]
	push	F_SETFL
	push	STDIN
	call	fcntl
	add		esp, 12

	mov		eax, DWORD [ebp-8]

	mov		esp, ebp
	pop		ebp
	ret
