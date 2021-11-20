extends Control

onready var USERNAME_IN: LineEdit = $Username
onready var PASSWORD_IN: LineEdit = $Password
onready var OPINE: Label = $Opine

func _ready():
	USERNAME_IN.grab_focus()

func Opine(message: String):
	OPINE.text = message
	print(message)

#func _on_Button_pressed():
func AttemptLogin(ip):
	if USERNAME_IN.text == "" or PASSWORD_IN.text == "":
		Opine("Please provide a username and password.")
	else:
		#login_button.disabled = true
		var username = USERNAME_IN.get_text()
		var password = PASSWORD_IN.get_text()
		Opine("Attempting to login...")
		# TODO: Set timer.
		Gateway.ConnectToGatewayServer(username, password, ip)


func _on_Localhost_Button_pressed():
	AttemptLogin("127.0.0.1")


func _on_LAN_Button_pressed():
	AttemptLogin("192.168.202.202")


func _on_Velmeran_Button_pressed():
	AttemptLogin("73.67.218.85")
