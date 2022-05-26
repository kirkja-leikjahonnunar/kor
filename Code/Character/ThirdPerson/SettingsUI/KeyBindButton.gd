class_name KeyBindButton
extends Button


var waiting_for_input := false

var action : String
var action_index := 0
var is_mouse := false
var old_text : String


func _ready():
	toggle_mode = true
	action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	#toggled.connect(_toggled)
	button_up.connect(_on_button_up)


func _input(event):
	if not waiting_for_input: 
#		if event is InputEventMouseButton && event.pressed == true:
#			print ("button down, now waiting for input")
#			waiting_for_input = true
#			old_text = text
#			text = "Press any key"
		return
	
	if event is InputEventKey:
		if event.physical_keycode != KEY_ESCAPE:
			action_index = event.physical_keycode
			is_mouse = false
			text = event.as_text()
		else:
			text = old_text
		waiting_for_input = false
		button_pressed = false
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton:
		print ("mouse button event: ", event.pressed," ", event.button_mask)
		if event.pressed:
			action_index = event.button_mask
			is_mouse = true
			text = "mouse: "+str(event.button_mask)
			waiting_for_input = false
			button_pressed = false
			get_viewport().set_input_as_handled()
	
	if not waiting_for_input:
		print ("new action ", text, " now: ", action_index, ", mouse: ", is_mouse)


func _toggled(value):
	print (".. toggled in ",name,": ", value, ", waiting: ", waiting_for_input, ", b is pressed: ", button_pressed)
	
#	if value && not waiting_for_input:
#		print ("toggled, now waiting for input")
#		waiting_for_input = true
#		old_text = text
#		text = "Press any key"


func _on_button_up():
	if waiting_for_input == false:
		print ("button down, now waiting for input")
		waiting_for_input = true
		old_text = text
		text = "Press any key"
