#lab2 - Aidan Garske

.intel_syntax noprefix
.data
message1:
        .ascii "Do you want to eat ghosts? 1 = yes | 2 = no\n\0"

answer1:
	.ascii "Pac-Man!\n\0"

message2:
	.ascii "Do you want to defend our planet? 1 = yes | 2 = no\n\0"

answer2:
	.ascii "Galaga!\n\0"

message3:
	.ascii "Do you want to drive fast cars? 1 = yes | 2 = no\n\0"

answer3:
	.ascii "Grand Prix or Enduro!\n\0"

message4:
	.ascii "Do you want to shoot freinds? 1 = yes | 2 = no\n\0"

answer4:
	.ascii "Outlaw!\n\n\0"

goodbye:
	.ascii "Goodbye!\n\0"

.text
.global Begin
Begin:
	#load the message and let user answer
	lea rsi, message1
	call PrintString
	call ReadInteger

	# do if = 1
	cmp rsi, 1
	jne ask2

	# output ans on screen
	lea rsi, answer1
	call PrintString

ask2:
	#load the message and let user answer
	lea rsi, message2
       	call PrintString
       	call ReadInteger

       	# do if = 1
       	cmp rsi, 1
       	jne ask3

	# output ans on screen
       	lea rsi, answer2
       	call PrintString

ask3:
	#load the message and let user answer
 	lea rsi, message3
       	call PrintString
       	call ReadInteger

       	# do if = 1
       	cmp rsi, 1
       	jne ask4

	# output ans on screen
       	lea rsi, answer3
       	call PrintString

ask4:
	#load the message and let user answer
 	lea rsi, message4
       	call PrintString
       	call ReadInteger

       	# do if = 1
       	cmp rsi, 1
       	jne Done

	# output ans on screen and exit
       	lea rsi, answer4
       	call PrintString
       	jmp Done

Done:
	lea rsi, goodbye
	call PrintString
        call ExitProgram
