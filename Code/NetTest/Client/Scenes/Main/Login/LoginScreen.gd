extends Control

# Main Login Controls.

@onready var gateway_ip: String
@onready var gateway_port: int


# pop up a message for user
func Opine(message: String):
	#OPINE.text = message
	print(message)

func AttemptLogin():
	GatewayServer.ConnectToServer()


func _on_login_pressed():
#	pass # Replace with function body.
	gateway_ip = "127.0.0.1"
	gateway_port = 1910
	AttemptLogin()



