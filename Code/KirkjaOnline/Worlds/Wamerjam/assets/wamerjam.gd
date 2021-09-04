extends Node2D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
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
