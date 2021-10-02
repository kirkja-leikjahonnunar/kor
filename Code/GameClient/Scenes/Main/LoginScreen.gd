extends Control

onready var username_input = $Username
onready var password_input = $Password
onready var login_button = $Button
onready var opine = $Opine


func Opine(message):
	opine.text = message
	print(message)

func _on_Button_pressed():
	if username_input.text == "" or password_input.text == "":
		Opine("Please provide username and password.")
	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = password_input.get_text()
		Opine("Attempting to login...")
		# TODO: Set timer.
		Gateway.ConnectToServer(username, password)
