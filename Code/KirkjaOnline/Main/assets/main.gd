extends Node
class_name Main

# Preload resource assets.
onready var voidling_ps: PackedScene = preload("res://Actors/Voidling/Voidling.tscn")
onready var sign_ps: PackedScene = preload("res://Actors/Signpost/Signpost.tscn")
onready var bubble_ps: PackedScene = preload("res://Actors/Bubble/Bubble.tscn")

# Node refrences.
onready var VOID: Spatial = $Node3D/Void

var player: Spatial = null

# Hey.
func Hey(message: String) -> void:
	print(message)
	
#func HeyUI(message: String) -> void:
#	DEBUGUI.Print(message)
	
func Reparent(node: Node, new_parent: Node):
	node.get_parent().remove_child(node)
	new_parent.add_child(node)
	
	print("Reparented to: %s, %s" % [node.get_path(), node.name])
	
#func AddMe(node: Node):
#	VOID.add_child(node)

###################
# Godot Functions #
###################

# One shot after our node is instanced.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var voidling: Voidling = voidling_ps.instance()
	voidling.Initialize(self, "Harvy / Nuts")
	voidling.translation = Vector3(0, 2, 0)
	VOID.add_child(voidling)
	
	


# [ Escape ] key.
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
	if event is InputEventJoypadButton:
		if event.pressed and event.button_index == 11: # Joypad [Start] button.
			get_tree().quit()


# Spawn bubble.
func _on_Timer_timeout() -> void:
	var bubble = bubble_ps.instance()
	
	VOID.add_child(bubble)
