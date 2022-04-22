extends Control

# Main Login Controls.
#onready var MAIN_LOGIN_WINDOW := $MainLoginWindow
@onready var USERNAME_IN := $MainLoginWindow/VBoxContainer/Username
@onready var PASSWORD_IN := $MainLoginWindow/VBoxContainer/Password
#onready var OPINE := $Opine

#onready var GATEWAY_IP_IN := $MainLoginWindow/TabContainer/Velmeran/VBoxContainer/HBoxContainer/GatewayIP
#onready var GATEWAY_PORT_IN := $MainLoginWindow/TabContainer/Velmeran/VBoxContainer/HBoxContainer/GatewayPort

# New Account Controls.
#onready var NEW_ACCOUNT_WINDOW := $NewAccountWindow
#onready var NEW_USERNAME_IN := $NewAccountWindow/NewUsername
#onready var NEW_PASSWORD_IN := $NewAccountWindow/NewPassword
#onready var REPEAT_PASSWORD_IN := $NewAccountWindow/RepeatPassword
#onready var RECOVERY_EMAIL_IN := $NewAccountWindow/RecoveryEmail
#onready var CREATE_ACCOUNT_BUTTON := $NewAccountWindow/CreateAccount
#onready var MAIN_LOGIN_BUTTON := $NewAccountWindow/MainLogin


@onready var gateway_ip: String
@onready var gateway_port: int

func _ready():
	USERNAME_IN.grab_focus()
	

# pop up a message for user
func Opine(message: String):
	#OPINE.text = message
	print(message)

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


func _on_login_pressed():
#	pass # Replace with function body.
	gateway_ip = "127.0.0.1"
	gateway_port = 1910
	AttemptLogin()

#func _on_LAN_Button_pressed():
#	gateway_ip = "192.168.202.202"
#	gateway_port = 1910
#	AttemptLogin(gateway_ip, gateway_port)
#
#func _on_Velmeran_Button_pressed():
#	gateway_ip = GATEWAY_IP_IN.get_text()
#	gateway_port = GATEWAY_PORT_IN.get_text()
#	AttemptLogin(gateway_ip, gateway_port)
#
#
#func _on_NewAccount_pressed():
#	MAIN_LOGIN_WINDOW.hide()
#	NEW_ACCOUNT_WINDOW.show()
#
#func _on_CreateAccount_pressed():
#	if NEW_USERNAME_IN.get_text() == "":
#		Opine("Please provide a valid username.")
#	elif NEW_PASSWORD_IN.get_text() == "":
#		Opine("Please provide a valid password.")
#	elif REPEAT_PASSWORD_IN.get_text() == "":
#		Opine("Please repeat your password.")
#	elif NEW_PASSWORD_IN.get_text() != REPEAT_PASSWORD_IN.get_text():
#		Opine("Passwords don't match.")
#	elif NEW_PASSWORD_IN.get_text().length() <= 6:
#		Opine("Password must contain at least 7 characters.")
#	else:
#		CREATE_ACCOUNT_BUTTON.disabled = true
#		MAIN_LOGIN_BUTTON.disabled = true
#		var username = NEW_USERNAME_IN.get_text()
#		var password = NEW_PASSWORD_IN.get_text()
#		Gateway.ConnectToGatewayServer(username, password, gateway_ip, gateway_port)

#func _on_MainLogin_pressed():
#	MAIN_LOGIN_WINDOW.show()
#	NEW_ACCOUNT_WINDOW.hide()


