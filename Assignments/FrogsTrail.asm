# FrogsTrail.asm
# Aidan Garske
# 30 Mar 2025

.intel_syntax noprefix
.data

FrogsTrail:
    .ascii "\n"
	.ascii "\n"
	.ascii "___________                            ___________             .__.__   \n"
	.ascii "\\_   _____/______  ____   ____  ______ \\__    ___/___________  |__|  |  \n"
	.ascii " |    __) \\_  __ \\/  _ \\ / ___\\/  ___/   |    |  \\_  __ \\__  \\ |  |  |  \n"
	.ascii " |     \\   |  | \\(  <_> ) /_/  >___ \\    |    |   |  | \\// __ \\|  |  |__\n"
	.ascii " \\___  /   |__|   \\____/\\___  /____  >   |____|   |__|  (____  /__|____/\n"
	.ascii "     \\/                /_____/     \\/                        \\/         \n"
	.ascii "\n"
	.ascii "\n\0"

WelcomeMsg:
    .ascii "Welcome to Frog's Trail!\n"
    .ascii "You are a brave frog trying to reach the Great Pond 1000 lily pads away.\n"
    .ascii "The evil forces of nature are approiaching quickly.\n"
    .ascii "You have 60 days to make it there before the storm comes...\n\0"

ResourceMsg:
    .ascii "\nYour resources:\n"
	.ascii "   * Your skin conditon drops 5-15% each day you travel. \n"
	.ascii "     If it reaches zero, you pass out and cannot continue.\n"
	.ascii "   * You will eat 5-10 flies each day.\n"
	.ascii "   * If you are starving, your health drops 10-20% each day.\n\0"

ChoiceMsg:
    .ascii "\nWhat would you like to do?\n"
    .ascii "(1) Rest in the sun (1-5 days, restores 30-60% energy)\n"
    .ascii "(2) Moisturize your skin (1-3 days, improves skin 10-50%)\n"
    .ascii "(3) Hunt for flies (1 day, catch 20-200 flies)\n"
    .ascii "(4) Hop forward (5-80 lily pads, uses energy and dries skin)\n"
    .ascii "(5) Find a temporary pond (2-4 days, restores 20-40% energy and skin)\n"
    .ascii "(6) Trade with other frogs (1 day, gamble flies for better supplies)\n"
    .ascii "Enter your choice (1-6): \0"

GameOverMsg:
    .ascii "\n=====Game Over!=====\n"
    .ascii "You didn't make it to the Great Pond in time :(\n"
    .ascii "You died valiantly brave frog. Better luck next time.\n\0"

VictoryMsg:
    .ascii "\n=====Congratulations!=====\n"
    .ascii "You've made it to the Great Pond!\n"
    .ascii "You're a true frog hero!\n\0"

# Game variables
daysRemaining:    .quad 60
distanceLeft:     .quad 1000
frogEnergy:       .quad 100
foodSupply:       .quad 100
skinCondition:    .quad 100
currentChoice:    .quad 0
currentDay:       .quad 1

# Constants for random ranges
MIN_WAGON_DROP:   .quad 5
MAX_WAGON_DROP:   .quad 15
MIN_FOOD_EATEN:   .quad 5
MAX_FOOD_EATEN:   .quad 10
MIN_HEALTH_DROP:  .quad 5
MAX_HEALTH_DROP:  .quad 10
MIN_REST_HEALTH:  .quad 30
MAX_REST_HEALTH:  .quad 60
MIN_REST_DAYS:    .quad 1
MAX_REST_DAYS:    .quad 5
MIN_REPAIR:       .quad 10
MAX_REPAIR:       .quad 50
MIN_REPAIR_DAYS:  .quad 1
MAX_REPAIR_DAYS:  .quad 3
MIN_HUNT_FOOD:    .quad 20
MAX_HUNT_FOOD:    .quad 200
MIN_TRAVEL:       .quad 5
MAX_TRAVEL:       .quad 80

