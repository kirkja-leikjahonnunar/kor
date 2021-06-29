extends Node

# Preload resource assets.
onready var voidling_ps: PackedScene = preload("res://Actors/Voidling/Voidling.tscn")
onready var sign_ps: PackedScene = preload("res://Actors/Sign/Sign.tscn")

var player: Spatial = null

func Hey():
	print("Hey!")

###################
# Godot Functions #
###################

# One shot after our node is instanced.
func _ready() -> void:
	var voidling: Voidling = voidling_ps.instance()
	voidling.Initialize(self)
	add_child(voidling)

	
#	var i: int = 3
#	for pn in ["they / them", "he / she", "any / all"]:
#		var voidling: Spatial = voidling_ps.instance()
#		voidling.pronouns = pn
#		voidling.translation = Vector3(i * 100, 200, 0) # Ekki "voidling.position".
#		add_child(voidling)
#		i += 1


# [ Escape ] key.
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
