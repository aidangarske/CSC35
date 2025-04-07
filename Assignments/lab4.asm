# Aidan Garske - 3/18/2025
.intel_syntax noprefix
.data

Prompt:
    .ascii "Captain, enemy tank detected in the distance! What are your orders?\n\0"
TargetPrompt:
    .ascii "Target position: \0"
ShortMsg:
    .ascii "The round landed SHORT of the enemy.\n\0"
FarMsg:
    .ascii "The round landed BEHIND the enemy.\n\0"
EnemyMissMsg:
    .ascii "The enemy round hits \0"
YardsAwayMsg:
    .ascii " yards away!\n\0"
WinMsg:
    .ascii "KA-BOOM! The enemy was destroyed! You win\n\0"
LoseMsg:
    .ascii "Your position was overrun! Game Over.\n\0"

.text
.global Begin
Begin:
    # Prompt the user
    lea rsi, Prompt
    call PrintString
    # Initialize game
    mov rsi, 100     # Get random number 1-100
    call GetRandomRange
    mov r12, rax     # Store enemy position in r12
    mov r13, 100     # Enemy distance starts at 100

GameLoop:
    # Player's turn
    lea rsi, TargetPrompt
    call PrintString
    call ReadInteger # Get target position in rsi

    # Compare target with enemy position
    cmp rsi, r12    # r12 = enemy postion : rsi target
    je YouWin       # If it equals then you win

    cmp rsi, r12    # r12 = enemy postion : rsi target
    jl PrintShort   # If its less than you are SHORT
    jg PrintFar     # If its greater than you are BEHIND

Continue:
    # Enemy's turn
    mov rsi, 30      # Get random number 1-30
    call GetRandomRange

    sub r13, rax     # Subtract from enemy distance
    cmp r13, 0       # Check if enemy distance is 0
    jle YouLose      # If enemy distance is 0, you lose

    # Print enemy miss message
    lea rsi, EnemyMissMsg
    call PrintString
    mov rsi, r13
    call PrintInteger
    lea rsi, YardsAwayMsg
    call PrintString

    jmp GameLoop    # Loop back to the top

PrintShort:
    lea rsi, ShortMsg
    call PrintString
    jmp Continue

PrintFar:
    lea rsi, FarMsg
    call PrintString
    jmp Continue

YouWin:
    lea rsi, WinMsg
    call PrintString
    jmp Exit

YouLose:
    lea rsi, LoseMsg
    call PrintString
    jmp Exit

Exit:
    call ExitProgram

# Helper function to get rng
GetRandomRange:      # Input: rsi = upper bound
    push rbx         # save the original rbx
    push rdx         # save the original rdx
    call GetRandom   # Get random number in rsi (0 to bound-1)
    mov rax, rsi     # Move random number to rax for division
    mov rbx, rsi     # Use input as divisor
    xor rdx, rdx     # Clear rdx for division
    div rbx          # Divide rax by rbx
    mov rax, rdx     # Move remainder to return value
    add rax, 1       # Add 1 to get range 1 to bound
    pop rdx          # Restore the original rdx
    pop rbx          # Restore the original rbx
    ret              # Return the result in rax