# New constants for additional choices
MIN_POND_DAYS:    .quad 2
MAX_POND_DAYS:    .quad 4
MIN_POND_BENEFIT: .quad 20
MAX_POND_BENEFIT: .quad 40
MIN_TRADE_LOSS:   .quad 10
MAX_TRADE_LOSS:   .quad 30
MIN_TRADE_GAIN:   .quad 15
MAX_TRADE_GAIN:   .quad 50

# Format strings for output
fmt_int:          .ascii "%d\0"
fmt_str:          .ascii "%s\0"
fmt_newline:      .ascii "\n\0"

# Format strings for StatusMsg
fmt_day:          .ascii "\nJOURNEY DAY \0"
fmt_distance:     .ascii "Distance left      : \0"
fmt_lilypads:     .ascii " lily pads\n\0"
fmt_skin:         .ascii "Skin condition     : \0"
fmt_percent:      .ascii "%\0"
fmt_energy:       .ascii "Your energy        : \0"
fmt_food:         .ascii "Food supply        : \0"
fmt_flies:        .ascii " flies\n\0"

# Format strings for Case1_Rest
fmt_rest_days:    .ascii "\n** You rested for \0"
fmt_rest_days2:   .ascii " days. **\n\0"
fmt_rest_gain:    .ascii "You gained \0"
fmt_rest_gain2:   .ascii "% energy.\n\0"

# Format strings for Case2_Moisturize
fmt_moist_days:   .ascii "\n** You moisturized for \0"
fmt_moist_days2:  .ascii " days. **\n\0"
fmt_moist_gain:   .ascii "Your skin condition improved by \0"
fmt_moist_gain2:  .ascii "%.\n\0"

# Format strings for Case3_Hunt
fmt_hunt_success: .ascii "\nRibbit! You caught \0"
fmt_hunt_success2:.ascii " flies!\n\0"

# Format strings for Case4_Hop
fmt_hop_advance:  .ascii "\nYou hopped forward \0"
fmt_hop_advance2: .ascii " lily pads.\n\0"
fmt_hop_skin:     .ascii "Your skin dried out by \0"
fmt_hop_skin2:    .ascii "%.\n\0"
fmt_hop_energy:   .ascii "You lost \0"
fmt_hop_energy2:  .ascii "% energy.\n\0"
fmt_hop_dry:      .ascii "YOUR SKIN IS TOO DRY!\n\0"

# Format strings for Case5_Pond
fmt_pond_days:    .ascii "** You found a pond and stayed for \0"
fmt_pond_days2:   .ascii " days. **\n\0"
fmt_pond_benefit: .ascii "Your energy and skin improved by \0"
fmt_pond_benefit2:.ascii "%.\n\0"

# Format strings for Case6_Trade
fmt_trade_loss:   .ascii "\nThe other frogs tricked you! You lost \0"
fmt_trade_loss2:  .ascii " flies.\n\0"
fmt_trade_gain:   .ascii "\nThe trade was successful! You gained \0"
fmt_trade_gain2:  .ascii " flies.\n\0"

# Format strings for ProcessDuration
fmt_food_eaten:   .ascii "On day \0"
fmt_food_eaten2:  .ascii ", you ate \0"
fmt_food_eaten3:  .ascii " flies.\n\0"
fmt_starving:     .ascii "YOU ARE STARVING ON DAY \0"
fmt_starving2:    .ascii "! You lost \0"
fmt_starving3:    .ascii "% energy.\n\0"

# Temporary variables for calculations
duration:    .quad 0
energyGain:  .quad 0
skinGain:    .quad 0

# Additional temporary variables
distanceGain:   .quad 0
skinLoss:       .quad 0
energyLoss:     .quad 0

.text
.global Begin

Begin:
    # Initialize game variables
    mov qword ptr [distanceLeft], 1000
    mov qword ptr [frogEnergy], 100
    mov qword ptr [skinCondition], 100
    mov qword ptr [foodSupply], 100
    mov qword ptr [daysRemaining], 60
    mov qword ptr [currentDay], 1


    mov rsi, 2
    call ChangeTextColor
    # Print FrogsTrail banner
    lea rsi, FrogsTrail
    call PrintString
    mov rsi, 7
    call ChangeTextColor
    # Print welcome message
    lea rsi, WelcomeMsg
    call PrintString
    # Print resource message
    lea rsi, ResourceMsg
    call PrintString

