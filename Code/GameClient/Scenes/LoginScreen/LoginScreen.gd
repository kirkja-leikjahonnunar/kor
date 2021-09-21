extends Control

onready var USERNAME_INPUT = $VBoxContainer/Username
onready var PASSWORD_INPUT = $VBoxContainer/Password
onready var BUTTON = $VBoxContainer/Button


func _on_Button_pressed():
	if USERNAME_INPUT.text == "" or PASSWORD_INPUT.text == "":
		# TODO: Make a message UI for the player to know when it failed.
		print("Please provide valid username and password to continue.")
	else:
		# So the user doesn't spam the login button.
		BUTTON.disabled = true
		var username = USERNAME_INPUT.get_text()
		var password = PASSWORD_INPUT.get_text()
		print("Attempting to login.")
		Gateway.ConnectToServer(username, password)
