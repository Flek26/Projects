## Game overview 
### Version 0.0.1

Game made using python

In this game the player(s) will be trying to guess a word, that is selected at random, by guessing one letter at a time, or by taking a guess at the entire word at once.
Each player will have a set number of lives that is initialized at the begining of the game.
Lives will be lost if the player guesses a letter that is incorrect (not in the secret word).
When all (player) lives are lost - that player can no longer guess.
If all players lose lives, the game ends and their is no winner.
Objective of the game is to be the player to guess the secret word!

Components in the game

-Player - Behaviors
	- able to give their player a name or a alias
	- able to guess single characters
	- able to guess strings to achive the entire word
	
- ASCII Board - Behaviors
	- prints the player that made the last guess
	- prints the number of lives that player has
	- prints the word in hangman form
    		- ex: if you guess 'a' the word "hangman" would look like "_ a _ _ _ a _"
	
## Files	
  
### hangman.py: 
- The current most up to date version of the game. This is a python file.

### words.txt
- List of 200(at the time of writing) random words.
 - I plan to update this list with themed word lists down the line (ex: Halloween, Christmas, coding, animal, etc).

## Pictures
Starting game configuration and character selection:
![alt text](https://imgur.com/SJQOhnc)

First look at the board (word is randomly selected from the file words.txt) and player1 gets to make a guess:
![alt text](https://imgur.com/bIfH6jO)

Player1 (Luke) guessed a, still has three lives left, and the word in hangman form was updated
![alt text](https://imgur.com/e4FhHcn)

Bob guessed the letter b, it was not in the secret word so bob lost a life. This cycle repeats until all players are out of lives or the word is guessed.
![alt text](https://imgur.com/eZwbNe0)

If you try to guess a letter that has already been guessed:
![alt text](https://imgur.com/OmpS94n)

If you guess the word:
![alt text](https://imgur.com/WF5SMtc)

Final guess was correct:
![alt text](https://imgur.com/4v7Neow)

What happens when all lives are gone for everyone:
![alt text](https://imgur.com/DqtJXWw)
