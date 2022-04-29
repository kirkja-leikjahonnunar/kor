extends Control

var following = false
var dragging_start_position = Vector2.ZERO

func _on_TitleBar_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			following = !following
			dragging_start_position = get_local_mouse_position()
			
			
func _process(delta_time):
	if following:
		OS.set_window_position(OS.window_position + get_global_mouse_position() - dragging_start_position)


func _unhandled_input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()


func _on_QuitButton_pressed():
	get_tree().quit()
