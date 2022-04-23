extends Control

# Main Login Controls.
@onready var USERNAME_IN := $MainLoginWindow/VBoxContainer/Username
@onready var PASSWORD_IN := $MainLoginWindow/VBoxContainer/Password

var gateway_ip: String
var gateway_port: int


func _ready():
	USERNAME_IN.grab_focus()


# pop up a message for user
func Opine(message: String):
	#OPINE.text = message
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
		#login_button.disabled = true
		var username = USERNAME_IN.get_text()
		var password = PASSWORD_IN.get_text()
		Opine("Attempting to login...")
		# TODO: Set timer.
		GatewayServer.ConnectToServer(username, password)



