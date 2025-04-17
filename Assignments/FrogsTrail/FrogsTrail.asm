# FrogsTrail.asm
# Aidan Garske
# 30 Mar 2025

.intel_syntax noprefix
.data

FrogsTrailASCII:
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

# VT100 Color Constants
COLOR_RED:      .quad 1
COLOR_GREEN:    .quad 2
COLOR_YELLOW:   .quad 3
COLOR_BLUE:     .quad 4
COLOR_WHITE:    .quad 7

# Temporary variables for calculations
duration:    .quad 0
energyGain:  .quad 0
skinGain:    .quad 0

# Additional temporary variables
distanceGain:   .quad 0
skinLoss:       .quad 0
energyLoss:     .quad 0

# Constants for random ranges
MIN_WAGON_DROP:   .quad 5
WAGON_DROP_RANGE: .quad 11    # 15-5+1 = 11
MIN_FOOD_EATEN:   .quad 5
FOOD_EATEN_RANGE: .quad 6     # 10-5+1 = 6
MIN_HEALTH_DROP:  .quad 5
HEALTH_DROP_RANGE:.quad 6     # 10-5+1 = 6
MIN_REST_HEALTH:  .quad 30
REST_HEALTH_RANGE:.quad 31    # 60-30+1 = 31
MIN_REST_DAYS:    .quad 1
REST_DAYS_RANGE:  .quad 5     # 5-1+1 = 5
MIN_REPAIR:       .quad 10
REPAIR_RANGE:     .quad 41    # 50-10+1 = 41
MIN_REPAIR_DAYS:  .quad 1
REPAIR_DAYS_RANGE:.quad 3     # 3-1+1 = 3
MIN_HUNT_FOOD:    .quad 20
HUNT_FOOD_RANGE:  .quad 181   # 200-20+1 = 181
MIN_TRAVEL:       .quad 5
TRAVEL_RANGE:     .quad 76    # 80-5+1 = 76

# New constants for additional choices
MIN_POND_DAYS:    .quad 2
POND_DAYS_RANGE:  .quad 3     # 4-2+1 = 3
MIN_POND_BENEFIT: .quad 20
POND_BENEFIT_RANGE:.quad 21   # 40-20+1 = 21
MIN_TRADE_LOSS:   .quad 10
TRADE_LOSS_RANGE: .quad 21    # 30-10+1 = 21
MIN_TRADE_GAIN:   .quad 15
TRADE_GAIN_RANGE: .quad 36    # 50-15+1 = 36

# Constants for random events
MIN_STORM_ENERGY: .quad 10
STORM_ENERGY_RANGE:.quad 16   # 25-10+1 = 16
MIN_FAIRY_FLIES:  .quad 30
FAIRY_FLIES_RANGE:.quad 21    # 50-30+1 = 21
MIN_RAINBOW_SKIN: .quad 20
RAINBOW_SKIN_RANGE:.quad 21   # 40-20+1 = 21
MIN_SNAKE_FLIES:  .quad 15
SNAKE_FLIES_RANGE:.quad 21    # 35-15+1 = 21
MIN_FRIEND_ENERGY:.quad 15
FRIEND_ENERGY_RANGE:.quad 21  # 35-15+1 = 21
EVENT_CHANCE:     .quad 20    # 20% chance of event occurring
EVENT_TYPES:      .quad 5     # Number of different event types

# Format strings for output
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

# Format strings for random events
fmt_event_storm:    .ascii "\n*** STORM EVENT: Lightning struck nearby! You lost \0"
fmt_event_storm2:   .ascii "% energy from fear. ***\n\0"
fmt_event_fairy:    .ascii "\n*** FAIRY EVENT: A friendly fairy blessed you with \0"
fmt_event_fairy2:   .ascii " flies! ***\n\0"
fmt_event_rainbow:  .ascii "\n*** RAINBOW EVENT: A magical rainbow appears! Your skin condition improved by \0"
fmt_event_rainbow2: .ascii "%. ***\n\0"
fmt_event_snake:    .ascii "\n*** SNAKE EVENT: A snake appeared! You dropped \0"
fmt_event_snake2:   .ascii " flies while escaping. ***\n\0"
fmt_event_friend:   .ascii "\n*** FRIEND EVENT: You met a friendly toad who shared their energy! You gained \0"
fmt_event_friend2:  .ascii "% energy. ***\n\0"

