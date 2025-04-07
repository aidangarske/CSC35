#lab1 - Aidan Garske

.intel_syntax noprefix
.data
Message:
	.ascii "Hello world!\n\0"

Message1:
	.ascii "Beep\n\0"

Message2:
	.ascii "My name is Aidan and I like pacMan\n\0"

Message3:
	.ascii "Behind every great man is a woman rolling her eyes - Jim Carrey\n\0"

Message4:
	.ascii "Boop\n\0"

.text
.global Begin

Begin:
	lea rsi, Message
	call PrintString

	lea rsi, Message1
        call PrintString

	lea rsi, Message2
        call PrintString

	lea rsi, Message3
        call PrintString

	lea rsi, Message4
        call PrintString

	call ExitProgram
