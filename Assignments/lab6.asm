# Lab 6 - Aidan Garske - 4/8/25
.intel_syntax noprefix
.data

ChoiceMsg:
    .ascii "Goomba : 100 points\n"
    .ascii "Bullet Bill : 200 points\n"
    .ascii "Koopa Paratroopa : 400 points\n"
    .ascii "Hammer Brother : 1000 points\n\0"

PromptMsg:
    .ascii "\nEnter the number of each enemy destroyed...\n\0"
GoombaMsg:
    .ascii "How many Goombas did you destroy?\n\0"
BulletBillMsg:
    .ascii "How many Bullet Bills where obliterated?\n\0"
KoopaParatroopaMsg:
    .ascii "How many Koopa Paratroopas where smashed?\n\0"
HammerBrotherMsg:
    .ascii "How many Hammer Brothers where beat?\n\0"

# Player Varaibles
GoombaKilled:             .quad 20
BulletBillsKilled:        .quad 20
KoopaParatroopaKilled:    .quad 20
HammerBrotherKilled:      .quad 20

# Multiplied Points varaible
GoombaPoints:             .quad 1000
BulletBillsPoints:        .quad 1000
KoopaParatroopaPoints:    .quad 1000
HammerBrotherPoints:      .quad 1000

# Total Player Points
PlayerPoints:             .quad 10000

# Point Constants
POINTS_GOOMBA:            .quad 100
POINTS_BULLET_BILL:       .quad 200
POINTS_KOOPA_PARATROOPA:  .quad 400
POINTS_HAMMER_BROTHER:    .quad 1000

# Format Strings for final output msg
fmt_make_string0:         .ascii "Thats a total of \0"
fmt_make_string1:         .ascii " points from \0"
fmt_make_string2:         .ascii " Goombas, \0"
fmt_make_string3:         .ascii " Bullet Bills, \0"
fmt_make_string4:         .ascii " Koopa Paratroopas, and \0"
fmt_make_string5:         .ascii " Hammer Brothers.\n\0"

.text
.global Begin
# Read user input and store each value into there varaible
Begin:
    # Print choice msg and prompt
    lea rsi, ChoiceMsg
    call PrintString
    lea rsi, PromptMsg
    call PrintString

    # Print goomba message, read, and store input
    lea rsi, GoombaMsg
    call PrintString
    call ReadInteger
    mov [GoombaKilled], rsi

    # Print bullet bills message, read, and store input
    lea rsi, BulletBillMsg
    call PrintString
    call ReadInteger
    mov [BulletBillsKilled], rsi

    # Print koopa paratroopas message, read, and store input
    lea rsi, KoopaParatroopaMsg
    call PrintString
    call ReadInteger
    mov [KoopaParatroopaKilled], rsi

    # Print hammer brothers message, read, and store input
    lea rsi, HammerBrotherMsg
    call PrintString
    call ReadInteger
    mov [HammerBrotherKilled], rsi

# Multiply and store back into label
imul1_Goomba:
    # move input and points imul then mov back
    mov rsi, [GoombaKilled]
    mov rax, [POINTS_GOOMBA]
    imul rsi, rax
    mov [GoombaPoints], rsi

imul2_BulletBill:
    # move input and points imul then mov back
    mov rsi, [BulletBillsKilled]
    mov rax, [POINTS_BULLET_BILL]
    imul rsi, rax
    mov [BulletBillsPoints], rsi

imul3_KoopaParatroopa:
    # move input and points imul then mov back
    mov rsi, [KoopaParatroopaKilled]
    mov rax, [POINTS_KOOPA_PARATROOPA]
    imul rsi, rax
    mov [KoopaParatroopaPoints], rsi

imul4_HammerBrother:
    # move input and points imul then mov back
    mov rsi, [HammerBrotherKilled]
    mov rax, [POINTS_HAMMER_BROTHER]
    imul rsi, rax
    mov [HammerBrotherPoints], rsi

# Now add all the points up
AddPoints:
    # (GoombaPoints + BulletBillsPoints + KoopaParatroopaPoints + HammerBrotherPoints)
    mov rax, [GoombaPoints]
    mov rbx, [BulletBillsPoints]
    add rax, rbx
    mov rbx, [KoopaParatroopaPoints]
    add rax, rbx
    mov rbx, [HammerBrotherPoints]
    add rax, rbx
    # move the total points in rax to PlayerPoints
    mov [PlayerPoints], rax

# Now assemble the string and print it
MakeString:
    # Print the entire sentence concatinated together
    lea rsi, fmt_make_string0
    call PrintString
    mov rsi, [PlayerPoints]
    call PrintInteger
    lea rsi, fmt_make_string1
    call PrintString
    mov rsi, [GoombaPoints]
    call PrintInteger
    lea rsi, fmt_make_string2
    call PrintString
    mov rsi, [BulletBillsPoints]
    call PrintInteger
    lea rsi, fmt_make_string3
    call PrintString
    mov rsi, [KoopaParatroopaPoints]
    call PrintInteger
    lea rsi, fmt_make_string4
    call PrintString
    mov rsi, [HammerBrotherPoints]
    call PrintInteger
    lea rsi, fmt_make_string5
    call PrintString

Exit:
    call ExitProgram