# ASCII art for random events
LightningASCII:
    .ascii "\n"
    .ascii "     _, .--.\n"
	.ascii "    (  / (  '-.\n"
	.ascii "    .-=-.    ) -.\n"
	.ascii "   /   (  .' .   \\\n"
	.ascii "   \\ ( ' ,_) ) \\_/\n"
	.ascii "    (_ , /\\  ,_/\n"
	.ascii "      '--\\ `\\--`\n"
	.ascii "         _\\ _\\\n"
	.ascii "         `\\ \\\n"
	.ascii "          _\\_\\\n"
	.ascii "          `\\\\\n"
	.ascii "            \\\\\n"
	.ascii "        -.'.`\\.'.-\n\0"

FairyASCII:
    .ascii "\n"
    .ascii ".'.         .'.\n"
	.ascii "|  \\       /  |\n"
	.ascii "'.  \\  |  /  .'\n"
	.ascii "  '. \\\\|// .'\n"
	.ascii "    '-- --'\n"
	.ascii "    .'/|\\'.\n"
	.ascii "   '..'|'..'\n"
	.ascii "\n\0"

RainbowASCII:
    .ascii "\n"
    .ascii "     _.-\"\"\"\"`-._ \n"
	.ascii "   ,' _-\"\"\"\"`-_ `.\n"
	.ascii "  / ,'.-'\"\"\"`-.`. \\\n"
	.ascii " | / / ,'\"\"\"`. \\ \\ |\n"
	.ascii "| | | | ,'\"`. | | | |\n"
	.ascii "| | | | |   | | | | |\n"
	.ascii "\n\0"

SnakeASCII:
    .ascii "\n"
	.ascii "                          .-=-.          .--.\n"
	.ascii "              __        .'     '.       /  \" )\n"
	.ascii "      _     .'  '.     /   .-.   \\     /  .-'\\\n"
	.ascii "     ( \\   / .-.  \\   /   /   \\   \\   /  /    ^\n"
	.ascii "      \\ `-` /   \\  `-'   /     \\   `-`  /\n"
	.ascii "       `-.-`     '.____.'       `.____.'\n"
	.ascii "\n\0"

FriendASCII:
    .ascii "\n"
	.ascii "  __   ___.--'_`.\n"
	.ascii " ( _`.'. -   'o` )\n"
	.ascii " _\\.'_'      _.-'\n"
	.ascii "( \\`. )    //\\`\n"
	.ascii " \\_`-'`---'\\\\__,\n"
	.ascii "  \\`        `-\\\n\0"

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

    mov rsi, [COLOR_GREEN]
    call ChangeTextColor
    # Print FrogsTrail banner
    lea rsi, FrogsTrailASCII
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor
    # Print welcome message
    lea rsi, WelcomeMsg
    call PrintString
    # Print resource message
    lea rsi, ResourceMsg
    call PrintString

