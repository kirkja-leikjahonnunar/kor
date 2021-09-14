extends Node

onready var BUTTON = get_node("../LoginScreen/VBoxContainer/Button")

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = "127.0.0.1"
var port = 2019

var username
var password

#------------------------------------------------------------------------------
# Ready to roll
#------------------------------------------------------------------------------
func _ready():
	pass
	
func _process(delta):
	if get_custom_multiplayer() == null:
		return
		
	if custom_multiplayer.has_network_peer():
		return
		
	custom_multiplayer.poll()

#------------------------------------------------------------------------------
# Create a client for the network and connect the listener functions.
#------------------------------------------------------------------------------
func ConnectToServer(_username, _password):
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	username = _username
	password = _password
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")

#------------------------------------------------------------------------------
# Connection failed.
#------------------------------------------------------------------------------
func _OnConnectionFailed():
	print("Failed to connect to login server.")
	BUTTON.disabled = false

#------------------------------------------------------------------------------
# Connection succeeded.
#------------------------------------------------------------------------------
func _OnConnectionSucceeded():
	print("Succesfuly connected.")
	RequestLogin()
	

#------------------------------------------------------------------------------
# Get the password from the server.
#------------------------------------------------------------------------------
func RequestLogin():
	print("Connecting to login server.")
	rpc_id(1, "LoginRequest", username, password) # Of the Server.
	username = ""
	password = ""

#------------------------------------------------------------------------------
# RPC for Server to connect with.
#------------------------------------------------------------------------------
remote func ReturnLoginRequest(results):
	print("Results recieved")
	if results == true:
		Server.ConnectToServer()
		queue_free()
	else:
		print("Please provide a valid username and password.")
		BUTTON.disabled = false
		
	network.disconnect("connection_failed", self, "_OnConnectionFailed")
	network.disconnect("connection_succeeded", self, "_OnConnectionSucceeded")
