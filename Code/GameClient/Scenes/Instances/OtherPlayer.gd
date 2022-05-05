extends CharacterBody2D


func MovePlayer(new_position):
	print ("MovePlayer, old: ", position, ", new: ", new_position)
	position = new_position