MainGameLoop:
    # Check if game should continue:
    # if <= 0 game over
    # - distanceLeft > 0
    mov rsi, distanceLeft
    cmp rsi, 0
    jle GameOver
    # - daysRemaining > 0
    mov rsi, daysRemaining
    cmp rsi, 0
    jle GameOver
    # - frogEnergy > 0
    mov rsi, frogEnergy
    cmp rsi, 0
    jle GameOver

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
    mov rsi, [COLOR_RED]
    call ChangeTextColor
    mov rsi, [distanceLeft]
    call PrintInteger
    lea rsi, fmt_lilypads
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    # Print skin condition
    lea rsi, fmt_skin
    call PrintString
    mov rsi, [COLOR_GREEN]
    call ChangeTextColor
    mov rsi, [skinCondition]
    call PrintInteger
    lea rsi, fmt_percent
    call PrintString
    lea rsi, fmt_newline
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    # Print energy
    lea rsi, fmt_energy
    call PrintString
    mov rsi, [COLOR_YELLOW]
    call ChangeTextColor
    mov rsi, [frogEnergy]
    call PrintInteger
    lea rsi, fmt_percent
    call PrintString
    lea rsi, fmt_newline
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    # Print food supply
    lea rsi, fmt_food
    call PrintString
    mov rsi, [COLOR_BLUE]
    call ChangeTextColor
    mov rsi, [foodSupply]
    call PrintInteger
    lea rsi, fmt_flies
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    # Print choice menu
    lea rsi, ChoiceMsg
    call PrintString

    # Read and store user input in currentChoice
    call ReadInteger
    mov [currentChoice], rsi

    # Compare cases and jmp to matching case
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
    mov rsi, [REST_DAYS_RANGE]
    call GetRandom
    add rsi, [MIN_REST_DAYS]
    mov [duration], rsi

    # Print rest duration
    lea rsi, fmt_rest_days
    call PrintString
    mov rsi, [duration]
    call PrintInteger
    lea rsi, fmt_rest_days2
    call PrintString

    # Generate random energy gain (30-60)
    mov rsi, [REST_HEALTH_RANGE]
    call GetRandom
    add rsi, [MIN_REST_HEALTH]
    mov [energyGain], rsi

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
    mov rsi, [REPAIR_DAYS_RANGE]
    call GetRandom
    add rsi, [MIN_REPAIR_DAYS]
    mov [duration], rsi

    # Print moisturize duration
    lea rsi, fmt_moist_days
    call PrintString
    mov rsi, [duration]
    call PrintInteger
    lea rsi, fmt_moist_days2
    call PrintString

    # Generate random skin improvement (10-50)
    mov rsi, [REPAIR_RANGE]
    call GetRandom
    add rsi, [MIN_REPAIR]
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
    mov rsi, [HUNT_FOOD_RANGE]
    call GetRandom
    add rsi, [MIN_HUNT_FOOD]
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
    mov rsi, [TRAVEL_RANGE]
    call GetRandom
    add rsi, [MIN_TRAVEL]
    mov [distanceGain], rsi

    # Subtract from distanceLeft
    mov rsi, [distanceLeft]
    sub rsi, [distanceGain]
    mov [distanceLeft], rsi

    mov rsi, [COLOR_RED]
    call ChangeTextColor
    lea rsi, fmt_hop_advance
    call PrintString
    mov rsi, [distanceGain]
    call PrintInteger
    lea rsi, fmt_hop_advance2
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    # Generate random skin damage (5-15)
    mov rsi, [WAGON_DROP_RANGE]
    call GetRandom
    add rsi, [MIN_WAGON_DROP]
    mov [skinLoss], rsi

    # Subtract from skinCondition
    mov rsi, [skinCondition]
    sub rsi, [skinLoss]
    mov [skinCondition], rsi

    # Check if skinCondition <= 0
    mov rsi, [skinCondition]
    cmp rsi, 0
    jle GameOver

    mov rsi, [COLOR_RED]
    call ChangeTextColor
    lea rsi, fmt_hop_skin
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_hop_skin2
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    jmp .energyLoss

.skinTooDry:
    # Print dry skin message
    lea rsi, fmt_hop_dry
    call PrintString

.energyLoss:
    # Generate random energy loss (5-10)
    mov rsi, [HEALTH_DROP_RANGE]
    call GetRandom
    add rsi, [MIN_HEALTH_DROP]
    mov [energyLoss], rsi

    # Subtract from frogEnergy
    mov rsi, [frogEnergy]
    sub rsi, [energyLoss]
    mov [frogEnergy], rsi

    # Check if frogEnergy <= 0
    mov rsi, [frogEnergy]
    cmp rsi, 0
    jle GameOver

    mov rsi, [COLOR_RED]
    call ChangeTextColor
    lea rsi, fmt_hop_energy
    call PrintString
    mov rsi, [energyLoss]
    call PrintInteger
    lea rsi, fmt_hop_energy2
    call PrintString
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    jmp ProcessDuration

Case5_Pond:
    # Generate random days (2-4)
    mov rsi, [POND_DAYS_RANGE]
    call GetRandom
    add rsi, [MIN_POND_DAYS]
    mov [duration], rsi

    # Print pond duration
    lea rsi, fmt_pond_days
    call PrintString
    mov rsi, [duration]
    call PrintInteger
    lea rsi, fmt_pond_days2
    call PrintString

    # Generate random benefit (20-40)
    mov rsi, [POND_BENEFIT_RANGE]
    call GetRandom
    add rsi, [MIN_POND_BENEFIT]
    mov [energyGain], rsi

    # Add both frogEnergy and skinCondition
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
    mov rsi, [TRADE_GAIN_RANGE]
    call GetRandom
    add rsi, [MIN_TRADE_GAIN]
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
    mov rsi, [TRADE_LOSS_RANGE]
    call GetRandom
    add rsi, [MIN_TRADE_LOSS]
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
    mov rsi, [COLOR_BLUE]
    call ChangeTextColor

    # Generate random food eaten (5-10)
    mov rsi, [FOOD_EATEN_RANGE]
    call GetRandom
    add rsi, [MIN_FOOD_EATEN]
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
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

    # Check for random event
    jmp .checkRandomEvent

