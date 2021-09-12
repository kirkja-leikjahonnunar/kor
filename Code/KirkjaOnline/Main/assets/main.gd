extends Node

onready var VOID: Spatial = $Node3D/Void


#------------------------------------------------------------------------------
# One shot once the instance has been created.
#------------------------------------------------------------------------------
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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
