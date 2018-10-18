import random
import os.path

#Declare variables
#Dictionary that will store names and lives
name_dict = {'d1':{},'d2' :{}}

#List that will hold the values that are the current board list
current = []

#word that the players will try to guess, gets the relative path of the word list
#Pulls a random word from there after they are broken up by line
my_path = os.path.abspath(os.path.dirname(__file__))
path = os.path.join(my_path, "words.txt")
select_word = open(path).read().splitlines()
word = random.choice(select_word)

#Initialize lives to 0
total_lives = 0

#decided how many guesses each player gets
guesses = int(input("How many lives per player?: "))

#holds list of letters already guesses
letter = []

# Puts the secret word into a list to be accessed later, this list is current from above ^^
for i in word:
  if(i == " "):
    current.append(' ')     
  else:
    current.append('_')


#Ask for how many players
j = int(input("How many players?: "))

#Ask and store names for each player 
for i in range(1,j+1):
  name = input("What is your name? ")
  print (f"Hello {name}! You are Player{i}")
  name_dict['d1'][i] = name
  name_dict['d2'][i] = guesses

#Get the total amount of lives to keep running the game while at least one person has >= 1 life.If all lives are 0, the game will end.
for i in name_dict['d2']:
  total_lives = total_lives + name_dict['d2'][i]

# Print the board function.
def board(name,y):
  print('====================================')
  print('              Board:                ')
  print('====================================')
  print(f'Player: {name} played this:')
  print("Word: ")
  for k in current:
    print(k + ' ', sep=' ', end='', flush=True)
  print('.')
  print(f"{name} has {y} lives left")
  print('====================================')
  print('            Next Player:            ')
  print('====================================')


#Print the original board for first player guess
board('Original Board', name_dict['d2'][i])

#Game mechanics:

#Run the game until all players are out of lives or until the guessed word has been guessed.
while total_lives > 0 or ''.join(word) == ''.join(current):

  for i in name_dict['d1']:
    if(name_dict['d2'][i] <= 0):
      print(f"Sorry {name_dict['d1'][i]}, you are out of lives. You can not guess.")
    else:
      guess = input(f"{name_dict['d1'][i]}, what would you like to guess? (single letter or try to guess the word): ")

      #This checks if the guess has already been guessed. and will ask for another guess until there is a correct guess.
      while (guess in letter):
        print(f"Sorry {name_dict['d1'][i]}, that letter has already been guessed! ")
        guess = input(f"{name_dict['d1'][i]}, what would you like to guess?(single letter or try to guess the word): ")

      #if the user gueses the whole word  
      if(''.join(guess) == ''.join(word)):
        junk = 0
        for k in word:
          current[junk] = word[junk]
          junk = junk + 1
        break
      #Iterates through the current list and puts the guessed letter in the same index that it appears in the 'word' string.
      if(guess in word):
        junk = 0
        #Adds the guessed letter to the string that stores the previously guessed answers
        letter.append(guess)
        for k in word:
          if(k == guess):
            current[junk] = guess
          junk = junk + 1
      #Removes one life from the players life if they guessed a wrong letter
      if(guess not in word):
        name_dict['d2'][i] =  name_dict['d2'][i] - 1
        total_lives = total_lives - 1
        letter.append(guess)
      
    #Print the board after the user is done, so it updates for the next player
      board( name_dict['d1'][i], name_dict['d2'][i] )
      if(total_lives == 0):
        break
      if(''.join(word) == ''.join(current)):
        break
  if(total_lives == 0):
    break
  if(''.join(word) == ''.join(current)):
    break

#End game cases
if(''.join(word) == ''.join(current)):
  print("Congrats! You guessed the word!")
else:
  print("You failed to guess the word! All players lose!")

print(f'The word was: {word}')