.starving:
    mov rsi, [COLOR_YELLOW]
    call ChangeTextColor

    # Generate random energy loss (10-20)
    mov rsi, [HEALTH_DROP_RANGE]
    call GetRandom
    add rsi, [MIN_HEALTH_DROP]
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
    mov rsi, [COLOR_WHITE]
    call ChangeTextColor

.checkRandomEvent:
    # Generate random number (0-99)
    mov rsi, 100
    call GetRandom

    # Compare with event_chance (20%)
    cmp rsi, [EVENT_CHANCE]
    jg .nextDay    # If > 20, no event occurs

    # Generate random event (0-4)
    mov rsi, [EVENT_TYPES]
    call GetRandom

    # Compare and jump to appropriate event
    cmp rsi, 0
    je .stormEvent
    cmp rsi, 1
    je .fairyEvent
    cmp rsi, 2
    je .rainbowEvent
    cmp rsi, 3
    je .snakeEvent
    cmp rsi, 4
    je .friendEvent
    jmp .nextDay

.stormEvent:
    # Lose 10-25% energy from fear
    mov rsi, [STORM_ENERGY_RANGE]
    call GetRandom
    add rsi, [MIN_STORM_ENERGY]
    mov [skinLoss], rsi

    # Subtract from energy
    mov rsi, [frogEnergy]
    sub rsi, [skinLoss]
    mov [frogEnergy], rsi

    # Print message
    lea rsi, fmt_event_storm
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_event_storm2
    call PrintString
    lea rsi, LightningASCII
    call PrintString
    jmp .nextDay

.fairyEvent:
    # Gain 30-50 flies
    mov rsi, [FAIRY_FLIES_RANGE]
    call GetRandom
    add rsi, [MIN_FAIRY_FLIES]
    mov [skinLoss], rsi

    # Add to food supply
    mov rsi, [foodSupply]
    add rsi, [skinLoss]
    mov [foodSupply], rsi

    # Print message
    lea rsi, fmt_event_fairy
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_event_fairy2
    call PrintString
    lea rsi, FairyASCII
    call PrintString
    jmp .nextDay

.rainbowEvent:
    # Improve skin condition by 20-40%
    mov rsi, [RAINBOW_SKIN_RANGE]
    call GetRandom
    add rsi, [MIN_RAINBOW_SKIN]
    mov [skinLoss], rsi

    # Add to skin condition
    mov rsi, [skinCondition]
    add rsi, [skinLoss]
    cmp rsi, 100    # Cap at 100%
    jle .storeSkinRainbow
    mov rsi, 100
.storeSkinRainbow:
    mov [skinCondition], rsi

    # Print message
    lea rsi, fmt_event_rainbow
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_event_rainbow2
    call PrintString
    lea rsi, RainbowASCII
    call PrintString
    jmp .nextDay

.snakeEvent:
    # Lose 15-35 flies
    mov rsi, [SNAKE_FLIES_RANGE]
    call GetRandom
    add rsi, [MIN_SNAKE_FLIES]
    mov [skinLoss], rsi

    # Subtract from food supply
    mov rsi, [foodSupply]
    sub rsi, [skinLoss]
    mov [foodSupply], rsi

    # Print message
    lea rsi, fmt_event_snake
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_event_snake2
    call PrintString
    lea rsi, SnakeASCII
    call PrintString
    jmp .nextDay

.friendEvent:
    # Gain 15-35% energy
    mov rsi, [FRIEND_ENERGY_RANGE]
    call GetRandom
    add rsi, [MIN_FRIEND_ENERGY]
    mov [skinLoss], rsi

    # Add to energy
    mov rsi, [frogEnergy]
    add rsi, [skinLoss]
    cmp rsi, 100    # Cap at 100%
    jle .storeEnergyFriend
    mov rsi, 100
.storeEnergyFriend:
    mov [frogEnergy], rsi

    # Print message
    lea rsi, fmt_event_friend
    call PrintString
    mov rsi, [skinLoss]
    call PrintInteger
    lea rsi, fmt_event_friend2
    call PrintString
    lea rsi, FriendASCII
    call PrintString
    jmp .nextDay

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
    # distance <= 0 (victory condition)
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