MainGameLoop:
    # Check if game should continue:
    # - distanceLeft > 0
    mov rsi, distanceLeft
    cmp rsi, 0
    jle GameOver # if <= 0 game over
    # - daysRemaining > 0
    mov rsi, daysRemaining
    cmp rsi, 0
    jle GameOver # if <= 0 game over
    # - frogEnergy > 0
    mov rsi, frogEnergy
    cmp rsi, 0
    jle GameOver # if <= 0 game over

PrintStatusMsg:
    # Print current day message
    lea rsi, fmt_day
    call PrintString
    mov rsi, [currentDay]
    call PrintInteger
    lea rsi, fmt_newline
    call PrintString
    lea rsi, fmt_newline
    call PrintString

    # Print distance left in red
    lea rsi, fmt_distance
    call PrintString
    mov rsi, 1
    call ChangeTextColor
    mov rsi, [distanceLeft]
    call PrintInteger
    lea rsi, fmt_lilypads
    call PrintString
    mov rsi, 7
    call ChangeTextColor

    # Print skin condition
    lea rsi, fmt_skin
    call PrintString
    mov rsi, 2
    call ChangeTextColor
    mov rsi, [skinCondition]
    call PrintInteger
    lea rsi, fmt_percent
    call PrintString
    lea rsi, fmt_newline
    call PrintString
    mov rsi, 7
    call ChangeTextColor

    # Print energy
    lea rsi, fmt_energy
    call PrintString
    mov rsi, 3
    call ChangeTextColor
    mov rsi, [frogEnergy]
    call PrintInteger
    lea rsi, fmt_percent
    call PrintString
    lea rsi, fmt_newline
    call PrintString
    mov rsi, 7
    call ChangeTextColor

    # Print food supply
    lea rsi, fmt_food
    call PrintString
    mov rsi, 4
    call ChangeTextColor
    mov rsi, [foodSupply]
    call PrintInteger
    lea rsi, fmt_flies
    call PrintString
    mov rsi, 7
    call ChangeTextColor

    # Print choice menu
    lea rsi, ChoiceMsg
    call PrintString

    # Read and store user input in currentChoice
    call ReadInteger
    mov [currentChoice], rsi

    # Compare cases and jmp to appropriate one
    mov rsi, [currentChoice]
    cmp rsi, 1
    je Case1_Rest
    cmp rsi, 2
    je Case2_Moisturize
    cmp rsi, 3
    je Case3_Hunt
    cmp rsi, 4
    je Case4_Hop
    cmp rsi, 5
    je Case5_Pond
    cmp rsi, 6
    je Case6_Trade

Case1_Rest:
    # Generate random days (1-5)
    mov rsi, 5
    call GetRandom
    add rsi, 1
    mov [duration], rsi

    # Print rest duration
    lea rsi, fmt_rest_days
    call PrintString
    mov rsi, [duration]
    call PrintInteger
    lea rsi, fmt_rest_days2
    call PrintString

    # Generate random energy gain (30-60)
    mov rsi, 31
    call GetRandom
    add rsi, 30
    mov [energyGain], rsi  # Store energy gain

    # Add to frogEnergy
    mov rsi, [frogEnergy]
    add rsi, [energyGain]
    # Cap energy at 100
    cmp rsi, 100
    jle .storeEnergy
    mov rsi, 100
.storeEnergy:
    mov [frogEnergy], rsi

    # Print energy gain
    lea rsi, fmt_rest_gain
    call PrintString
    mov rsi, [energyGain]
    call PrintInteger
    lea rsi, fmt_rest_gain2
    call PrintString

    jmp ProcessDuration

