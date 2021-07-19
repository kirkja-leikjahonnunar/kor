extends Node

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


#------------------------------------------------------------------------------
# One shot once the instance has been created.
#------------------------------------------------------------------------------
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var voidling: Voidling = voidling_ps.instance().Init(self, "Harvy / Nuts")
	voidling.translation = Vector3.ZERO
	VOID.add_child(voidling)
	print("Ready")


#------------------------------------------------------------------------------
# [ Escape ] key.
#------------------------------------------------------------------------------
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
	if event is InputEventJoypadButton:
		if event.pressed and event.button_index == 11: # Joypad [Start] button.
			get_tree().quit()


#------------------------------------------------------------------------------
# Spawn bubble.
#------------------------------------------------------------------------------
func _on_Timer_timeout() -> void:
	var bubble = bubble_ps.instance()
	
	VOID.add_child(bubble)
