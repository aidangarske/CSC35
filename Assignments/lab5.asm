# Lab5 - Aidan Garske - 3-26-2025
.intel_syntax noprefix
.data

Prompt:
    .ascii "Welcome to Silly Sentences!\n\0"
PromptNounA:
    .ascii "Player A, please enter a noun:\n\0"
PromptVerbB:
    .ascii "Player B, please enter a verb:\n\0"
PromptPrepA:
    .ascii "Player A, please enter a preposition:\n\0"
PromptNounB:
    .ascii "Player B, please enter an article or possessive pronoun followed by a noun:\n\0"
PromptDone:
    .ascii "Congrats! your silly sentence is...\n\0"

PromptSpace:
    .ascii " \0"
PromptSpaceEnd:
    .ascii ".\0\n"

InputNounA:
    .space 15
InputVerbB:
    .space 15
InputPrepA:
    .space 15
InputNounB:
    .space 15

.text
.global Begin
Begin:
    # Print prompt
    lea rsi, Prompt
    call PrintString

    # Print PromptNounA
    lea rsi, PromptNounA
    call PrintString

    # Read noun from user A input
    lea rsi, InputNounA
    mov rdi, 15
    call ReadString

    call ClearScreen

    # Print PromptVerbB
    lea rsi, PromptVerbB
    call PrintString

    # Read verb from user B input
    lea rsi, InputVerbB
    mov rdi, 15
    call ReadString

    call ClearScreen

    # Print PromptPrepA
    lea rsi, PromptPrepA
    call PrintString

    # Read prep from user A input
    lea rsi, InputPrepA
    mov rdi, 15
    call ReadString

    call ClearScreen

    # Print PromptNounB
    lea rsi, PromptNounB
    call PrintString

    # Read noun from user B input
    lea rsi, InputNounB
    mov rdi, 15
    call ReadString

    call ClearScreen

    # Print completion message
    lea rsi, PromptDone
    call PrintString

    # Print the final sentence
    lea rsi, InputNounA
    call PrintString

    lea rsi, PromptSpace
    call PrintString

    lea rsi, InputVerbB
    call PrintString

    lea rsi, PromptSpace
    call PrintString

    lea rsi, InputPrepA
    call PrintString

    lea rsi, PromptSpace
    call PrintString

    lea rsi, InputNounB
    call PrintString

    lea rsi, PromptSpaceEnd
    call PrintString

Exit:
    call ExitProgram
