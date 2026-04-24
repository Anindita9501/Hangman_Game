📌 Overview

This project is a fully functional Hangman Game developed using 8086 Assembly Language and designed to run on EMU8086. It recreates the classic word-guessing game with a text-based interface, ASCII graphics, and interactive gameplay.

The player must guess a hidden word one letter at a time before exceeding the maximum number of incorrect attempts.

✨ Features
🎲 Random Word Selection using system time as a seed
🔤 Word Guessing Mechanism with real-time updates
🧠 Letter Tracking System (prevents duplicate guesses)
🎯 Score System with bonus points for remaining attempts
🏆 High Score Tracking
💀 ASCII Hangman Visualization (6 stages)
📊 Game State Display (word progress, guessed letters, tries left)
🔁 Replay Option after game ends
⏳ Delay Effect for better user experience
🕹️ How the Game Works
A random word is selected from a predefined word bank.
The word is displayed as underscores (_ _ _ _).
The player inputs one letter at a time.
If the guess is:
✅ Correct → Letter is revealed in the word
❌ Incorrect → Hangman progresses + tries decrease
The game ends when:
🎉 All letters are guessed (Win)
💀 Maximum incorrect tries reached (Lose)
🧱 Project Structure
📂 Data Segment
Word bank (10 predefined words)
Game state variables:
Current word
Word display
Guessed letters
Score & High score
Incorrect tries counter
⚙️ Code Segment

Main procedures include:

MAIN → Program entry point
INIT_GAME → Initializes/reset game state
SELECT_RANDOM_WORD → Picks a random word
DISPLAY_GAME_STATE → Shows UI and hangman
GET_USER_INPUT → Takes player input
PROCESS_GUESS → Checks correctness of guess
CHECK_GAME_STATUS → Win/Lose logic
Utility procedures:
PRINT_STRING
PRINT_NUMBER
CLEAR_SCREEN
SLEEP_PROC
🎨 Hangman Stages

The game visually represents incorrect guesses using ASCII art:

Stage 0 → Empty
Stage 1 → Head
Stage 2 → Body
Stage 3 → One arm
Stage 4 → Two arms
Stage 5 → One leg
Stage 6 → Full hangman (Game Over)
🧮 Scoring System
✅ +10 points per correct guess
🎁 Bonus: 20 × remaining tries after winning
🏆 High score is updated automatically
🛠️ Technologies Used
8086 Assembly Language
EMU8086 Emulator
DOS Interrupts (INT 21H, INT 10H, INT 15H)
▶️ How to Run
Open the project in EMU8086
Assemble and run the code
Follow on-screen instructions to play
📚 Learning Outcomes

This project demonstrates:

Low-level programming concepts
Memory and register management
String manipulation in assembly
Use of interrupts for I/O operations
Game logic implementation without high-level abstractions
🚀 Future Improvements
Add difficulty levels
Expand word bank dynamically
Add timer-based gameplay
Improve UI with colors (BIOS interrupts)
Multiplayer mode
🙌 Acknowledgment

Inspired by the classic Hangman game, implemented at a low level to explore system-level programming and logic building.
