@tool
extends Control

@export var grab_settings := false:
	get:
		return false
	set(value):
		if value == true:
			if Engine.is_editor_hint():
				SetBindingsFromCurrentEditor()

#TODO: settings UI
# - press any key should be a different color
# - restore defaults option.. all at once? per item?
# - option to clear binding
# - don't clobber existing bind to other action
# - save to file on change of binding
# - use physical key, but display user keys?
# - UI should be updatable by a language flag somehow
# - appears to be a bug in ProjectSettings in editor returing 0 event keycode
#       see also: https://github.com/godotengine/godot/issues/25865
#       https://github.com/godotengine/godot/issues/44776
# - key bindings should have saveable sets to/from file (done), maybe settings file is an array of settings?
# - need better styling, probably a "Settings" header (done) too
#
# - DONE mouse down issue, also arrow keys move focus.. all input should be blocked until input
#
# see:
#   OS.get_keycode_string
#   DisplayServer.keyboard_get_keycode_from_physical

# this should be translatable, or do some UI gimmick to indicate nothing
var unassigned := "Unassigned"

# These must match your the InputMap actions:
var actions := {
		# index is physical key code, or mouse button number
		#"action": { "label": "Human Readable", "index": 4, "is_mouse": false } 
		"char_forward":      { "label": "Forward", "index": -1, "is_mouse": false },
		"char_backward":     { "label": "Backward", "index": -1, "is_mouse": false },
		"char_strafe_left":  { "label": "Left", "index": -1, "is_mouse": false },
		"char_strafe_right": { "label": "Right", "index": -1, "is_mouse": false },
		"char_rotate_left":  { "label": "Rotate Left", "index": -1, "is_mouse": false },
		"char_rotate_right": { "label": "Rotate Right", "index": -1, "is_mouse": false },
		"char_fly_up":       { "label": "Up", "index": -1, "is_mouse": false },
		"char_fly_down":     { "label": "Down", "index": -1, "is_mouse": false },
		"char_jump":         { "label": "Jump", "index": -1, "is_mouse": false },
		"char_sprint":       { "label": "Sprint", "index": -1, "is_mouse": false },
		"char_toggle_mouse": { "label": "Toggle mouse", "index": -1, "is_mouse": false },
		"char_crouch":       { "label": "Crouch", "index": -1, "is_mouse": false },
		"char_use1":         { "label": "Use 1", "index": -1, "is_mouse": false },
		"char_use2":         { "label": "Use 2", "index": -1, "is_mouse": false },
		"char_use3":         { "label": "Use 3", "index": -1, "is_mouse": false },
		"char_zoom_in":      { "label": "Zoom in", "index": -1, "is_mouse": false },
		"char_zoom_out":     { "label": "Zoom out", "index": -1, "is_mouse": false },
		"char_camera_hover": { "label": "Camera hover", "index": -1, "is_mouse": false }, # selects which side of player to hover camera 
	}

var settings := {
		"fov_degrees": 75.0,
		"mouse_sensitivity": 1.0,
		"invert_x": false,
		"invert_y": false,
		"bindings": actions
	}
var settings_file = "res://TEST-SETTINGS-FILE.json"



# Return success (true) or failure (false).
func LoadSettings(file: String):
	var player_data_file = File.new()
	if player_data_file.open(file, File.READ) != OK:
		print_debug("Could not open settings file! ", file)
		return

	var json := JSON.new()
	var err = json.parse(player_data_file.get_as_text())
	player_data_file.close()
	if err == OK:
		print ("Settings loaded: ", settings)
		# *** Verify settings is not corrupted
		# *** install settings from json.get_data()
		ApplySettings()
	else:
		print_debug("Error parsing settings file ", file)


