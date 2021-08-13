extends Node

# Resources.
const VOIDLING_PS: PackedScene = preload("res://Lawforms/Voidling/Voidling.tscn")
const bubble_ps: PackedScene = preload("res://Lawforms/Bubble/Bubble.tscn")

# Nodes.
onready var VOID: Spatial = $Node3D/Void

# Hey.
func Hey(message: String) -> void:
	print(message)


#------------------------------------------------------------------------------
# One shot once the instance has been created.
#------------------------------------------------------------------------------
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var voidling: Voidling = VOIDLING_PS.instance().Init(self, $WorldEnvironment/Planet, "Harvy / Nuts")
	voidling.translation = Vector3.ZERO
	VOID.add_child(voidling)
	print("Ready")


#------------------------------------------------------------------------------
# [ Escape ] key. Quit game.
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
