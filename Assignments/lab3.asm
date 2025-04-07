.intel_syntax noprefix
.data

Prompt:
	.ascii "1 -> Qbert, 2 -> Aztarac, 3 -> DonkeyKong, 4 -> Frogger, 5 -> GoFish, 6 -> Default\n what game are you going to play?!\n\0"

Qbert:
	.ascii "make all the sqaures one color and dodge the snake!\n\0"

Aztarac:
	.ascii "shoot blue tanks with this multidirectional game!\n\0"

DonkeyKong:
	.ascii "save the princess, climb laters, and dodge barrels!\n\0"

Frogger:
	.ascii "help the frog get home!\n\0"

GoFish:
	.ascii "eat fish in this relaxing game till you get bigger!\n\0"

Default:
	.ascii "go touch some grass kid!\n\0"

.text
.global Begin
Begin:
	mov rax, 0      # initialize counter to 0

GameLoop:
	lea rsi, Prompt
	call PrintString
	call ReadInteger

	cmp rsi, 1
	je PrintQbert
	cmp rsi, 2
	je PrintAztarac
	cmp rsi, 3
	je PrintDonkeyKong
	cmp rsi, 4
	je PrintFrogger
	cmp rsi, 5
	je PrintGoFish
	cmp rsi, 6
	je PrintDefault

PrintQbert:
	lea rsi, Qbert
	call PrintString
	add rax, 1
	jmp GameLoop

PrintAztarac:
	lea rsi, Aztarac
	call PrintString
	add rax, 1
	jmp GameLoop

PrintDonkeyKong:
	lea rsi, DonkeyKong
	call PrintString
	add rax, 1
	jmp GameLoop

PrintFrogger:
	lea rsi, Frogger
	call PrintString
	add rax, 1
	jmp GameLoop

PrintGoFish:
	lea rsi, GoFish
	call PrintString
	add rax, 1
	jmp GameLoop

PrintDefault:
	lea rsi, Default
	call PrintString
	jmp Break

Break:
	mov rsi, rax # move the counter to rsi then print it
	call PrintInteger
	call ExitProgram
