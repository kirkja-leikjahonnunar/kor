extends Node

# Preload resource assets.
onready var voidling_ps: PackedScene = preload("res://Actors/Voidling/Voidling.tscn")
onready var sign_ps: PackedScene = preload("res://Actors/Sign/Sign.tscn")

# Renaming convinience.
# Node refrences.
onready var NODE_3D: Spatial = $Node3D
onready var UI: Control = $NodeUI

onready var VOID: Spatial = $Node3D/Void

var player: Spatial = null

# Hey.
func Hey(message: String) -> void:
	print(message)
	
func Reparent(node: Node, new_parent: Node):
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	
	print("Reparented to: %s, %s" % [node.get_path(), node.name])

###################
# Godot Functions #
###################

# One shot after our node is instanced.
func _ready() -> void:
	var voidling: Voidling = voidling_ps.instance()
	voidling.Initialize(self, "Harvy / Nuts")
	VOID.add_child(voidling)
	voidling.parent = self


# [ Escape ] key.
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
