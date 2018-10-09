## Game overview

Game made using Unity

In this game the player will be trying to catch objects that are falling from the trop of the screen while moving back and forth to avoid the bad objects. 
Points will be scored when the player catches the desired object.
Lives will be lost if the player catches a bad item or fails to catch a desired object.
When all lives are lost - GAME OVER
Objective of the game is to achive the highest score possible.

Components ( Phyisical objects) in the game

-Player - Behaviors
	- Move left and right using the arrow keys and a,d keys
	- At screen edges, block movement or wrap around
	- When hit by undesired object, lose a life.
	
- Falling Object - Behaviors
	- Move from the top of the screen to the bottom
	- When falling off the bottom, move back to the top and fall again
	- When hiting a player, deduct a life, and move back to the top and fall again
	
- Other things to do:
	- add sounds (voices, drops, catches, level up, life down, etc)
	- add particle effects
	- UI for score, lives, menus
	- power ups
	- extra lifes
	
	
	