Case2_Moisturize:
    # Generate random days (1-3)
    mov rsi, 3
    call GetRandom
    add rsi, 1
    mov [duration], rsi

    # Print moisturize duration
    lea rsi, fmt_moist_days
    call PrintString
    mov rsi, [duration]
    call PrintInteger
    lea rsi, fmt_moist_days2
    call PrintString

    # Generate random skin improvement (10-50)
    mov rsi, 41
    call GetRandom
    add rsi, 10
    mov [skinGain], rsi

    # Add to skinCondition
    mov rsi, [skinCondition]
    add rsi, [skinGain]
    # Cap skinCondition at 100
    cmp rsi, 100
    jle .storeSkin
    mov rsi, 100
.storeSkin:
    mov [skinCondition], rsi

    # Print skin improvement
    lea rsi, fmt_moist_gain
    call PrintString
    mov rsi, [skinGain]
    call PrintInteger
    lea rsi, fmt_moist_gain2
    call PrintString

    jmp ProcessDuration

Case3_Hunt:
    # Set duration to 1
    mov rsi, 1
    mov [duration], rsi

    # Generate random flies (20-200)
    mov rsi, 181
    call GetRandom
    add rsi, 20
    mov [foodSupply], rsi

    # Print flies caught
    lea rsi, fmt_hunt_success
    call PrintString
    mov rsi, [foodSupply]
    call PrintInteger
    lea rsi, fmt_hunt_success2
    call PrintString

    jmp ProcessDuration

Case4_Hop:
    # Set duration to 1
    mov rsi, 1
    mov [duration], rsi

    # Check if skinCondition > 0
    mov rsi, [skinCondition]
    cmp rsi, 0
    jle .skinTooDry

    # Generate random distance (5-80)
    mov rsi, 76
    call GetRandom
    add rsi, 5
    mov [distanceGain], rsi

    # Subtract from distanceLeft
    mov rsi, [distanceLeft]
    sub rsi, [distanceGain]
    mov [distanceLeft], rsi

    # Print distance covered
    lea rsi, fmt_hop_advance
    call PrintString
    mov rsi, [distanceGain]
    call PrintInteger
    lea rsi, fmt_hop_advance2
    call PrintString

    # Generate random skin damage (5-15)
    mov rsi, 11
    call GetRandom
    add rsi, 5
    mov [skinLoss], rsi

    # Subtract from skinCondition
    mov rsi, [skinCondition]
    sub rsi, [skinLoss]
    mov [skinCondition], rsi

    # Check if skinCondition <= 0
    mov rsi, [skinCondition]
    cmp rsi, 0
    jle GameOver

    # Print skin damage
    lea rsi, fmt_hop_skin
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_hop_skin2
    call PrintString

    jmp .energyLoss

.skinTooDry:
    # Print "YOUR SKIN IS TOO DRY!"
    lea rsi, fmt_hop_dry
    call PrintString

.energyLoss:
    # Generate random energy loss (5-10)
    mov rsi, 6
    call GetRandom
    add rsi, 5
    mov [energyLoss], rsi

    # Subtract from frogEnergy
    mov rsi, [frogEnergy]
    sub rsi, [energyLoss]
    mov [frogEnergy], rsi

    # Check if frogEnergy <= 0
    mov rsi, [frogEnergy]
    cmp rsi, 0
    jle GameOver

    # Print energy loss
    lea rsi, fmt_hop_energy
    call PrintString
    mov rsi, [energyLoss]
    call PrintInteger
    lea rsi, fmt_hop_energy2
    call PrintString

    jmp ProcessDuration

Case5_Pond:
    # Generate random days (2-4)
    mov rsi, 3
    call GetRandom
    add rsi, 2
    mov [duration], rsi

    # Print pond duration
    lea rsi, fmt_pond_days
    call PrintString
    mov rsi, [duration]
    call PrintInteger
    lea rsi, fmt_pond_days2
    call PrintString

    # Generate random benefit (20-40)
    mov rsi, 21
    call GetRandom
    add rsi, 20
    mov [energyGain], rsi

    # Add to both frogEnergy and skinCondition
    mov rsi, [frogEnergy]
    add rsi, [energyGain]
    mov [frogEnergy], rsi

    mov rsi, [skinCondition]
    add rsi, [energyGain]
    mov [skinCondition], rsi

    # Print benefits
    lea rsi, fmt_pond_benefit
    call PrintString
    mov rsi, [energyGain]
    call PrintInteger
    lea rsi, fmt_pond_benefit2
    call PrintString

    jmp ProcessDuration

