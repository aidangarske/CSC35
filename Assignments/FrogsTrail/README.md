# Frogs Trail

A text-based adventure game where you help a brave frog journey across dangerous lily pads to reach the Great Pond.

## Game Overview

You play as a frog who must travel across a series of lily pads to reach the legendary Great Pond. Along the way, you'll need to manage several vital resources:

- **Distance Left**: How many lily pads remain until you reach the Great Pond
- **Skin Condition**: Your frog's skin moisture level (0-100%)
- **Energy Level**: Your frog's energy reserves (0-100%)
- **Food Supply**: Number of flies you have stored for food

## Game Mechanics

On each turn, you can choose one of 6 actions:

1. **Rest in the Sun** (1-5 days)
   - Restores 30-60% energy
   - Consumes food each day

2. **Moisturize Skin** (1-3 days)
   - Improves skin condition by 10-50%
   - Consumes food each day

3. **Hunt for Flies** (1 day)
   - Catch 20-200 flies to add to food supply
   - Consumes food

4. **Hop Forward** (1 day)
   - Advance 5-80 lily pads
   - Dries out skin and uses energy
   - Consumes food

5. **Find Temporary Pond** (2-4 days)
   - Restores 20-40% to both energy and skin
   - Consumes food each day

6. **Trade with Other Frogs** (1 day)
   - Gamble flies for better supplies
   - Can gain or lose flies
   - Consumes food

Each day, your frog needs to eat 5-10 flies to survive. If you run out of food, you'll start losing energy rapidly.

## Random Events

There's a 20% chance each day of encountering a random event:
- Thunderstorms that drain energy
- Friendly fairies that give extra flies
- Rainbow blessings that restore stats
- Dangerous snakes that cause damage
- Fellow frogs that share supplies

## How to Run

1. Clone this repository

```
git clone https://github.com/yourusername/CSC35.git
```

2. Navigate to the FrogsTrail directory

```
cd CSC35/Assignments/FrogsTrail
```

3. Assemble, link, and run:

```
curl devincook.com/csc/csc35.o > csc35.o
as -o FrogsTrail.o FrogsTrail.asm
ld -o FrogsTrail FrogsTrail.o csc35.o
./FrogsTrail
```
