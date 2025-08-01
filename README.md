# 🎲 Greed Dice Game (Ruby 2.6.6)

Greed is a multiplayer dice game where players roll five dice, accumulate points, and try to be the first to reach 3000 points. Once a player reaches 3000 or more, the game enters a final round where all other players get one last turn.

---

## 📁 Project Structure

All files are placed inside the `solution/` folder:

solution/
│
├── dice_set.rb # Dice rolling logic
├── score.rb # Score calculation logic
├── player.rb # Player class tracking score and state
├── game.rb # Main game loop and logic
├── greed_game.rb # Script to run the game
├── game_spec.rb # RSpec test file
├── README.md # Project documentation (this file)



---

## 🧠 Class and Method Documentation

### 📦 `dice_set.rb`

**Class:** `DiceSet`

- `def roll(n)`
  - Rolls `n` six-sided dice and returns an array of integers (1 to 6).
  - Example: `roll(5)` → `[2, 6, 1, 4, 3]`

---

### 📦 `score.rb`

**Method:** `score(dice_array)`

- Calculates the score for a given roll according to Greed rules.
- Handles triplets and single scoring dice.
- Example: `score([1,1,1,5])` → `1050`

Scoring Rules:
- Three 1s → 1000 pts
- Three of any other number `n` → `n * 100` pts
- One 1 → 100 pts
- One 5 → 50 pts

---

### 📦 `player.rb`

**Class:** `Player`

- **Attributes:**
  - `name`: Player's name ("Player 1", "Player 2", etc.)
  - `total_score`: Accumulated game score
  - `in_game`: Flag to indicate if player passed the 300-point threshold

- **Methods:**
  - `initialize(name)`: Creates a new player with 0 score.
  - `add_score(score)`
    - If player is not yet "in the game", requires score ≥ 300 in a single round to begin tracking.
    - Once "in the game", all round scores are added to total.

---

### 📦 `game.rb`

**Class:** `Game`

- **Constants:**
  - `FINAL_SCORE = 3000`

- **Instance Variables:**
  - `@players`: Array of Player objects
  - `@dice_set`: Instance of `DiceSet` for rolling
  - `@final_round_triggered`: Boolean, true once a player hits 3000+
  - `@final_trigger_index`: Index of the player who triggered final round

- **Methods:**
  - `play`: Main game loop
    - Loops turn-by-turn until someone hits `FINAL_SCORE`
    - Triggers final round where all *other* players get one last turn
    - Displays player rolls, scores, and decisions
  - `take_turn(player, initial_roll)`
    - Handles scoring, re-rolling non-scoring dice, and user interaction
  - `get_scoring_dice(dice)`
    - Returns the subset of dice that contribute to score (to determine what’s left to reroll)

---

## ▶️ How to Run the Game

Make sure you're in the `solution/` directory:

cd solution
Then run the game with:
ruby greed_game.rb
You'll be prompted to enter the number of players, and then the game will proceed turn by turn.

✅ How to Run the Tests
This project uses RSpec 3.10.x for unit testing.

1. Make sure rspec is installed:
gem install rspec -v 3.10

2. Run tests:
rspec game_spec.rb

You should see all tests pass for:

Score calculation
Player state handling
Game mechanics

💡 Sample Gameplay Output

Enter number of players: 2

Turn 1:
--------
Player 1 rolls: 5, 5, 1, 1, 2
Score in this round: 250
Total score: 0
Do you want to roll the non-scoring 1 dice? (y/n): n

Player 2 rolls: 2, 3, 1, 1, 3
Score in this round: 200
Total score: 0
Do you want to roll the non-scoring 3 dices? (y/n): y
Player 2 rolls: 2, 3, 2
Score in this round: 0
Total score: 0


🛠 Ruby Version
This project is designed for:

Ruby 2.6.6

RSpec 3.10.x

📌 Credits
Based on the Greed Dice game rules defined in the Ruby Koans project with customized behavior for:

"Get in the game" rule (min 300 in one round)

Final round logic

Terminal-based interaction

Happy rolling! 🎲


