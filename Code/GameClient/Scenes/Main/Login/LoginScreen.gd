extends Control

# Main Login Controls.
@onready var USERNAME_IN := $MainLoginWindow/VBoxContainer/Username
@onready var PASSWORD_IN := $MainLoginWindow/VBoxContainer/Password
@onready var LOGIN_BUTTON = $MainLoginWindow/VBoxContainer/HBoxContainer/Login
@onready var REGISTER_BUTTON = $MainLoginWindow/VBoxContainer/HBoxContainer/Register
@onready var OPINE = $MainLoginWindow/VBoxContainer/Opine

var gateway_ip: String
var gateway_port: int


func _ready():
	USERNAME_IN.grab_focus()


# pop up a message for user
func Opine(message: String):
	OPINE.text = message
	print(message)


func _on_login_pressed():
#	pass # Replace with function body.
	gateway_ip = "127.0.0.1"
	gateway_port = 1910
	AttemptLogin()


func AttemptLogin():
	if USERNAME_IN.text == "" or PASSWORD_IN.text == "":
		Opine("Please provide a username and password.")
	else:
		LOGIN_BUTTON.disabled = true
		REGISTER_BUTTON.disabled = true
		var username = USERNAME_IN.get_text()
		var password = PASSWORD_IN.get_text()
		Opine("Attempting to login...")
		# TODO: Set timer.
		GatewayServer.ConnectToServer(username, password)


func ConnectionFailed():
	Opine("Client connection to gateway failed!")
	LOGIN_BUTTON.disabled = false
	REGISTER_BUTTON.disabled = false


func LoginRejected():
	Opine("Bad username or password.")
	LOGIN_BUTTON.disabled = false
	REGISTER_BUTTON.disabled = false


func _on_register_pressed():
	if USERNAME_IN.text == "" or PASSWORD_IN.text == "":
		Opine("Please provide a username and password.")
	