Case6_Trade:
    # Set duration to 1
    mov rsi, 1
    mov [duration], rsi

    # Generate random trade outcome (0 or 1)
    mov rsi, 2
    call GetRandom

    # If rsi == 0, loss. If rsi == 1, gain
    cmp rsi, 0
    je .tradeLoss

.tradeGain:
    # Generate random gain (15-50 flies)
    mov rsi, 36
    call GetRandom
    add rsi, 15
    mov [energyGain], rsi

    # Add to foodSupply
    mov rsi, [foodSupply]
    add rsi, [energyGain]
    mov [foodSupply], rsi

    # Print gain message
    lea rsi, fmt_trade_gain
    call PrintString
    mov rsi, [energyGain]
    call PrintInteger
    lea rsi, fmt_trade_gain2
    call PrintString
    jmp ProcessDuration

.tradeLoss:
    # Generate random loss (10-30 flies)
    mov rsi, 21
    call GetRandom
    add rsi, 10
    mov [energyLoss], rsi

    # Subtract from foodSupply
    mov rsi, [foodSupply]
    sub rsi, [energyLoss]
    mov [foodSupply], rsi

    # Print loss message
    lea rsi, fmt_trade_loss
    call PrintString
    mov rsi, [energyLoss]
    call PrintInteger
    lea rsi, fmt_trade_loss2
    call PrintString
    jmp ProcessDuration

ProcessDuration:
    # Store initial duration as our counter
    mov rsi, [duration]
    mov [energyLoss], rsi

.dayLoop:
    # Check if we should continue loop
    mov rsi, [energyLoss]
    cmp rsi, 0
    jle .endLoop

    # Check if we have food
    mov rsi, [foodSupply]
    cmp rsi, 0
    jle .starving

.hasFood:
    # Generate random food eaten (5-10)
    mov rsi, 6
    call GetRandom
    add rsi, 5
    mov [skinLoss], rsi

    # Subtract from foodSupply
    mov rsi, [foodSupply]
    sub rsi, [skinLoss]
    mov [foodSupply], rsi

    # Print food eaten message
    lea rsi, fmt_food_eaten
    call PrintString
    mov rsi, [currentDay]
    call PrintInteger
    lea rsi, fmt_food_eaten2
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_food_eaten3
    call PrintString
    jmp .nextDay

.starving:
    # Generate random energy loss (10-20)
    mov rsi, 11
    call GetRandom
    add rsi, 10
    mov [skinLoss], rsi

    # Subtract from frogEnergy
    mov rsi, [frogEnergy]
    sub rsi, [skinLoss]
    mov [frogEnergy], rsi

    # Check if frogEnergy <= 0
    mov rsi, [frogEnergy]
    cmp rsi, 0
    jle GameOver

    # Print starvation message
    lea rsi, fmt_starving
    call PrintString
    mov rsi, [currentDay]
    call PrintInteger
    lea rsi, fmt_starving2
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_starving3
    call PrintString

.nextDay:
    # Add 1 to currentDay
    mov rsi, [currentDay]
    inc rsi
    mov [currentDay], rsi

    # Subtract 1 from daysRemaining
    mov rsi, [daysRemaining]
    dec rsi
    mov [daysRemaining], rsi

    # Decrement loop counter and continue
    mov rsi, [energyLoss]
    dec rsi
    mov [energyLoss], rsi
    jmp .dayLoop

.endLoop:
    jmp MainGameLoop

GameOver:
    # Check if distance <= 0 (victory condition)
    mov rsi, [distanceLeft]
    cmp rsi, 0
    jle .victory

    # If not victory, print game over message
    lea rsi, GameOverMsg
    call PrintString
    jmp Exit

.victory:
    # Print victory message
    lea rsi, VictoryMsg
    call PrintString
    jmp Exit

Exit:
    call ExitProgram
