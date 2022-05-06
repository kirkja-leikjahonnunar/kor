extends CharacterBody2D


func MovePlayer(new_position):
	print ("MovePlayer, old: ", position, ", new: ", new_position)
	set_position(new_position)
