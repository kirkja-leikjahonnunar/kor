extends Node

export(Array, PackedScene) var levels

onready var VOID: Spatial = $Void


#------------------------------------------------------------------------------
# One shot once the instance has been created.
#------------------------------------------------------------------------------
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for level in levels:
		var instance = level.instance()
		VOID.add_child(instance)


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