#TODO: settings needs to be sanitized
# Assuming settings is current, apply its values to various widgets.
func ApplySettings(with_bindings: bool = true):
	for key in settings:
		match key:
			"fov_degrees":
				$VBoxContainer/ScrollContainer/Settings/HBoxContainer/FOV.text = str(settings[key])
			"mouse_sensitivity":
				$VBoxContainer/ScrollContainer/Settings/HBoxContainer2/Sensitivity.text = str(settings[key])
			"invert_x":
				$VBoxContainer/ScrollContainer/Settings/HBoxContainer3/InvertX.button_pressed = settings[key]
			"invert_y":
				$VBoxContainer/ScrollContainer/Settings/HBoxContainer3/InvertX.button_pressed = settings[key]
			"bindings":
				if with_bindings:
					print_debug("TODO apply bindings")


# Return success (true) or failure (false).
func SaveSettings(filename: String) -> bool:
	var json := JSON.new()
	var json_string = json.stringify(settings, '  ')
	
	var file = File.new()
	var err = file.open(filename, File.WRITE)
	if err != OK:
		return false
	file.store_string(json_string)
	file.close()
	print ("Settings saved to file ", filename)
	return true # false would be database/sql error for instance


func SetBindingsFromCurrentLive():
	print ("SetBindingsFromCurrentLive()...")
	
	print ("actions before: ", actions)
	var cur_actions = InputMap.get_actions()
	print ("cur_actions: ", cur_actions)
	for action in cur_actions:
		print ("check action: ", action)
		if action in actions:
			var evs = InputMap.action_get_events(action)
			if evs == null || evs.size() == 0:
				actions[action]["index"] = -1
			else:
				#actions[action] = evs[0] #.as_text()
				if evs[0] is InputEventKey:
					actions[action]["key"] = evs[0].get_keycode_with_modifiers()
					print ("Grabbing key event: ", evs[0], ", keycode: ", evs[0].get_keycode(),
						", kkm: ", evs[0].get_keycode_with_modifiers(),
						#", kkstr: ", OS.get_keycode_string(evs[0])
						)
				elif evs[0] is InputEventMouse:
					actions[action]["mouse"] = evs[0].button_mask
					print ("Grabbing mouse event: ", evs[0], ", button: ", evs[0].get_button_mask())
			print (actions[action])


func SetBindingsFromCurrentEditor():
	#print ("actions before: ", actions)
	for action in actions:
		print ("check action: ", action)
		if ProjectSettings.has_setting("input/"+action):
			var setting = ProjectSettings.get_setting("input/"+action)
			print (action, ": ", setting)
			var events = setting.events
			print ("events: ", typeof(events), " ",  events.size(), events)
			var found_key = null
			if events.size() != 0:
				print ("events[0]: ", events[0])
				found_key = events[0].keycode #FIXME: WHY IS THIS ZERO??????
				print ("e0.keycode: ", events[0].keycode)
				var is_physical = events[0].physical_keycode
				print ("found ", action, ": ", found_key, " ", is_physical, "  ", OS.get_keycode_string(found_key), 
						", mapped: ", OS.get_keycode_string(DisplayServer.keyboard_get_keycode_from_physical(found_key)))
			else:
				print ("found ", action, ": Unassigned")
		else:
			print ("action ",action," not in ProjectSettings")


func PopulateMenuWithBindings():
	for action in actions:
		var def = actions[action]
		var hbox := HBoxContainer.new()
		hbox.name = action
		var label := Label.new()
		label.name = action+"-Label"
		hbox.add_child(label)
		var button := KeyBindButton.new()
		button.name = action+"-Button"
		button.action = action
		if def == null:
			label.text = action
			button.text = unassigned
		else:
			label.text = def["label"]
			if "key" in def:
				if def.key <= 0: button.text = unassigned
				else: button.text = "key: "+str(def.key)
			elif "mouse" in def:
				if def.mouse <= 0: button.text = unassigned
				else: button.text = "mouse: "+str(def.mouse)
			else:
				button.text = unassigned
		label.size_flags_horizontal = SIZE_EXPAND_FILL
		button.size_flags_horizontal = SIZE_EXPAND_FILL
		hbox.add_child(button)
		$VBoxContainer/ScrollContainer/Settings.add_child(hbox)


func _ready():
	if not Engine.is_editor_hint():
		#LoadSettings(settings_file)
		SetBindingsFromCurrentLive()
		#SaveSettings(settings_file)
		PopulateMenuWithBindings()
		ApplySettings(false)
